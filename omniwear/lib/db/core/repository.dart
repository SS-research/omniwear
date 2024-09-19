import 'dart:developer';

import 'package:omniwear/db/core/db_connector.dart';
import 'package:omniwear/db/core/entity.dart';

class Repository<T extends Entity<T>> {
  final String idField;
  final String tableName;
  final T Function(Map<String, dynamic>) fromMap;

  Repository({
    required this.idField,
    required this.tableName,
    required this.fromMap,
  });

  Future<int> insert(T model) async {
        log("Inserting entity $tableName");
    final dbClient = await DBConnector.instance.connection;
    return await dbClient.insert(tableName, model.toMap());
  }

  Future<List<T>> fetchAll() async {
        log("Fetching all entities $tableName");
    final dbClient = await DBConnector.instance.connection;
    final result = await dbClient.query(tableName);
    return result.map((e) => fromMap(e)).toList();
  }

  Future<T?> fetchOne(String id) async {
        log("Fetching entity $tableName with $id");
    final dbClient = await DBConnector.instance.connection;
    final result = await dbClient.query(tableName,
        where: '$idField = ?', whereArgs: [id], limit: 1);
    if (result.isNotEmpty) {
      return fromMap(result.first);
    }
    return null;
  }

  Future<int> update(String id, T model) async {
    log("Updating entity $tableName with $id");
    final dbClient = await DBConnector.instance.connection;
    return await dbClient.update(
      tableName,
      model.toMap(),
      where: '$idField = ?',
      whereArgs: [id],
    );
  }

    Future<int> updatePartial(String id, T model) async {
          log("Partial updating entity $tableName with $id");
    final dbClient = await DBConnector.instance.connection;
    return await dbClient.update(
      tableName,
      model.toMap(),
      where: '$idField = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(String id) async {
        log("Deleting entity $tableName with $id");
    final dbClient = await DBConnector.instance.connection;
    return await dbClient.delete(
      tableName,
      where: '$idField = ?',
      whereArgs: [id],
    );
  }
}
