import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

class Config {
  // TODO: implement the logic in inertial service
  final String inertialFeatures;
  final double inertialCollectionFrequency;
  final int inertialCollectionDurationSeconds;
  final int inertialSleepDurationSeconds;

  final String healthFeatures;
  final int healthReadingFrequency;
  final int healthReadingInterval;

  final String baseUrl;

  Config({
    required this.inertialCollectionFrequency,
    required this.inertialCollectionDurationSeconds,
    required this.inertialSleepDurationSeconds,
    required this.inertialFeatures,
    required this.healthFeatures,
    required this.healthReadingFrequency,
    required this.healthReadingInterval,
    required this.baseUrl,
  });

  // Static method to load Config from a YAML file
  static Future<Config> loadFromPath(String path) async {
    final contents = await rootBundle.loadString(path);
    final yamlMap = loadYaml(contents) as Map;

    return Config(
      inertialCollectionFrequency:
          (yamlMap['inertialCollectionFrequency'] as num).toDouble(),
      inertialCollectionDurationSeconds:
          yamlMap['inertialCollectionDurationSeconds'],
      inertialSleepDurationSeconds: yamlMap['inertialSleepDurationSeconds'],
      inertialFeatures: yamlMap['inertialFeatures'] ?? "",
      healthFeatures: yamlMap['healthFeatures'] ?? "",
      healthReadingFrequency: yamlMap['healthReadingFrequency'],
      healthReadingInterval: yamlMap['healthReadingInterval'],
      baseUrl: yamlMap['baseUrl'],
    );
  }
}


