@GenerateMocks([DatabaseHelper])
import 'dart:io';
import 'dart:typed_data';
import 'package:blog_app/models/blog_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:blog_app/services/database_helper.dart';

import 'database_helper_test.mocks.dart';


void main() async {

  late Database database;
  String databaseRules =
      'CREATE TABLE Blog(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, authorName TEXT NOT NULL, title TEXT NOT NULL, desc TEXT NOT NULL, dateCreated TEXT NOT NULL, lastUpdated TEXT NOT NULL, picture BLOB );';

  var pathOfImage = File('assets/images/pic_test.jpg');
  Uint8List pic = pathOfImage.readAsBytesSync();
  late DatabaseHelper taskService;
  Blog testTask = Blog(
      id: 1,
      authorName: "author ",
      title: "title",
      desc: "desc",
      dateCreated: "20-10-2024",
      lastUpdated: "20-11-2024",
      picture: pic);
      var data = {
      'authorName': 'author',
      'title': 'title',
      'desc': 'desc',
      'lastUpdated': '24-10-2024',
      'picture': '24-10-2024',
    };
  List<Blog> taskList = List.generate(10, (index) => testTask);
  // Future<List<Map<String, dynamic>>> taskList1 = Future.value(List<data>)
  setUpAll(() async {
    sqfliteFfiInit();
    database = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    await database.execute(databaseRules);
    taskService = MockDatabaseHelper();
    taskService.db = database;
    when(taskService.addBlog("author", "title", "desc", pic))
        .thenAnswer((_) async => Future.value(1));
    when(taskService.updateBlog(1, 'author', 'title',
      'desc', pic)).thenAnswer((_) async => 1);
    when(taskService.deleteBlog(1)).thenAnswer((_) async => 1);
    when(taskService.getBlog(1)).thenAnswer((_) async =>taskList as Future<List<Map<String, dynamic>>>);
    when(taskService.getAllBlogs()).thenAnswer((_) async => taskList as Future<List<Map<String, dynamic>>>);
  });

  group('Database Test', () {
    test('sqflite version', () async {
      expect(await database.getVersion(), 0);
    });
    test('add Item to database', () async {
      var i = await database.insert(
          'Blog',
          Blog(
                  id: 1,
                  authorName: "author ",
                  title: "title",
                  desc: "desc",
                  dateCreated: "20-10-2024",
                  lastUpdated: "20-11-2024",
                  picture: pic)
              .toJson());
      var p = await database.query('Blog');
      expect(p.length, i);
    });
    test('add three Items to database', () async {
      await database.insert(
          'Blog',
          Blog(
                  id: 2,
                  authorName: "author1 ",
                  title: "title",
                  desc: "desc",
                  dateCreated: "20-10-2024",
                  lastUpdated: "20-11-2024",
                  picture: pic)
              .toJson());
      await database.insert(
          'Blog',
          Blog(
                  id: 3,
                  authorName: "author2 ",
                  title: "title",
                  desc: "desc",
                  dateCreated: "20-10-2024",
                  lastUpdated: "20-11-2024",
                  picture: pic)
              .toJson());
      await database.insert(
          'Blog',
          Blog(
                  id: 4,
                  authorName: "author3 ",
                  title: "title",
                  desc: "desc",
                  dateCreated: "20-10-2024",
                  lastUpdated: "20-11-2024",
                  picture: pic)
              .toJson());
      var p = await database.query('Blog');
      expect(p.length, 4);
    });
    test('update first Item', () async {
      await database.update('Blog',
          Blog (id:1, 
          authorName: 'author_check',
          title: 'titlename',
          desc: 'desc_check',
          dateCreated: "20-10-2024",
          lastUpdated: "20-11-2024",
          picture:  pic).toJson(),
          where: 'id = ?', whereArgs: [1]);
      var p = await database.query('Blog');
      expect(p.first['authorName'], "author_check");
      expect(p.first['desc'], "desc_check");
    });
    test('delete the first Item', () async {
      await database.delete('Blog', where: 'id = ?', whereArgs: [1]);
      var p = await database.query('Blog');
      expect(p.length, 3);
    });
    test('Close db', () async {
      await database.close();
      expect(database.isOpen, false);
    });
  });
}
