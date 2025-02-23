import 'dart:developer';

import 'package:omniwear/db/core/db_connector.dart';
import 'package:omniwear/db/core/entity.dart';
import 'package:sqflite/sqflite.dart';

class Repository<T extends Entity<T>> {
  final String idField;
  final String tableName;
  final T Function(Map<String, dynamic>) fromMap;

  Repository({
    required this.idField,
    required this.tableName,
    required this.fromMap,
  });

  Future<void> insert(T model) async {
    final dbClient = await DBConnector.instance.connection;

    await dbClient.transaction((txn) async {
      try {
        await txn.insert(tableName, model.toMap());
      } catch (e) {
        log("Error during insert for $tableName: $e");
        throw Exception('Failed to insert entity into $tableName');
      }
    });
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

  Future<void> insertBatch(List<T> models) async {
    log("Inserting batch of entities into $tableName");

    final dbClient = await DBConnector.instance.connection;

    // Use a transaction for safety
    await dbClient.transaction((txn) async {
      final Batch batch = txn.batch(); // Create a batch within the transaction

      // Add all insertions to the batch
      for (T model in models) {
        batch.insert(tableName, model.toMap());
      }

      // Execute the batch
      try {
        await batch.commit(
            noResult: true); // Use noResult to reduce memory overhead
        log("Batch insert successful for $tableName");
      } catch (e) {
        log("Error during batch insert for $tableName: $e");
        throw Exception('Failed to insert batch of entities into $tableName');
      }
    });
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
