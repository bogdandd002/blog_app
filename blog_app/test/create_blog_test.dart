// in this file we are testing create blog file

import 'package:blog_app/create_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUp(() {
    databaseFactory = databaseFactoryFfi; //init database
  });
  //creating test group
    group('test create blog page', () {
    testWidgets('check if all elements are displayed', (tester) async {
      await tester.pumpWidget( const MaterialApp(
          home: CreateBlog(
        id: 0,
      )));
      expect(find.byType(AppBar), findsOneWidget); //check for app bar
      expect(find.byType(TextFormField), findsNWidgets(3)); //check for 3 form fields
      expect(find.byKey(const Key('add photo icon')), findsOneWidget); // check if take photo button is displayed
      expect(find.byKey(const Key('perm media icon')), findsOneWidget); //check if add picture from gallery is displayed
      expect(find.byKey(const Key('button')), findsOneWidget); // check for add button
      expect(find.text('Add Blog'), findsOneWidget); // check if buton have the correct descrition in create new mode
      expect(find.text('Save changes'), findsNothing);
    });
  // check if forms are working 
    testWidgets('check if forms work',
        (tester) async {
          //pumping widget and set state
      await tester.pumpWidget( const MaterialApp(
          home: CreateBlog(
        id: 0,
      )));

      await tester.enterText(find.byKey(const Key('author')), 'author');//populating fields
      await tester.pump(); // pump widget
      expect(find.text('author'), findsOneWidget); // check results
       await tester.enterText(find.byKey(const Key('title')), 'title');
      await tester.pump();
      expect(find.text('title'), findsOneWidget);
      await tester.enterText(find.byKey(const Key('desc')), 'desc');
      await tester.pump();
      expect(find.text('desc'), findsOneWidget);

    });
  });
}
