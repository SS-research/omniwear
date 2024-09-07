import 'package:flutter/material.dart';
import 'package:health/health.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HealthDataPage(),
    );
  }
}

class HealthDataPage extends StatefulWidget {
  @override
  _HealthDataPageState createState() => _HealthDataPageState();
}

class _HealthDataPageState extends State<HealthDataPage> {
  List<HealthDataPoint> _healthDataList = [];
  bool _permissionsGranted = false;
  bool _isFetching = false;

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

  // Request Health Data Permissions
  Future<void> _requestPermissions() async {
    final health = Health();
    final types = _getHealthDataTypes();
    final permissions = types.map((type) => HealthDataAccess.READ_WRITE).toList();

    final hasPermissions = await health.requestAuthorization(types, permissions: permissions);
    setState(() {
      _permissionsGranted = hasPermissions;
    });

    if (!hasPermissions) {
      // Optionally, show a message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permissions not granted')),
      );
    }
  }

  // Fetch Health Data
  Future<void> _fetchHealthData() async {
    setState(() {
      _isFetching = true;
    });

    final health = Health();
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    final healthData = await health.getHealthDataFromTypes(
      types: _getHealthDataTypes(),
      startTime: yesterday,
      endTime: now,
    );

    setState(() {
      _healthDataList = healthData;
      _isFetching = false;
    });
  }

  // Get list of Health Data Types
  List<HealthDataType> _getHealthDataTypes() {
    return [
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.BASAL_ENERGY_BURNED,
      HealthDataType.BLOOD_GLUCOSE,
      HealthDataType.BLOOD_OXYGEN,
      HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
      HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
      HealthDataType.BODY_FAT_PERCENTAGE,
      HealthDataType.BODY_MASS_INDEX,
      HealthDataType.BODY_TEMPERATURE,
      HealthDataType.HEART_RATE,
      HealthDataType.HEIGHT,
      HealthDataType.RESTING_HEART_RATE,
      HealthDataType.RESPIRATORY_RATE,
      HealthDataType.STEPS,
      HealthDataType.WEIGHT,
      HealthDataType.SLEEP_ASLEEP,
      HealthDataType.SLEEP_AWAKE,
      HealthDataType.WATER,
      HealthDataType.WORKOUT,
    ];
  }

  // Build Health Data List Tile
  Widget _buildHealthDataTile(HealthDataPoint data) {
    print(data);
    return ListTile(
      title: Text(data.typeString),
      subtitle: Text('Value: ${data.value}, Date: ${data.dateFrom}'),
    );
  }
}
