import 'package:omniwear/db/core/entity.dart';
import 'package:omniwear/db/core/repository.dart';

class TSInertial implements Entity<TSInertial> {
  final String tsInertialId;
  final String sessionId;
  final String timestamp;
  final String? smartphoneAccelerometerTimestamp;
  final double? smartphoneAccelerometerX;
  final double? smartphoneAccelerometerY;
  final double? smartphoneAccelerometerZ;
  final String? smartphoneGyroscopeTimestamp;
  final double? smartphoneGyroscopeX;
  final double? smartphoneGyroscopeY;
  final double? smartphoneGyroscopeZ;
  final String? smartphoneMagnometerTimestamp;
  final double? smartphoneMagnometerX;
  final double? smartphoneMagnometerY;
  final double? smartphoneMagnometerZ;

  TSInertial({
    required this.tsInertialId,
    required this.sessionId,
    required this.timestamp,
    required this.smartphoneAccelerometerTimestamp,
    required this.smartphoneAccelerometerX,
    required this.smartphoneAccelerometerY,
    required this.smartphoneAccelerometerZ,
    required this.smartphoneGyroscopeTimestamp,
    required this.smartphoneGyroscopeX,
    required this.smartphoneGyroscopeY,
    required this.smartphoneGyroscopeZ,
    required this.smartphoneMagnometerTimestamp,
    required this.smartphoneMagnometerX,
    required this.smartphoneMagnometerY,
    required this.smartphoneMagnometerZ,
  });

  static const String tableName = 'TSInertial';

  static const String idField = 'ts_inertial_id';

  @override
  Map<String, dynamic> toMap() {
    return {
      'ts_inertial_id': tsInertialId,
      'session_id': sessionId,
      'timestamp': timestamp,
      'smartphone_accelerometer_timestamp': smartphoneAccelerometerTimestamp,
      'smartphone_accelerometer_x': smartphoneAccelerometerX,
      'smartphone_accelerometer_y': smartphoneAccelerometerY,
      'smartphone_accelerometer_z': smartphoneAccelerometerZ,
      'smartphone_gyroscope_timestamp': smartphoneGyroscopeTimestamp,
      'smartphone_gyroscope_x': smartphoneGyroscopeX,
      'smartphone_gyroscope_y': smartphoneGyroscopeY,
      'smartphone_gyroscope_z': smartphoneGyroscopeZ,
      'smartphone_magnometer_timestamp': smartphoneMagnometerTimestamp,
      'smartphone_magnometer_x': smartphoneMagnometerX,
      'smartphone_magnometer_y': smartphoneMagnometerY,
      'smartphone_magnometer_z': smartphoneMagnometerZ,
    };
  }

  static TSInertial fromMap(Map<String, dynamic> map) {
    return TSInertial(
      tsInertialId: map['ts_inertial_id'],
      sessionId: map['session_id'],
      timestamp: map['timestamp'],
      smartphoneAccelerometerTimestamp:
          map['smartphone_accelerometer_timestamp'],
      smartphoneAccelerometerX: map['smartphone_accelerometer_x'],
      smartphoneAccelerometerY: map['smartphone_accelerometer_y'],
      smartphoneAccelerometerZ: map['smartphone_accelerometer_z'],
      smartphoneGyroscopeTimestamp: map['smartphone_gyroscope_timestamp'],
      smartphoneGyroscopeX: map['smartphone_gyroscope_x'],
      smartphoneGyroscopeY: map['smartphone_gyroscope_y'],
      smartphoneGyroscopeZ: map['smartphone_gyroscope_z'],
      smartphoneMagnometerTimestamp: map['smartphone_magnometer_timestamp'],
      smartphoneMagnometerX: map['smartphone_magnometer_x'],
      smartphoneMagnometerY: map['smartphone_magnometer_y'],
      smartphoneMagnometerZ: map['smartphone_magnometer_z'],
    );
  }

  static String getCreateTableQuery() {
    return '''
      CREATE TABLE TSInertial (
        ts_inertial_id TEXT PRIMARY KEY,
        session_id TEXT,
        timestamp TEXT,
        smartphone_accelerometer_timestamp TEXT,
        smartphone_accelerometer_x REAL,
        smartphone_accelerometer_y REAL,
        smartphone_accelerometer_z REAL,
        smartphone_gyroscope_timestamp TEXT,
        smartphone_gyroscope_x REAL,
        smartphone_gyroscope_y REAL,
        smartphone_gyroscope_z REAL,
        smartphone_magnometer_timestamp TEXT,
        smartphone_magnometer_x REAL,
        smartphone_magnometer_y REAL,
        smartphone_magnometer_z REAL
      )
    ''';
  }

  static Repository<TSInertial> getRepository() {
    return Repository<TSInertial>(
      idField: TSInertial.idField,
      tableName: TSInertial.tableName,
      fromMap: TSInertial.fromMap,
    );
  }
}
