import 'dart:async';
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

class InertialDataModel {
  final DateTime timestamp;
  final DateTime smartphoneAccelerometerTimestamp;
  final double smartphoneAccelerometerX;
  final double smartphoneAccelerometerY;
  final double smartphoneAccelerometerZ;
  final DateTime smartphoneGyroscopeTimestamp;
  final double smartphoneGyroscopeX;
  final double smartphoneGyroscopeY;
  final double smartphoneGyroscopeZ;
  final DateTime smartphoneMagnometerTimestamp;
  final double smartphoneMagnometerX;
  final double smartphoneMagnometerY;
  final double smartphoneMagnometerZ;

  InertialDataModel({
    required this.timestamp,
    required this.smartphoneAccelerometerTimestamp,
    required this.smartphoneAccelerometerX,
    required this.smartphoneAccelerometerY,
    required this.smartphoneAccelerometerZ,
    required this.smartphoneGyroscopeTimestamp,
    required this.smartphoneGyroscopeX,
    required this.smartphoneGyroscopeY,
    required this.smartphoneGyroscopeZ,
    required this.smartphoneMagnometerTimestamp,
    required this.smartphoneMagnometerX,
    required this.smartphoneMagnometerY,
    required this.smartphoneMagnometerZ,
  });
}

class InertialDataService {
  final List<StreamSubscription<dynamic>> _streamSubscriptions = [];
  final Duration inertialCollectionDuration;
  final Duration inertialSleepDuration;
  late final Duration _sensorInterval;

  // Notifier to track collecting state
  final ValueNotifier<bool> isCollectingNotifier = ValueNotifier(false);

  Timer? _collectionTimer;
  Timer? _sleepTimer;

  InertialDataService({
    double? inertialCollectionFrequency,
    int? inertialCollectionDurationSeconds,
    int? inertialSleepDurationSeconds,
  })  : _sensorInterval = Duration(
            milliseconds: convertFrequencyToMilliseconds(
                inertialCollectionFrequency ??
                    ConfigManager.instance.config.inertialCollectionFrequency)),
        inertialCollectionDuration = Duration(
            seconds: inertialCollectionDurationSeconds ??
                ConfigManager
                    .instance.config.inertialCollectionDurationSeconds),
        inertialSleepDuration = Duration(
            seconds: inertialSleepDurationSeconds ??
                ConfigManager.instance.config.inertialSleepDurationSeconds) {}

  // Starts collecting sensor data
  void startCollecting(
      void Function(InertialDataModel) onData, void Function(String) onError) {
    if (isCollectingNotifier.value) return;

    isCollectingNotifier.value = true;

    _startSensors(onData, onError);

    _collectionTimer = Timer(inertialCollectionDuration, () {
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
    final accelerometerStream =
        userAccelerometerEventStream(samplingPeriod: _sensorInterval);
    final gyroscopeStream =
        gyroscopeEventStream(samplingPeriod: _sensorInterval);
    final magnetometerStream =
        magnetometerEventStream(samplingPeriod: _sensorInterval);

    _streamSubscriptions.add(
      Rx.combineLatest3(
        accelerometerStream,
        gyroscopeStream,
        magnetometerStream,
        (UserAccelerometerEvent accEvent, GyroscopeEvent gyroEvent,
            MagnetometerEvent magEvent) {
          final now = DateTime.now();

          // Create and return the InertialDataModel with aggregated data
          return InertialDataModel(
            timestamp: now,
            smartphoneAccelerometerTimestamp: accEvent.timestamp,
            smartphoneAccelerometerX: accEvent.x,
            smartphoneAccelerometerY: accEvent.y,
            smartphoneAccelerometerZ: accEvent.z,
            smartphoneGyroscopeTimestamp: gyroEvent.timestamp,
            smartphoneGyroscopeX: gyroEvent.x,
            smartphoneGyroscopeY: gyroEvent.y,
            smartphoneGyroscopeZ: gyroEvent.z,
            smartphoneMagnometerTimestamp: magEvent.timestamp,
            smartphoneMagnometerX: magEvent.x,
            smartphoneMagnometerY: magEvent.y,
            smartphoneMagnometerZ: magEvent.z,
          );
        },
      ).listen((inertialData) {
        // Call the onData function with the aggregated data
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
    _sleepTimer = Timer(inertialSleepDuration, () {
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
