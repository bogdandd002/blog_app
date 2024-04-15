import 'dart:ffi';

import 'package:blog_app/home.dart';
import 'package:blog_app/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

class MockDatabaseHelper extends Mock implements DatabaseHelper {
  // @override
  // String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
  //   return super.toString();
  // }
}

void main() {
  late HomePage sut;
  late MockDatabaseHelper mockDatabaseHelper;

  setUpAll(() {
    mockDatabaseHelper = MockDatabaseHelper();
    sut = HomePage();
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });
  test('Simple test', () async {

    
    // var db = await openDatabase(inMemoryDatabasePath, version: 1,
    //     onCreate: (db, version) async {
    //   await db.execute(
    //       'CREATE TABLE Test(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, authorName TEXT NOT NULL, title TEXT NOT NULL, desc TEXT NOT NULL, dateCreated TEXT NOT NULL, lastUpdated TEXT NOT NULL, picture BLOB );');
    // });
    // Insert some data
    // var data = {
    //   'authorName': 'Author',
    //   'title': 'Title',
    //   'desc': 'Description',
    //   'dateCreated': '24-01-2024',
    //   'lastUpdated': '24-01-2024',
    //   'picture': 00112233
    // };
    
    // // Check content
    // expect(await db.query('Test'), [
    //   {
    //     'id': 1,
    //     'authorName': 'Author',
    //     'title': 'Title',
    //     'desc': 'Description',
    //     'dateCreated': '24-01-2024',
    //     'lastUpdated': '24-01-2024',
    //     'picture': 00112233
    //   }
    // ]);

    // expect(await mockDatabaseHelper.getAllBlogs(), [
    //   {
    //     'id': 1,
    //     'authorName': 'Author',
    //     'title': 'Title',
    //     'desc': 'Description',
    //     'dateCreated': '24-01-2024',
    //     'lastUpdated': '24-01-2024',
    //     'picture': 00112233
    //   }
    // ]);
  //   await db.close();
  });
  test("Initial values are correct", () {
    expect(sut.createState().filteredBlogs, []);
    expect(sut.createState().blogIdList, []);
  });
}
