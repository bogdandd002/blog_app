import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:typed_data';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = "Blog.db";
  late Database db;

  Future<Database> getDB() async {
    db = await openDatabase(join(await getDatabasesPath(), _dbName),
        onCreate: (db, version) async => await db.execute(
            'CREATE TABLE Blog(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, authorName TEXT NOT NULL, title TEXT NOT NULL, desc TEXT NOT NULL, dateCreated TEXT NOT NULL, lastUpdated TEXT NOT NULL, picture BLOB );'),
        version: _version);
        return db;
  }

  Future<int> addBlog(
      String authorName, String title, String desc, Uint8List picture) async {
    DateTime curentTime = DateTime.now();
    String dateCreated = DateFormat('dd-MM-yyy – kk:mm').format(curentTime);
    final db = await getDB();
    var data = {
      'authorName': authorName,
      'title': title,
      'desc': desc,
      'dateCreated': dateCreated,
      'lastUpdated': dateCreated,
      'picture': picture
    };
    return await db.insert("Blog", data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateBlog(int id, String authorName, String titleName,
      String desc, Uint8List picture) async {
    DateTime curentTime = DateTime.now();
    String lastUpdated = DateFormat('dd-MM-yyy – kk:mm').format(curentTime);
    var db = await getDB();
    var data = {
      'authorName': authorName,
      'title': titleName,
      'desc': desc,
      'lastUpdated': lastUpdated,
      'picture': picture,
    };
    return await db.update('Blog', data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteBlog(int id) async {
    final db = await getDB();
    return await db.delete("Blog", where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteBlogs(List<int> deleteBloglist) async {
    final db = await getDB();
    return await db.delete('Blog',
        where: 'id IN (${List.filled(deleteBloglist.length, '?').join(',')})',
        whereArgs: deleteBloglist);
  }

  Future<List<Map<String, dynamic>>> getBlog(int id) async {
    final db = await getDB();
    return await db.query("Blog", where: 'id = ?', whereArgs: [id], limit: 1);
  }

  Future<List<Map<String, dynamic>>> getAllBlogs() async {
    final db = await getDB();
    return db.query('Blog', orderBy: 'id');
  }
}
