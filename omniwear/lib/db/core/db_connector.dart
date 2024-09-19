import 'dart:developer';

import 'package:omniwear/db/entities/partecipant.dart';
import 'package:omniwear/db/entities/session.dart';
import 'package:omniwear/db/entities/ts_health.dart';
import 'package:omniwear/db/entities/ts_inertial.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const databaseName = "omniwear";

class DBConnector {
  // Singleton pattern
  static final DBConnector _instance = DBConnector._internal();
  factory DBConnector() => _instance;

  DBConnector._internal();

  // Static getter for accessing the singleton instance
  static DBConnector get instance => _instance;

  Database? _database;

  Future<Database> get _getDatabase async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, '$databaseName.db');

    // Optionally delete the database to start fresh each time.
    log("Deleting the database to start fresh...");
    await deleteDatabase(path);

    log("Opening the database...");
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(Partecipant.getCreateTableQuery());
        await db.execute(Session.getCreateTableQuery());
        await db.execute(TSInertial.getCreateTableQuery());
        await db.execute(TSHealth.getCreateTableQuery());
      },
    );
  }

  Future<Database> get connection async => await _getDatabase;
}
