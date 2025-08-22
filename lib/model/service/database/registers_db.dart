import 'package:caderno_do_campo/model/registers_model.dart';
import 'package:path/path.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class RegistersServiceDatabase {
  static const String _databaseName = 'registers.db';
  static const String _tableName = 'registers';
  static const String _id = 'id';
  static const String _dateTime = 'datetime';
  static const String _culture = 'culture';
  static const String _area = 'area';
  static const String _activity = 'activity';
  static const String _responsable = 'responsable';
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
              $_culture TEXT NOT NULL,
              $_area TEXT NOT NULL,
              $_activity TEXT NOT NULL,
              $_responsable TEXT NOT NULL,
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

  AsyncResult<List<RegistersModel>> getAllRegisters() async {
    try {
      final List<Map<String, dynamic>> listRegisters = await _database!.query(
        _tableName,
      );
      List<RegistersModel> listMapRegisters = List.generate(
        listRegisters.length,
        (i) {
          return RegistersModel(
            id: listRegisters[i][_id],
            dateTime: listRegisters[i][_dateTime],
            culture: listRegisters[i][_culture],
            area: listRegisters[i][_area],
            activity: listRegisters[i][_activity],
            responsable: listRegisters[i][_responsable],
            actions: listRegisters[i][_actions],
          );
        },
      );

      return Success(listMapRegisters);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  AsyncResult<bool> insertRegister(RegistersModel register) async {
    try {
      await _database!.insert(_tableName, register.toMapForInsert());
      return Success(true);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  AsyncResult<bool> updateRegister(RegistersModel register) async {
    try {
      await _database!.update(
        _tableName,
        register.toMap(),
        where: '$_id = ?',
        whereArgs: [register.id],
      );
      return Success(true);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  AsyncResult<bool> deleteRegister(int id) async {
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

  AsyncResult<bool> deleteAllRegisters() async {
    try {
      await _database!.delete(_tableName);
      return Success(true);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
