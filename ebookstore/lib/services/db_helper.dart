import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

import '../shared/constants.dart';

/*
 * Created by AbedElaziz Shehadeh on 1st March, 2020
 * elaziz.shehadeh@gmail.com
 */
class DBHelper {
  static final DBHelper _instance = DBHelper._internal();

  factory DBHelper() => _instance;

  static sql.Database? _db;

  Future<sql.Database?> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DBHelper._internal();

  static initDb() async {
    final dbPath = await sql.getDatabasesPath();

    // open if found, create if not found for db
    return sql.openDatabase(path.join(dbPath, 'shop.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE ${Constants.USER_PRODUCTS_TABLE} (product_id TEXT PRIMARY KEY, product_name TEXT, product_description TEXT, product_image TEXT, product_price REAL, product_favorite INTEGER, product_category TEXT)');
    }, version: 1);
  }

  /// insert data to db
  /// @param table: the name of the table to insert to
  /// @param data: data map to be inserted
  Future<void> insert(String table, Map<String, Object> data) async {
    final dbClient = await db;
    dbClient!
        .insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  /// delete data to db
  /// @param table: the name of the table to delete from
  /// @param id: product id to be deleted
  Future<void> delete(String table, String id) async {
    final dbClient = await db;
    dbClient!.delete(table, where: 'product_id = ?', whereArgs: [id]);
  }

  /// update data in db
  /// @param table: the name of the table to be updated
  /// @param data: data map to be updated
  Future<void> update(String table, Map<String, Object> data) async {
    final dbClient = await db;
    dbClient!.update(table, data);
  }

  /// select data from db
  /// @param table: the name of the table to fetch data from
  /// @return Future of the list of products data
  Future<List<Map<String, dynamic>>> getData(String table) async {
    final dbClient = await db;
    return await dbClient!.query(table);
  }

  /// clear database
  Future clear() async {
    final dbPath = await sql.getDatabasesPath();
    await sql.deleteDatabase(dbPath);
  }
}
