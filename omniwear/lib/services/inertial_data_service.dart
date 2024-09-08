import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';

// Utility function to convert frequency to milliseconds
int convertFrequencyToMilliseconds(double frequency) {
  if (frequency <= 0) {
    throw ArgumentError('Frequency must be greater than zero');
  }
  return (1000 / frequency).round();
}

class InertialDataModel {
  final DateTime timestamp;
  final double smartphoneAccelerometerX;
  final double smartphoneAccelerometerY;
  final double smartphoneAccelerometerZ;
  final double smartphoneGyroscopeX;
  final double smartphoneGyroscopeY;
  final double smartphoneGyroscopeZ;
  final double smartphoneMagnometerX;
  final double smartphoneMagnometerY;
  final double smartphoneMagnometerZ;

  InertialDataModel({
    required this.timestamp,
    required this.smartphoneAccelerometerX,
    required this.smartphoneAccelerometerY,
    required this.smartphoneAccelerometerZ,
    required this.smartphoneGyroscopeX,
    required this.smartphoneGyroscopeY,
    required this.smartphoneGyroscopeZ,
    required this.smartphoneMagnometerX,
    required this.smartphoneMagnometerY,
    required this.smartphoneMagnometerZ,
  });
}

const double defaultInertialCollectionFrequency = 10;
const int defaultInertialCollectionDurationSeconds = 5;
const int defaultInertialSleepDurationSeconds = 5;

class InertialDataService {
  final List<Map<String, dynamic>> _sensorData = [];
  final List<StreamSubscription<dynamic>> _streamSubscriptions = [];
  final double inertialCollectionFrequency;
  final Duration inertialCollectionDuration;
  final Duration inertialSleepDuration;
  late final Duration _sensorInterval;
  final Duration _ignoreDuration = const Duration(milliseconds: 50);

  DateTime? _userAccelerometerUpdateTime;
  DateTime? _gyroscopeUpdateTime;
  DateTime? _magnetometerUpdateTime;

  // Notifier to track collecting state
  final ValueNotifier<bool> isCollectingNotifier = ValueNotifier(false);

  Timer? _collectionTimer;
  Timer? _sleepTimer;

  InertialDataService({
    this.inertialCollectionFrequency = defaultInertialCollectionFrequency,
    int inertialCollectionDurationSeconds = defaultInertialCollectionDurationSeconds,
    int inertialSleepDurationSeconds = defaultInertialSleepDurationSeconds,
  })  : inertialCollectionDuration =
            Duration(seconds: inertialCollectionDurationSeconds),
        inertialSleepDuration =
            Duration(seconds: inertialSleepDurationSeconds) {
    _sensorInterval = Duration(
        milliseconds: convertFrequencyToMilliseconds(inertialCollectionFrequency));
  }

  void startCollecting(void Function(Map<String, dynamic>) onDataUpdate, void Function(String) onError) {
    if (isCollectingNotifier.value) return;

    _sensorData.clear();
    isCollectingNotifier.value = true;

    _startSensors(onDataUpdate, onError);

    _collectionTimer = Timer(inertialCollectionDuration, () {
      _stopAndScheduleRestart(onDataUpdate, onError);
    });
  }

  void stopCollecting() {
    _stopSensors();
    _cancelTimers();
    isCollectingNotifier.value = false;
  }

  void _startSensors(void Function(Map<String, dynamic>) onDataUpdate, void Function(String) onError) {
    _streamSubscriptions.add(
      userAccelerometerEventStream(samplingPeriod: _sensorInterval).listen((UserAccelerometerEvent event) {
        final now = DateTime.now();
        if (_userAccelerometerUpdateTime == null ||
            now.difference(_userAccelerometerUpdateTime!) > _ignoreDuration) {
          _recordData('UserAccelerometer', now, event.x, event.y, event.z, onDataUpdate);
          _userAccelerometerUpdateTime = now;
        }
      }, onError: (e) => onError('User Accelerometer Sensor'), cancelOnError: true),
    );

    _streamSubscriptions.add(
      gyroscopeEventStream(samplingPeriod: _sensorInterval).listen((GyroscopeEvent event) {
        final now = DateTime.now();
        if (_gyroscopeUpdateTime == null ||
            now.difference(_gyroscopeUpdateTime!) > _ignoreDuration) {
          _recordData('Gyroscope', now, event.x, event.y, event.z, onDataUpdate);
          _gyroscopeUpdateTime = now;
        }
      }, onError: (e) => onError('Gyroscope Sensor'), cancelOnError: true),
    );

    _streamSubscriptions.add(
      magnetometerEventStream(samplingPeriod: _sensorInterval).listen((MagnetometerEvent event) {
        final now = DateTime.now();
        if (_magnetometerUpdateTime == null ||
            now.difference(_magnetometerUpdateTime!) > _ignoreDuration) {
          _recordData('Magnetometer', now, event.x, event.y, event.z, onDataUpdate);
          _magnetometerUpdateTime = now;
        }
      }, onError: (e) => onError('Magnetometer Sensor'), cancelOnError: true),
    );
  }

  void _stopAndScheduleRestart(
      void Function(Map<String, dynamic>) onDataUpdate,
      void Function(String) onError) {
    _stopSensors();
    isCollectingNotifier.value = false;
    _sleepTimer = Timer(inertialSleepDuration, () {
      if (!isCollectingNotifier.value) {
        startCollecting(onDataUpdate, onError);
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

  void _recordData(
      String sensorType,
      DateTime timestamp,
      double x,
      double y,
      double z,
      void Function(Map<String, dynamic>) onDataUpdate) {
    final data = {
      'timestamp': timestamp.toIso8601String(),
      'sensorType': sensorType,
      'x': x,
      'y': y,
      'z': z,
    };
    _sensorData.add(data);
    onDataUpdate(data);
  }

  void dispose() {
    stopCollecting();
    isCollectingNotifier.dispose();
  }
}
