import 'package:flutter/material.dart';
import 'package:health/health.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HealthDataScreen(),
    );
  }
}

class HealthDataScreen extends StatefulWidget {
  @override
  _HealthDataScreenState createState() => _HealthDataScreenState();
}

class _HealthDataScreenState extends State<HealthDataScreen> {
  List<HealthDataPoint> _healthDataList = [];

  @override
  void initState() {
    super.initState();
    _initializeHealthData();
  }

  // Initialize health data by requesting permissions and fetching data
  Future<void> _initializeHealthData() async {
    final hasPermissions = await _requestPermissions();
    if (hasPermissions) {
      await _fetchHealthData();
    }
  }

  // Request Health Data Permissions
  Future<bool> _requestPermissions() async {
    final health = Health();
    final types = _getHealthDataTypes();
    final permissions = types.map((type) => HealthDataAccess.READ_WRITE).toList();
    return await health.requestAuthorization(types, permissions: permissions);
  }

  // Fetch Health Data
  Future<void> _fetchHealthData() async {
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

  // Display the Health Data
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Data'),
      ),
      body: _healthDataList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _healthDataList.length,
              itemBuilder: (context, index) {
                return _buildHealthDataTile(_healthDataList[index]);
              },
            ),
    );
  }

  // Build Health Data List Tile
  Widget _buildHealthDataTile(HealthDataPoint data) {
    return ListTile(
      title: Text(data.typeString),
      subtitle: Text('Value: ${data.value}, Date: ${data.dateFrom}'),
    );
  }
}
