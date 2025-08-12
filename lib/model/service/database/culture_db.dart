import 'package:caderno_do_campo/model/cultures_model.dart';
import 'package:path/path.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class CultureServiceDatabase {
  static const String _databaseName = 'cultures.db';
  static const String _tableName = 'cultures';
  static const String _idColumn = 'id';
  static const String _nameColumn = 'name';
  static const String _varietyColumn = 'variety';
  static const String _cycleColumn = 'cycle';
  static const String _obsColumn = 'obs';
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
              $_varietyColumn TEXT NOT NULL,
              $_cycleColumn INTEGER NOT NULL,
              $_obsColumn TEXT,
              $_actionsColumn TEXT
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

  AsyncResult<List<CulturesModel>> getAllCultures() async {
    try {
      final List<Map<String, dynamic>> maps = await _database!.query(
        _tableName,
      );
      List<CulturesModel>? listMapCultures = List.generate(maps.length, (i) {
        return CulturesModel(
          id: maps[i][_idColumn],
          name: maps[i][_nameColumn],
          variety: maps[i][_varietyColumn],
          cycle: maps[i][_cycleColumn],
          obs: maps[i][_obsColumn],
          actions: maps[i][_actionsColumn],
        );
      });
      if (listMapCultures.isNotEmpty) {
        return Success(listMapCultures);
      }
      return Success([]);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  AsyncResult<bool> insertCulture(CulturesModel culture) async {
    try {
      await _database!.insert(_tableName, culture.toMapForInsert());

      return Success(true);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  AsyncResult<bool> updateCulture(CulturesModel culture) async {
    try {
      await _database!.update(
        _tableName,
        culture.toMap(),
        where: 'id = ?',
        whereArgs: [culture.id],
      );
      return Success(true);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  AsyncResult<bool> deleteCulture(int id) async {
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

  AsyncResult<bool> deleteAllCultures() async {
    try {
      await _database!.delete(_tableName);
      return Success(true);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
