import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:blog_app/models/blog_model.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = "Blog.db";

  static Future<Database> _getDB() async {
    return openDatabase(join(await getDatabasesPath(), _dbName),
        onCreate: (db, version) async => await db.execute(
            "CREATE TABLE Blog(id INTEGER PRIMARY KEY, authorName TEXT NOT NULL, title TEXT NOT NULL, desc TEXT NOT NULL );"),
        version: _version);
  }

  static Future<int> addBlog(
      String authorName, String title, String desc) async {
    final db = await _getDB();
    var data = {'authorName': authorName, 'title': title, 'desc': desc};
    return await db.insert("Blog", data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateBlog(
      String authorName, String title, String desc) async {
    final db = await _getDB();
    var data = {'authorName': authorName, 'title': title, 'desc': desc};
    return await db.update("Blog", data,
        where: 'id = ?',
        whereArgs: [1],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteBlog(Blog blog) async {
    final db = await _getDB();
    return await db.delete(
      "Blog",
      where: 'id = ?',
      whereArgs: [blog.id],
    );
  }

  static Future<List<Map<String, dynamic>>> getAllBlogs() async {
    final db = await _getDB();

    // final List<Map<String, dynamic>> maps = await db.query("Blog");

    // if (db == null) {
    //   return null;
    // }

    // return List.generate(maps.length, (index) => Blog.fromJson(maps[index]));

    return db.query('Blog', orderBy: 'id');
  }
}
