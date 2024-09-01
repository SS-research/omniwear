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
      home: const MyHomePage(title: 'Sensor Data Recorder'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Map<String, dynamic>> _sensorData = [];
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  final sensorInterval = const Duration(milliseconds: 100); // Sampling period
  final Duration _ignoreDuration = const Duration(milliseconds: 50); // Minimum interval to record data

  DateTime? _userAccelerometerUpdateTime;
  DateTime? _gyroscopeUpdateTime;

  @override
  void initState() {
    super.initState();

    // User Accelerometer data recording
    _streamSubscriptions.add(
      userAccelerometerEventStream(samplingPeriod: sensorInterval).listen(
        (UserAccelerometerEvent event) {
          final now = event.timestamp;
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
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Sensor Not Found"),
                  content: Text(
                      "It seems that your device doesn't support User Accelerometer Sensor"),
                );
              });
        },
        cancelOnError: true,
      ),
    );

    // Gyroscope data recording
    _streamSubscriptions.add(
      gyroscopeEventStream(samplingPeriod: sensorInterval).listen(
        (GyroscopeEvent event) {
          final now = event.timestamp;
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
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Sensor Not Found"),
                  content: Text(
                      "It seems that your device doesn't support Gyroscope Sensor"),
                );
              });
        },
        cancelOnError: true,
      ),
    );
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

  @override
  void dispose() {
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 4,
      ),
      body: ListView.builder(
        itemCount: _sensorData.length,
        itemBuilder: (context, index) {
          final data = _sensorData[index];
          return ListTile(
            title: Text("${data['sensorType']} at ${data['timestamp']}"),
            subtitle: Text(' X: ${data['x']},\n Y: ${data['y']},\n Z: ${data['z']}'),
          );
        },
      ),
    );
  }
}
