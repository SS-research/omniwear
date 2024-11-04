import 'package:flutter/material.dart';
import 'package:omniwear/services/inertial_data_service.dart';

class InertialDataPage extends StatefulWidget {
  const InertialDataPage({super.key});

  @override
  _InertialDataPageState createState() => _InertialDataPageState();
}

class _InertialDataPageState extends State<InertialDataPage> {
  late InertialDataService _inertialDataService;
  final List<InertialDataModel> _inertialDataModels = [];

  @override
  void initState() {
    super.initState();
    _inertialDataService = InertialDataService();

    // Add listener to update the UI when the state changes
    _inertialDataService.isCollectingNotifier.addListener(() {
      setState(() {});
    });
  }

  // Helper function to display sensor data
  Widget _buildSensorDataWidget({
    required String sensorName,
    required DateTime timestamp,
    required double x,
    required double y,
    required double z,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(sensorName, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text('Timestamp: ${timestamp.toIso8601String()}'),
          Row(
            children: [
              const Text('X: ', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('$x'),
            ],
          ),
          Row(
            children: [
              const Text('Y: ', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('$y'),
            ],
          ),
          Row(
            children: [
              const Text('Z: ', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('$z'),
            ],
          ),
        ],
      ),
    );
  }

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
            child: ValueListenableBuilder<bool>(
              valueListenable: _inertialDataService.isCollectingNotifier,
              builder: (context, isCollecting, _) {
                if (isCollecting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                    itemCount: _inertialDataModels.length,
                    itemBuilder: (context, index) {
                      final data = _inertialDataModels[index];
                      return ListTile(
                        title: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "Timestamp: ${data.timestamp.toIso8601String()}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (data.smartphoneAccelerometerTimestamp != null)
                              _buildSensorDataWidget(
                                sensorName: 'Accelerometer:',
                                timestamp:
                                    data.smartphoneAccelerometerTimestamp!,
                                x: data.smartphoneAccelerometerX!,
                                y: data.smartphoneAccelerometerY!,
                                z: data.smartphoneAccelerometerZ!,
                              ),
                            if (data.smartphoneGyroscopeTimestamp != null)
                              _buildSensorDataWidget(
                                sensorName: 'Gyroscope:',
                                timestamp: data.smartphoneGyroscopeTimestamp!,
                                x: data.smartphoneGyroscopeX!,
                                y: data.smartphoneGyroscopeY!,
                                z: data.smartphoneGyroscopeZ!,
                              ),
                            if (data.smartphoneMagnometerTimestamp != null)
                              _buildSensorDataWidget(
                                sensorName: 'Magnetometer:',
                                timestamp: data.smartphoneMagnometerTimestamp!,
                                x: data.smartphoneMagnometerX!,
                                y: data.smartphoneMagnometerY!,
                                z: data.smartphoneMagnometerZ!,
                              ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _startCollecting() {
    setState(() {
      _inertialDataModels.clear();
    });

    _inertialDataService.startCollecting((data) {
      setState(() {
        _inertialDataModels.addAll(data);
      });
    }, _showSensorErrorDialog);
  }

  void _stopCollecting() {
    setState(() {
      _inertialDataService.stopCollecting();
    });
  }

  void _showSensorErrorDialog(String sensorName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Sensor Not Found"),
          content:
              Text("It seems that your device doesn't support $sensorName"),
        );
      },
    );
  }

  @override
  void dispose() {
    // Stop collecting data if still active
    _inertialDataService.stopCollecting();

    // Remove the listener from the ValueNotifier
    _inertialDataService.isCollectingNotifier.removeListener(() {
      setState(() {});
    });

    // Dispose of the service and other resources
    _inertialDataService.dispose();

    super.dispose();
  }
}
