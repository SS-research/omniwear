import 'package:omniwear/db/core/entity.dart';
import 'package:omniwear/db/core/repository.dart';

class TSHealth implements Entity<TSHealth> {
  final String tsHealthId;
  final String sessionId;
  final String startTimestamp;
  final String endTimestamp;
  final String category;
  final String unit;
  final String value;

  TSHealth({
    required this.tsHealthId,
    required this.sessionId,
    required this.startTimestamp,
    required this.endTimestamp,
    required this.category,
    required this.unit,
    required this.value,
  });

  static const String tableName = 'TSHealth';

  static const String idField = 'ts_health_id';

  @override
  Map<String, dynamic> toMap() {
    return {
      'ts_health_id': tsHealthId,
      'session_id': sessionId,
      'start_timestamp': startTimestamp,
      'end_timestamp': endTimestamp,
      'category': category,
      'unit': unit,
      'value': value,
    };
  }

  static TSHealth fromMap(Map<String, dynamic> map) {
    return TSHealth(
      tsHealthId: map['ts_health_id'],
      sessionId: map['session_id'],
      startTimestamp: map['start_timestamp'],
      endTimestamp: map['end_timestamp'],
      category: map['category'],
      unit: map['unit'],
      value: map['value'],
    );
  }

  static String getCreateTableQuery() {
    return '''
      CREATE TABLE TSHealth (
        ts_health_id TEXT PRIMARY KEY,
        session_id TEXT,
        start_timestamp TEXT,
        end_timestamp TEXT,
        category TEXT,
        unit TEXT,
        value TEXT
      )
    ''';
  }

  static Repository<TSHealth> getRepository() {
    return Repository<TSHealth>(
      idField: TSHealth.idField,
      tableName: TSHealth.tableName,
      fromMap: TSHealth.fromMap,
    );
  }
}
