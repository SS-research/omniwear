import 'package:health/health.dart';

class InvalidHealthFeatureException implements Exception {
  final String feature;

  InvalidHealthFeatureException(this.feature);

  @override
  String toString() => 'Invalid health feature: $feature';
}

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
  final List<HealthDataType> healthDataTypes;

  HealthDataService({String? healthFeatures})
      : healthDataTypes = _parseHealthFeatures(healthFeatures);

  static Map<String, HealthDataType> _getFeatureMap() {
    return {
      'ACTIVE_ENERGY_BURNED': HealthDataType.ACTIVE_ENERGY_BURNED,
      'BASAL_ENERGY_BURNED': HealthDataType.BASAL_ENERGY_BURNED,
      'BLOOD_GLUCOSE': HealthDataType.BLOOD_GLUCOSE,
      'BLOOD_OXYGEN': HealthDataType.BLOOD_OXYGEN,
      'BLOOD_PRESSURE_DIASTOLIC': HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
      'BLOOD_PRESSURE_SYSTOLIC': HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
      'BODY_FAT_PERCENTAGE': HealthDataType.BODY_FAT_PERCENTAGE,
      'BODY_MASS_INDEX': HealthDataType.BODY_MASS_INDEX,
      'BODY_TEMPERATURE': HealthDataType.BODY_TEMPERATURE,
      'HEART_RATE': HealthDataType.HEART_RATE,
      'HEIGHT': HealthDataType.HEIGHT,
      'RESTING_HEART_RATE': HealthDataType.RESTING_HEART_RATE,
      'RESPIRATORY_RATE': HealthDataType.RESPIRATORY_RATE,
      'STEPS': HealthDataType.STEPS,
      'WEIGHT': HealthDataType.WEIGHT,
      'SLEEP_ASLEEP': HealthDataType.SLEEP_ASLEEP,
      'SLEEP_AWAKE': HealthDataType.SLEEP_AWAKE,
      'WATER': HealthDataType.WATER,
      'WORKOUT': HealthDataType.WORKOUT,
    };
  }

  // Parse comma-separated health features into a list of HealthDataType
  static List<HealthDataType> _parseHealthFeatures(String? healthFeatures) {
    final featureMap = _getFeatureMap();

    if (healthFeatures == null || healthFeatures.isEmpty) {
      // Return all available health data types
      return featureMap.values.toList();
    }

    final featureStrings =
        healthFeatures.split(',').map((s) => s.trim()).toList();

    final List<HealthDataType> healthDataTypes = featureStrings.map((fs) {
      final type = featureMap[fs];
      if (type == null) {
        // Throw custom exception for unrecognized feature strings
        throw InvalidHealthFeatureException(fs);
      }
      return type;
    }).toList();

    return healthDataTypes;
  }

  // Request permissions for accessing health data
  Future<bool> requestPermissions() async {
    final permissions =
        healthDataTypes.map((type) => HealthDataAccess.READ_WRITE).toList();

    return await _health.requestAuthorization(healthDataTypes,
        permissions: permissions);
  }

  // Fetch health data
  Future<List<HealthDataModel>> fetchHealthData({
    DateTime? endTime,
    int intervalInSeconds = 1800,       // Default value of 1800 seconds (30 minutes)
  }) async {
    final computedEndTime = endTime ??
        DateTime.now(); // Use 'now' as default if endTime is not provided
    final computedStartTime = computedEndTime.subtract(Duration(
        seconds: intervalInSeconds)); // Compute startTime using the interval

    final healthDatas = await _health.getHealthDataFromTypes(
      types: healthDataTypes,
      startTime: computedStartTime,
      endTime: computedEndTime,
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
}
