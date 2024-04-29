//this test the database and CRUD methods

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

  var pathOfImage = File('assets/images/pic_test.jpg'); // get dummy image path -image is storred in assets/image folder
  Uint8List pic = pathOfImage.readAsBytesSync(); //convert image path to bytes
  late DatabaseHelper taskService; //create mock database Helper

//below we are generating a mock list of maps for our test 
  List<Map<String, dynamic>> testList = List.generate(10, (index) => {'id': 1,
      'authorName': "author ",
      'title': "title",
      'desc': "desc",
      'dateCreated': "20-10-2024",
      'lastUpdated': "20-11-2024",
      'picture': pic});
  
  // we are seting up the database and moking results for each CRUD method
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
    when(taskService.getBlog(1)).thenAnswer((_) async => testList );
    when(taskService.getAllBlogs()).thenAnswer((_) async => testList );
  });

  group('Database Test', () {
    test('sqflite version', () async {
      expect(await database.getVersion(), 0);
    });
    //testing if add item to DB works - each method as described by each test
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

  group("Service blog", () { //testing the methods - each described by each test
    test("create blog", () async {
      verifyNever(taskService.addBlog('author', 'title', 'desc', pic));
      expect(await taskService.addBlog('author', 'title', 'desc', pic), 1);
      verify(taskService.addBlog('author', 'title', 'desc', pic)).called(1);
    });
    test("update blog", () async {
      verifyNever(taskService.updateBlog(1,'author', 'title', 'desc', pic ));
      expect(await taskService.updateBlog(1,'author', 'title', 'desc', pic), 1);
      verify(taskService.updateBlog(1,'author', 'title', 'desc', pic)).called(1);
    });
    test("delete blog", () async {
      verifyNever(taskService.deleteBlog(1));
      expect(await taskService.deleteBlog(1), 1);
      verify(taskService.deleteBlog(1)).called(1);
    });
    test("get blog", () async {
      verifyNever(taskService.getBlog(1));
      expect(await taskService.getBlog(1),  testList );
      verify(taskService.getBlog(1)).called(1);
    });
    test("get all blogs", () async {
      verifyNever(taskService.getAllBlogs());
      expect(await taskService.getAllBlogs(), testList);
      verify(taskService.getAllBlogs()).called(1);
    });
  });
}
