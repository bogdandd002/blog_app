import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:blog_app/models/blog_model.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = "Blog.db";

  static Future<Database> _getDB() async {
    return openDatabase(join(await getDatabasesPath(), _dbName),
        onCreate: (db, _version) async => await db.execute(
            "CREATE TABLE Blog(id INTEGER PRIMARY KEY, authorName TEXT NOT NULL, title TEXT NOT NULL, desc TEXT NOT NULL );"),
        version: _version);
  }

  static Future<int> addBlog(Blog blog) async {
    final db = await _getDB();
    return await db.insert("Blog", blog.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateBlog(Blog blog) async {
    final db = await _getDB();
    return await db.update("Blog", blog.toJson(),
        where: 'id = ?',
        whereArgs: [blog.id],
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

  static Future<List<Blog>?> getAllBlogs() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query("Blog");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(maps.length, (index) => Blog.fromJson(maps[index]));
  }
}
