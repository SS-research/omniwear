import 'package:omniwear/db/core/entity.dart';
import 'package:omniwear/db/core/repository.dart';

// NOTE: ad the moment Session is not an active Repository
class Session implements Entity<Session> {
  final String sessionID;
  final String partecipantID;
  final String startTimestamp;
  final String endTimestamp;
  final String smartphoneModel;
  final String smartphoneOsVersion;
  final String? smartwatchModel;
  final String? smartwatchOsVersion;

  Session({
    required this.sessionID,
    required this.partecipantID,
    required this.startTimestamp,
    required this.endTimestamp,
    required this.smartphoneModel,
    required this.smartphoneOsVersion,
    this.smartwatchModel,
    this.smartwatchOsVersion,
  });

  static const String tableName = 'Session';

  static String idField = 'session_id';

  @override
  Map<String, dynamic> toMap() {
    return {
      'session_id': sessionID,
      'partecipant_id': partecipantID,
      'start_timestamp': startTimestamp,
      'end_timestamp': endTimestamp,
      'smartphone_model': smartphoneModel,
      'smartphone_os_version': smartphoneOsVersion,
      'smartwatch_model': smartwatchModel,
      'smartwatch_os_version': smartwatchOsVersion,
    };
  }

  static Session fromMap(Map<String, dynamic> map) {
    return Session(
      sessionID: map['session_id'],
      partecipantID: map['partecipant_id'],
      startTimestamp: map['start_timestamp'],
      endTimestamp: map['end_timestamp'],
      smartphoneModel: map['smartphone_model'],
      smartphoneOsVersion: map['smartphone_os_version'],
      smartwatchModel: map['smartwatch_model'],
      smartwatchOsVersion: map['smartwatch_os_version'],
    );
  }

  static String getCreateTableQuery() {
    return '''
      CREATE TABLE Session (
        session_id TEXT PRIMARY KEY,
        partecipant_id TEXT,
        start_timestamp TEXT,
        end_timestamp TEXT,
        smartphone_model TEXT,
        smartphone_os_version TEXT,
        smartwatch_model TEXT,
        smartwatch_os_version TEXT,
        FOREIGN KEY (partecipant_id) REFERENCES Partecipant (partecipant_id) ON DELETE CASCADE
      )
    ''';
  }

  static Repository<Session> getRepository() {
    return Repository<Session>(
      idField: Session.idField,
      tableName: Session.tableName,
      fromMap: Session.fromMap,
    );
  }

  Session copyWith({
    String? sessionID,
    String? partecipantID,
    String? startTimestamp,
    String? endTimestamp,
    String? smartphoneModel,
    String? smartphoneOsVersion,
    String? smartwatchModel,
    String? smartwatchOsVersion,
  }) {
    return Session(
      sessionID: sessionID ?? this.sessionID,
      partecipantID: partecipantID ?? this.partecipantID,
      startTimestamp: startTimestamp ?? this.startTimestamp,
      endTimestamp: endTimestamp ?? this.endTimestamp,
      smartphoneModel: smartphoneModel ?? this.smartphoneModel,
      smartphoneOsVersion: smartphoneOsVersion ?? this.smartphoneOsVersion,
      smartwatchModel: smartwatchModel ?? this.smartwatchModel,
      smartwatchOsVersion: smartwatchOsVersion ?? this.smartwatchOsVersion,
    );
  }
}
