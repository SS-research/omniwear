import 'package:health/health.dart';

class HealthDataModel {
  final DateTime startTimestamp;
  final DateTime endTimestamp;
  final String category;
  final String unit;
  final dynamic value;

  HealthDataModel({
    required this.startTimestamp,
    required this.endTimestamp,
    required this.category,
    required this.unit,
    required this.value,
  });

  @override
  String toString() {
    return 'Start: $startTimestamp, End: $endTimestamp, Category: $category, Unit: $unit, Value: $value';
  }
}

class HealthDataService {
  final Health _health = Health();

  // Request permissions for accessing health data
  Future<bool> requestPermissions() async {
    final types = _getHealthDataTypes();
    final permissions =
        types.map((type) => HealthDataAccess.READ_WRITE).toList();

    return await _health.requestAuthorization(types, permissions: permissions);
  }

  // Fetch health data
  Future<List<HealthDataModel>> fetchHealthData() async {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    final healthDatas = await _health.getHealthDataFromTypes(
      types: _getHealthDataTypes(),
      startTime: yesterday,
      endTime: now,
    );

    final healthDataModels = healthDatas.map((dataPoint) {
      // TODO: custom logic for workout data
      return HealthDataModel(
          category: dataPoint.type.toString(),
          startTimestamp: dataPoint.dateFrom,
          endTimestamp: dataPoint.dateTo,
          unit: dataPoint.unit.toString(),
          value: dataPoint.value);
    }).toList();
    return healthDataModels;
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
