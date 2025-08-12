import 'package:caderno_do_campo/model/costs_model.dart';
import 'package:path/path.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class CostsServiceDatabase {
  static const String _databaseName = 'costs.db';
  static const String _tableName = 'costs';
  static const String _id = 'id';
  static const String _dateTime = 'date_time';
  static const String _area = 'area';
  static const String _category = 'category';
  static const String _description = 'description';
  static const String _value = 'value';
  static const String _actions = 'actions';

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
                $_id INTEGER PRIMARY KEY AUTOINCREMENT,
                $_dateTime TEXT NOT NULL,
                $_area TEXT NOT NULL,
                $_category TEXT NOT NULL,
                $_description TEXT NOT NULL,
                $_value REAL NOT NULL,
                $_actions TEXT NOT NULL
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

  AsyncResult<List<CostsModel>> getAllCosts() async {
    try {
      final List<Map<String, dynamic>> listCosts = await _database!.query(
        _tableName,
      );
      List<CostsModel> listMapCosts = List.generate(listCosts.length, (i) {
        return CostsModel(
          id: listCosts[i][_id],
          dateTime: listCosts[i][_dateTime],
          area: listCosts[i][_area],
          category: listCosts[i][_category],
          description: listCosts[i][_description],
          value: listCosts[i][_value],
          actions: listCosts[i][_actions],
        );
      });

      return Success(listMapCosts);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  AsyncResult<bool> insertCost(CostsModel cost) async {
    try {
      await _database!.insert(_tableName, cost.toMapForInsert());
      return Success(true);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  AsyncResult<bool> updateCost(CostsModel cost) async {
    try {
      await _database!.update(
        _tableName,
        cost.toMap(),
        where: '$_id = ?',
        whereArgs: [cost.id],
      );
      return Success(true);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  AsyncResult<bool> deleteCost(int id) async {
    try {
      await _database!.delete(_tableName, where: '$_id = ?', whereArgs: [id]);
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

  AsyncResult<bool> deleteAllCosts() async {
    try {
      await _database!.delete(_tableName);
      return Success(true);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
