import 'package:path/path.dart' show join;
import 'package:lab/controllers/controllers.dart';

class Table {
  static String get frequence => "frequence";
  static String get habitude => "habitude";
  static String get todoo => "todoo";
}

abstract class Controller<T extends Model> extends DatabaseController {
  String table;

  Controller(this.table);

  Future<T> insert(T model) async {
    Database db = await database;
    model.id = await db.insert(table, model.asMap());
    return model;
  }

  Future<int> update(T model) async {
    Database db = await database;
    return await db
        .update(table, model.asMap(), where: 'id = ?', whereArgs: [model.id]);
  }

  Future<int> delete(T model) async {
    Database db = await database;
    return await db.delete(table, where: 'id = ?', whereArgs: [model.id]);
  }
}

class DatabaseController {
  static Database? _database;

  Future<Database> get database async => (_database ?? await _create());

// Créer base de donnée
  Future<Database> _create() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'db.db');

    _database = await openDatabase(path, version: 1, onCreate: _onCreate);
    return (_database!);
  }

  _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE ${Table.habitude} (id INTEGER PRIMARY KEY, name TEXT, description TEXT, status INTEGER)');
    await db.execute('CREATE TABLE ${Table.frequence} (id INTEGER PRIMARY KEY, name TEXT, days INTEGER, number INTEGER, date TEXT, status INTEGER, habit_id INTEGER)');
  }
}
