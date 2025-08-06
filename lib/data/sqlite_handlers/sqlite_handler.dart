import 'dart:async';

import 'package:dsimcaf_1/config/constants/db_constanst.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteHandler {
  Future<Database> _getDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, DbConstanst.dbName);

    return await openDatabase(
      path,
      version: DbConstanst.dbVersion,
      onCreate: _onCreate,
    );
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS conteo (
        id varchar(255) NOT NULL,
        estado varchar(255) DEFAULT 'EN_PROCESO' NOT NULL,
        tipo varchar(255) DEFAULT 'GENERAL' NOT NULL,
        subtipo varchar(255),
        area varchar(255),
        responsable varchar(255),
        fechaIni timestamp NOT NULL,
        fechaFin timestamp NULL,
        idUser varchar(255) NOT NULL,
        PRIMARY KEY (id)
        );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS conteo_item (
        id varchar(255) NOT NULL,
        estado varchar(255) DEFAULT 'FALTANTE' NOT NULL,
        idMedio varchar(255) NOT NULL,
        observacion varchar(255),
        conteoid int(10) NOT NULL,
        PRIMARY KEY (id)
        );

    ''');
  }

  Future<List<Map<String, Object?>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final db = await _getDb();
    return await db.query(
      table,
      distinct: distinct,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  Future<bool> insert(
    String table,
    Map<String, Object?> values, {
    String? nullColumnHack,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    final db = await _getDb();
    final result = await db.insert(
      table,
      values,
      nullColumnHack: nullColumnHack,
      conflictAlgorithm: conflictAlgorithm,
    );
    return result > 0;
  }

  Future<bool> update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    final db = await _getDb();
    final result = await db.update(
      table,
      values,
      where: where,
      whereArgs: whereArgs,
      conflictAlgorithm: conflictAlgorithm,
    );
    return result > 0;
  }

  Future<bool> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final db = await _getDb();
    final result = await db.delete(table, where: where, whereArgs: whereArgs);
    return result > 0;
  }

  Future<void> execute(String sql, [List<Object?>? arguments]) async {
    final db = await _getDb();
    await db.execute(sql, arguments);
  }
}
