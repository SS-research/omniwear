import 'package:omniwear/db/core/entity.dart';
import 'package:omniwear/db/core/repository.dart';

// NOTE: ad the moment Partecipant is not an active Repository
class Partecipant implements Entity<Partecipant> {
  final String partecipantID;
  final String createdAt;

  Partecipant({
    required this.partecipantID,
    String? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().toIso8601String();

  @override
  Map<String, dynamic> toMap() {
    return {
      "partecipant_id": partecipantID,
      "created_at": createdAt,
    };
  }

  static const String idField = 'partecipant_id';

  static const String tableName = 'Partecipant';

  static Partecipant fromMap(Map<String, dynamic> map) {
    return Partecipant(
        partecipantID: map["partecipant_id"], createdAt: map["created_at"]);
  }

  static String getCreateTableQuery() {
    return '''
      CREATE TABLE Partecipant (
        partecipant_id TEXT PRIMARY KEY,
        created_at TEXT
      )
    ''';
  }

  static Repository<Partecipant> getRepository() {
    return Repository<Partecipant>(
      idField: idField,
      tableName: tableName,
      fromMap: fromMap,
    );
  }
}
