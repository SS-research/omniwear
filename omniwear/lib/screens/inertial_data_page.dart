import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensors Data Recorder',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0x9f4376f8),
      ),
      home: const InertialDataPage(),
    );
  }
}

class InertialDataPage extends StatefulWidget {
  const InertialDataPage({super.key});

  @override
  _InertialDataPageState createState() => _InertialDataPageState();
}

class _InertialDataPageState extends State<InertialDataPage> {
  final List<Map<String, dynamic>> _sensorData = [];
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  final sensorInterval = const Duration(milliseconds: 100); // Sampling period
  final Duration _ignoreDuration = const Duration(milliseconds: 50); // Minimum interval to record data

  DateTime? _userAccelerometerUpdateTime;
  DateTime? _gyroscopeUpdateTime;
  bool _isCollecting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inertial Data'),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: _startCollecting,
                child: const Text('Start Recording'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _stopCollecting,
                child: const Text('Stop Recording'),
              ),
            ],
          ),
          Expanded(
            child: _isCollecting
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _sensorData.length,
                    itemBuilder: (context, index) {
                      final data = _sensorData[index];
                      return ListTile(
                        title: Text("${data['sensorType']} at ${data['timestamp']}"),
                        subtitle: Text(' X: ${data['x']},\n Y: ${data['y']},\n Z: ${data['z']}'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _startCollecting() {
    setState(() {
      _sensorData.clear();
      _isCollecting = true;
    });

    _streamSubscriptions.add(
      userAccelerometerEventStream(samplingPeriod: sensorInterval).listen(
        (UserAccelerometerEvent event) {
          final now = DateTime.now();
          setState(() {
            if (_userAccelerometerUpdateTime != null) {
              final interval = now.difference(_userAccelerometerUpdateTime!);
              if (interval > _ignoreDuration) {
                _recordData('UserAccelerometer', now, event.x, event.y, event.z);
              }
            } else {
              _recordData('UserAccelerometer', now, event.x, event.y, event.z);
            }
          });
          _userAccelerometerUpdateTime = now;
        },
        onError: (e) {
          _showSensorErrorDialog('User Accelerometer Sensor');
        },
        cancelOnError: true,
      ),
    );

    _streamSubscriptions.add(
      gyroscopeEventStream(samplingPeriod: sensorInterval).listen(
        (GyroscopeEvent event) {
          final now = DateTime.now();
          setState(() {
            if (_gyroscopeUpdateTime != null) {
              final interval = now.difference(_gyroscopeUpdateTime!);
              if (interval > _ignoreDuration) {
                _recordData('Gyroscope', now, event.x, event.y, event.z);
              }
            } else {
              _recordData('Gyroscope', now, event.x, event.y, event.z);
            }
          });
          _gyroscopeUpdateTime = now;
        },
        onError: (e) {
          _showSensorErrorDialog('Gyroscope Sensor');
        },
        cancelOnError: true,
      ),
    );
  }

  void _stopCollecting() {
    setState(() {
      _isCollecting = false;
    });

    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    _streamSubscriptions.clear();
  }

  void _recordData(String sensorType, DateTime timestamp, double x, double y, double z) {
    setState(() {
      _sensorData.add({
        'timestamp': timestamp.toIso8601String(),
        'sensorType': sensorType,
        'x': x,
        'y': y,
        'z': z,
      });
    });
  }

  void _showSensorErrorDialog(String sensorName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Sensor Not Found"),
          content: Text("It seems that your device doesn't support $sensorName"),
        );
      },
    );
  }
}
