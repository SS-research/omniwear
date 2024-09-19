import 'dart:async';
import 'dart:developer';
import 'package:health/health.dart';
import 'package:omniwear/config/config_manager.dart';

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
  final List<HealthDataType> _healthDataTypes;
  Timer? _streamingTimer;

  // Use config values or default to specified values
  final int _healthReadingFrequency;
  final int _healthReadingInterval;

  // Constructor using values from ConfigManager or defaults
  HealthDataService({
    String? healthFeatures,
    int? healthReadingFrequency,
    int? healthReadingInterval,
  })  : _healthDataTypes = _parseHealthFeatures(
            healthFeatures ?? ConfigManager.instance.config.healthFeatures),
        _healthReadingFrequency = healthReadingFrequency ??
            ConfigManager.instance.config.healthReadingFrequency,
        _healthReadingInterval = healthReadingInterval ??
            ConfigManager.instance.config.healthReadingInterval;

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

  static List<HealthDataType> _parseHealthFeatures(String? healthFeatures) {
    final featureMap = _getFeatureMap();

    if (healthFeatures == null || healthFeatures.isEmpty) {
      return [];
    }

    if (healthFeatures == "*") {
      return featureMap.values.toList();
    }

    final featureStrings =
        healthFeatures.split(',').map((s) => s.trim()).toList();

    final List<HealthDataType> healthDataTypes = featureStrings.map((fs) {
      final type = featureMap[fs];
      if (type == null) {
        throw InvalidHealthFeatureException(fs);
      }
      return type;
    }).toList();

    return healthDataTypes;
  }

  /// Requests authorization for health data access.
  ///
  /// This method attempts to request read/write permissions for all specified
  /// health data types. If no health data types are provided, it returns true
  /// without attempting any permission requests.
  ///
  /// @return [Future<bool>] - True if successful (no data types provided or
  ///                          authorization was granted), false otherwise.
  Future<bool> requestPermissions() async {
    // For the edge case where no dat
    if (_healthDataTypes.isEmpty) {
      return true;
    }
    final permissions =
        _healthDataTypes.map((type) => HealthDataAccess.READ_WRITE).toList();
    return await _health.requestAuthorization(_healthDataTypes,
        permissions: permissions);
  }

  Future<List<HealthDataModel>> fetchHealthData({
    DateTime? endTime,
    int intervalInSeconds = 1800, // Default value of 1800 seconds (30 minutes)
  }) async {
    if (_healthDataTypes.isEmpty) {
      return [];
    }
    final computedEndTime = endTime ?? DateTime.now();
    final computedStartTime =
        computedEndTime.subtract(Duration(seconds: intervalInSeconds));

    final healthDatas = await _health.getHealthDataFromTypes(
      types: _healthDataTypes,
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

  // Start streaming health data
  void startStreaming({
    required Function(List<HealthDataModel>) onData,
  }) {
    if (_healthDataTypes.isEmpty) {
      log("No health features selected, streaming not started!");
      return;
    }
    stopStreaming(); // Stop any existing streaming

    _streamingTimer = Timer.periodic(
      Duration(seconds: _healthReadingFrequency),
      (timer) async {
        final data =
            await fetchHealthData(intervalInSeconds: _healthReadingInterval);
        log("Health data received: ${data.length} data points", level: 0);
        onData(data);
      },
    );
  }

  // Stop streaming health data
  void stopStreaming() {
    if(_healthDataTypes.isEmpty) {
      log("No health features selected, streaming not stopped!");
      return;
    }
    _streamingTimer?.cancel();
    _streamingTimer = null;
  }
}
