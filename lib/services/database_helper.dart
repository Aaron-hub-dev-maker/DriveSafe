import 'package:cc_pro/models/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, 'users.db');

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE,
            first_name TEXT,
            last_name TEXT,
            password TEXT,
            driver_license_number TEXT
          )
          ''');
      },
    );
  }

  Future<int> registerUser(
    String username,
    String firstName,
    String lastName,
    String password,
    String driverLicense,
  ) async {
    final db = await database;
    return await db.insert('users', {
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'password': password,
      'driver_license_number': driverLicense,
    });
  }

  Future<Map<String, dynamic>?> loginUser(
    String username,
    String password,
  ) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  authenticateUser(String username, String password) {}

  insertUser(User newUser) {}

  getUser(String username, String password) {}
}
