
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:examen3/user_model.dart';


class DatabaseHelper {
  static Database? _database;
  static const String tableName = 'users';

  // Inicializar la base de datos
  static Future<void> initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'examen3.db'),
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE $tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT,
            apellido_paterno TEXT,
            apellido_materno TEXT,
            edad INTEGER,
            pais_origen TEXT,
            calificacion REAL
          )
          ''',
        );
      },
      version: 1,
    );
  }

  // Método para insertar un nuevo usuario
  static Future<void> insertUser(UserModel user) async {
    await _database!.insert(tableName, user.toMap());
    print(user);
  }

  // Método para actualizar un usuario
  static Future<void> updateUser(UserModel user) async {
    await _database!.update(tableName, user.toMap(), where: 'nombre = ?', whereArgs: [user.nombre]);
  }

  // Método para eliminar un usuario
  static Future<void> deleteUser(UserModel user) async {
    await _database!.delete(tableName, where: 'nombre = ?', whereArgs: [user.nombre]);
  }
}
