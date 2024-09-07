import 'package:health/health.dart';

class HealthDataService {
  final Health _health = Health();

  // Request permissions for accessing health data
  Future<bool> requestPermissions() async {
    final types = _getHealthDataTypes();
    final permissions = types.map((type) => HealthDataAccess.READ_WRITE).toList();
    
    return await _health.requestAuthorization(types, permissions: permissions);
  }

  // Fetch health data
  Future<List<HealthDataPoint>> fetchHealthData() async {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    return await _health.getHealthDataFromTypes(
      types: _getHealthDataTypes(),
      startTime: yesterday,
      endTime: now,
    );
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
}
