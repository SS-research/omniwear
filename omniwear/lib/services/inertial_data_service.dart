import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

class InertialDataService {
  final List<Map<String, dynamic>> _sensorData = [];
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  final Duration sensorInterval;
  final Duration _ignoreDuration = const Duration(milliseconds: 50); // Minimum interval to record data

  DateTime? _userAccelerometerUpdateTime;
  DateTime? _gyroscopeUpdateTime;
  bool _isCollecting = false;

  InertialDataService({required this.sensorInterval});

  List<Map<String, dynamic>> get sensorData => _sensorData;

  bool get isCollecting => _isCollecting;

  Stream<UserAccelerometerEvent> userAccelerometerEventStream({required Duration samplingPeriod}) async* {
    await Future.delayed(samplingPeriod);
    yield* userAccelerometerEvents;
  }

  Stream<GyroscopeEvent> gyroscopeEventStream({required Duration samplingPeriod}) async* {
    await Future.delayed(samplingPeriod);
    yield* gyroscopeEvents;
  }

  void startCollecting(void Function(Map<String, dynamic>) onDataUpdate, void Function(String) onError) {
    _sensorData.clear();
    _isCollecting = true;

    _streamSubscriptions.add(
      userAccelerometerEventStream(samplingPeriod: sensorInterval).listen(
        (UserAccelerometerEvent event) {
          final now = DateTime.now();
          if (_userAccelerometerUpdateTime != null) {
            final interval = now.difference(_userAccelerometerUpdateTime!);
            if (interval > _ignoreDuration) {
              _recordData('UserAccelerometer', now, event.x, event.y, event.z, onDataUpdate);
            }
          } else {
            _recordData('UserAccelerometer', now, event.x, event.y, event.z, onDataUpdate);
          }
          _userAccelerometerUpdateTime = now;
        },
        onError: (e) => onError('User Accelerometer Sensor'),
        cancelOnError: true,
      ),
    );

    _streamSubscriptions.add(
      gyroscopeEventStream(samplingPeriod: sensorInterval).listen(
        (GyroscopeEvent event) {
          final now = DateTime.now();
          if (_gyroscopeUpdateTime != null) {
            final interval = now.difference(_gyroscopeUpdateTime!);
            if (interval > _ignoreDuration) {
              _recordData('Gyroscope', now, event.x, event.y, event.z, onDataUpdate);
            }
          } else {
            _recordData('Gyroscope', now, event.x, event.y, event.z, onDataUpdate);
          }
          _gyroscopeUpdateTime = now;
        },
        onError: (e) => onError('Gyroscope Sensor'),
        cancelOnError: true,
      ),
    );
  }

  void stopCollecting() {
    _isCollecting = false;
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    _streamSubscriptions.clear();
  }

  void _recordData(String sensorType, DateTime timestamp, double x, double y, double z, void Function(Map<String, dynamic>) onDataUpdate) {
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
}
