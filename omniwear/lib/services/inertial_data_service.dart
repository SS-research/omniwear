import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:omniwear/config/config_manager.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:rxdart/rxdart.dart';

// Utility function to convert frequency to milliseconds
int convertFrequencyToMilliseconds(double frequency) {
  if (frequency <= 0) {
    throw ArgumentError('Frequency must be greater than zero');
  }
  return (1000 / frequency).round();
}

class InvalidInertialFeatureException implements Exception {
  final String feature;

  InvalidInertialFeatureException(this.feature);

  @override
  String toString() => 'Invalid inertial feature: $feature';
}

class InertialDataModel {
  final DateTime timestamp;
  final DateTime? smartphoneAccelerometerTimestamp;
  final double? smartphoneAccelerometerX;
  final double? smartphoneAccelerometerY;
  final double? smartphoneAccelerometerZ;
  final DateTime? smartphoneGyroscopeTimestamp;
  final double? smartphoneGyroscopeX;
  final double? smartphoneGyroscopeY;
  final double? smartphoneGyroscopeZ;
  final DateTime? smartphoneMagnometerTimestamp;
  final double? smartphoneMagnometerX;
  final double? smartphoneMagnometerY;
  final double? smartphoneMagnometerZ;

  InertialDataModel({
    required this.timestamp,
    this.smartphoneAccelerometerTimestamp,
    this.smartphoneAccelerometerX,
    this.smartphoneAccelerometerY,
    this.smartphoneAccelerometerZ,
    this.smartphoneGyroscopeTimestamp,
    this.smartphoneGyroscopeX,
    this.smartphoneGyroscopeY,
    this.smartphoneGyroscopeZ,
    this.smartphoneMagnometerTimestamp,
    this.smartphoneMagnometerX,
    this.smartphoneMagnometerY,
    this.smartphoneMagnometerZ,
  });
}

class InertialDataService {
  final List<StreamSubscription<dynamic>> _streamSubscriptions = [];
  final Duration _inertialCollectionDuration;
  final Duration _inertialSleepDuration;
  late final Duration _sensorInterval;
  final List<String> _inertialFeatures;

  final ValueNotifier<bool> isCollectingNotifier = ValueNotifier(false);

  Timer? _collectionTimer;
  Timer? _sleepTimer;

  InertialDataService({
    String? inertialFeatures,
    double? inertialCollectionFrequency,
    int? inertialCollectionDurationSeconds,
    int? inertialSleepDurationSeconds,
  })  : _sensorInterval = Duration(
            milliseconds: convertFrequencyToMilliseconds(
                inertialCollectionFrequency ??
                    ConfigManager.instance.config.inertialCollectionFrequency)),
        _inertialCollectionDuration = Duration(
            seconds: inertialCollectionDurationSeconds ??
                ConfigManager
                    .instance.config.inertialCollectionDurationSeconds),
        _inertialSleepDuration = Duration(
            seconds: inertialSleepDurationSeconds ??
                ConfigManager.instance.config.inertialSleepDurationSeconds),
        _inertialFeatures = _parseInertialFeatures(
            inertialFeatures ?? ConfigManager.instance.config.inertialFeatures);

  static List<String> _parseInertialFeatures(String inertialFeatures) {
    final validFeatures = ['accelerometer', 'gyroscope', 'magnetometer'];

    if (inertialFeatures.isEmpty) {
      return validFeatures;
    }

    final featureStrings =
        inertialFeatures.split(',').map((s) => s.trim()).toList();

    for (final feature in featureStrings) {
      if (!validFeatures.contains(feature)) {
        throw InvalidInertialFeatureException(feature);
      }
    }

    return featureStrings;
  }

  // Starts collecting sensor data
  void startCollecting(
      void Function(InertialDataModel) onData, void Function(String) onError) {
    if (isCollectingNotifier.value) return;

    isCollectingNotifier.value = true;

    _startSensors(onData, onError);

    _collectionTimer = Timer(_inertialCollectionDuration, () {
      _stopAndScheduleRestart(onData, onError);
    });
  }

  void stopCollecting() {
    _stopSensors();
    _cancelTimers();
    isCollectingNotifier.value = false;
  }

  void _startSensors(
      void Function(InertialDataModel) onData, void Function(String) onError) {
    Stream<UserAccelerometerEvent>? accelerometerStream;
    Stream<GyroscopeEvent>? gyroscopeStream;
    Stream<MagnetometerEvent>? magnetometerStream;

    if (_inertialFeatures.contains('accelerometer')) {
      accelerometerStream =
          userAccelerometerEventStream(samplingPeriod: _sensorInterval);
    }
    if (_inertialFeatures.contains('gyroscope')) {
      gyroscopeStream = gyroscopeEventStream(samplingPeriod: _sensorInterval);
    }
    if (_inertialFeatures.contains('magnetometer')) {
      magnetometerStream =
          magnetometerEventStream(samplingPeriod: _sensorInterval);
    }

    _streamSubscriptions.add(
      Rx.combineLatest3(
        accelerometerStream ?? Stream.value(null),
        gyroscopeStream ?? Stream.value(null),
        magnetometerStream ?? Stream.value(null),
        (UserAccelerometerEvent? accEvent, GyroscopeEvent? gyroEvent,
            MagnetometerEvent? magEvent) {
          final now = DateTime.now();

          // Create and return the InertialDataModel with only the available sensor data
          return InertialDataModel(
            timestamp: now,
            smartphoneAccelerometerTimestamp: accEvent?.timestamp,
            smartphoneAccelerometerX: accEvent?.x,
            smartphoneAccelerometerY: accEvent?.y,
            smartphoneAccelerometerZ: accEvent?.z,
            smartphoneGyroscopeTimestamp: gyroEvent?.timestamp,
            smartphoneGyroscopeX: gyroEvent?.x,
            smartphoneGyroscopeY: gyroEvent?.y,
            smartphoneGyroscopeZ: gyroEvent?.z,
            smartphoneMagnometerTimestamp: magEvent?.timestamp,
            smartphoneMagnometerX: magEvent?.x,
            smartphoneMagnometerY: magEvent?.y,
            smartphoneMagnometerZ: magEvent?.z,
          );
        },
      ).listen((inertialData) {
        // Call the onData function with the aggregated data
        log("Inertial data received...");
        onData(inertialData);
      }, onError: (e) {
        // Handle any errors
        onError('Sensor error: $e');
      }),
    );
  }

  void _stopAndScheduleRestart(
      void Function(InertialDataModel) onData, void Function(String) onError) {
    _stopSensors();
    isCollectingNotifier.value = false;
    _sleepTimer = Timer(_inertialSleepDuration, () {
      if (!isCollectingNotifier.value) {
        startCollecting(onData, onError);
      }
    });
  }

  void _stopSensors() {
    for (var subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    _streamSubscriptions.clear();
    isCollectingNotifier.value = false;
  }

  void _cancelTimers() {
    _collectionTimer?.cancel();
    _sleepTimer?.cancel();
  }

  void dispose() {
    stopCollecting();
    isCollectingNotifier.dispose();
  }
}
