import 'package:caderno_do_campo/model/areas_model.dart';

import 'package:path/path.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class AreasServiceDatabase {
  static const String _databaseName = 'areas.db';
  static const String _tableName = 'areas';
  static const String _idColumn = 'id';
  static const String _nameColumn = 'name';
  static const String _areaColumn = 'area';
  static const String _locationColumn = 'location';
  static const String _platColumn = 'plat';
  static const String _actionsColumn = 'actions';

  Database? _database;

  bool isOpen() => _database != null && _database!.isOpen;

  AsyncResult<void> open() async {
    try {
      _database = await databaseFactory.openDatabase(
        join(await databaseFactory.getDatabasesPath(), _databaseName),
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) async {
            await db.execute('''
              CREATE TABLE $_tableName (
                $_idColumn INTEGER PRIMARY KEY AUTOINCREMENT,
                $_nameColumn TEXT NOT NULL,
                $_areaColumn DOUBLE NOT NULL,
                $_locationColumn TEXT NOT NULL,
                $_platColumn INTEGER NOT NULL,
                $_actionsColumn TEXT NOT NULL
              )
            ''');
          },
        ),
      );
      return Success(Null);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  AsyncResult<List<AreasModel>> getAllAreas() async {
    try {
      final List<Map<String, dynamic>> maps = await _database!.query(
        _tableName,
      );
      List<AreasModel>? listMapAreas = List.generate(maps.length, (i) {
        return AreasModel(
          id: maps[i][_idColumn],
          name: maps[i][_nameColumn],
          area: maps[i][_areaColumn],
          location: maps[i][_locationColumn],
          plat: maps[i][_platColumn],
          actions: maps[i][_actionsColumn],
        );
      });

      return Success(listMapAreas);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  AsyncResult<bool> insertArea(AreasModel area) async {
    try {
      await _database!.insert(_tableName, area.toMapForInsert());
      return Success(true);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  AsyncResult<bool> updateArea(AreasModel area) async {
    try {
      await _database!.update(
        _tableName,
        area.toMap(),
        where: 'id = ?',
        whereArgs: [area.id],
      );
      return Success(true);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  AsyncResult<bool> deleteArea(int id) async {
    try {
      await _database!.delete(_tableName, where: 'id = ?', whereArgs: [id]);
      return Success(true);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  AsyncResult<void> close() async {
    try {
      await _database!.close();
      return Success(Null);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  AsyncResult<bool> deleteAllAreas() async {
    try {
      await _database!.delete(_tableName);
      return Success(true);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
