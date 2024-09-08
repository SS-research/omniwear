import 'package:flutter/material.dart';
import 'package:omniwear/services/inertial_data_service.dart';

class InertialDataPage extends StatefulWidget {
  const InertialDataPage({super.key});

  @override
  _InertialDataPageState createState() => _InertialDataPageState();
}

class _InertialDataPageState extends State<InertialDataPage> {
  late InertialDataService _inertialDataService;
  final List<Map<String, dynamic>> _sensorData = [];

  @override
  void initState() {
    super.initState();
    _inertialDataService = InertialDataService(sensorInterval: const Duration(milliseconds: 100));
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
            child: _inertialDataService.isCollecting
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
    });

    _inertialDataService.startCollecting((data) {
      setState(() {
        _sensorData.add(data);
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
          content: Text("It seems that your device doesn't support $sensorName"),
        );
      },
    );
  }
}
