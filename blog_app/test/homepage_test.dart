//in this file we are testing the Homepage 
import 'dart:io';
import 'dart:typed_data';
import 'package:blog_app/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  var pathOfImage = File('assets/images/pic_test.jpg'); // pulling the dummy image path located in asset folder
  Uint8List pic = pathOfImage.readAsBytesSync(); //converting path to bytes

  setUp(() {
    databaseFactory = databaseFactoryFfi; //opening database
  });

  //creating test group
  group('Testing Home page', () {
    testWidgets('check if add button is displayed', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(
          ),
        ),
      );

      final button1 = find.byKey(const Key('add blog')); //check if add button is displayed
      expect(button1, findsOneWidget);

      final button2 = find.byKey(const Key('delete blogs')); //check if delete button is not displayed
      expect(button2, findsNothing);

      expect(find.byType(AppBar), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsOneWidget); //check for the list view widget
    });

    //testing blog tile is created 
    testWidgets('check if blog tile display info', (tester) async {
      await tester.pumpWidget(MaterialApp(
          home: BlogTile(
              id: 1,
              author: 'author',
              desc: 'desc',
              imgUrl: MemoryImage(pic),
              title: 'title',
              created: '20-10-2024',
              callback: (int id) {})));
      await tester.pumpAndSettle();
      expect(find.text('title'), findsOneWidget);
    });

//check if filter form is working
    testWidgets('check if filter is working', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: HomePage(
        ),
      ));
      await tester.enterText(find.byType(TextFormField), 'author');
      await tester.pump();
      expect(find.text('author'), findsOneWidget);
    });
  });
}
