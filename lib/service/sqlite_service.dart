import 'package:resto_dicodingsubs/model/restaurant.dart';
import 'package:sqflite/sqflite.dart';

class SqliteService {
  static const String _databaseName = 'restaurant_favorite.db';
  static const String _tableName = 'restaurants';
  static const int _databaseVersion = 1;

  Future<void> createTables(Database db) async {
    final sql = '''CREATE TABLE $_tableName (
      id TEXT PRIMARY KEY,
      name TEXT,
      description TEXT,
      city TEXT,
      address TEXT,
      pictureId TEXT,
      rating REAL
    )''';
    await db.execute(sql);
  }

  Future<Database> openDb() async {
    final dbPath = await getDatabasesPath();
    final path = dbPath + _databaseName;
    return openDatabase(path, version: _databaseVersion,
        onCreate: (db, version) async {
      await createTables(db);
    });
  }

  Future<void> insertRestaurant(Restaurant restaurant) async {
    final db = await openDb();
    await db.insert(_tableName, restaurant.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Restaurant>> getRestaurants() async {
    final db = await openDb();
    final List<Map<String, dynamic>> results = await db.query(_tableName);
    return results.map((res) => Restaurant.fromJson(res)).toList();
  }

  Future<void> removeRestaurant(String id) async {
    final db = await openDb();
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> isFavorite(String id) async {
    final db = await openDb();
    final List<Map<String, dynamic>> results =
        await db.query(_tableName, where: 'id = ?', whereArgs: [id]);
    return results.isNotEmpty;
  }
}
