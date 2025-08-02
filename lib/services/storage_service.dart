import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';

class StorageService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // ✅ Initialize Database
  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'users.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE,
            email TEXT,
            full_name TEXT,
            last_name TEXT,
            password TEXT,
            license_number TEXT,
            phone_number TEXT,
            token TEXT
          )
        ''');
      },
    );
  }

  // ✅ Get User by Username
  Future<User?> getUser(String username) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (result.isNotEmpty) {
      print("🔍 User found: $username");
      return User.fromJson(result.first);
    }

    print("❌ No user found with username: $username");
    return null;
  }

  // ✅ Save New User
  Future<bool> saveUser(User newUser) async {
    final db = await database;

    try {
      await db.insert(
        'users',
        newUser.toJson(),
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
      print("✅ User saved successfully: ${newUser.username}");
      return true;
    } catch (e) {
      print("❌ Error saving user: $e");
      return false;
    }
  }
}
