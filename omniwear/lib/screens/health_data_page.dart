import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:omniwear/services/health_data_service.dart';

class HealthDataPage extends StatefulWidget {
  @override
  _HealthDataPageState createState() => _HealthDataPageState();
}

class _HealthDataPageState extends State<HealthDataPage> {
  List<HealthDataPoint> _healthDataList = [];
  bool _permissionsGranted = false;
  bool _isFetching = false;

  final HealthDataService _healthDataService = HealthDataService(); // Initialize service

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: _requestPermissions,
              child: const Text('Request Permissions'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _permissionsGranted ? _fetchHealthData : null,
              child: const Text('Fetch Health Data'),
            ),
            const SizedBox(height: 16),
            _isFetching
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: _healthDataList.length,
                      itemBuilder: (context, index) {
                        return _buildHealthDataTile(_healthDataList[index]);
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> _requestPermissions() async {
    final hasPermissions = await _healthDataService.requestPermissions();
    setState(() {
      _permissionsGranted = hasPermissions;
    });

    if (!hasPermissions) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permissions not granted')),
      );
    }
  }

  Future<void> _fetchHealthData() async {
    setState(() {
      _isFetching = true;
    });

    final healthData = await _healthDataService.fetchHealthData();
    setState(() {
      _healthDataList = healthData;
      _isFetching = false;
    });
  }

  Widget _buildHealthDataTile(HealthDataPoint data) {
    return ListTile(
      title: Text(data.typeString),
      subtitle: Text('Value: ${data.value}, Date: ${data.dateFrom}'),
    );
  }
}
