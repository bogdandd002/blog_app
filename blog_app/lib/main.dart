import 'package:blog_app/home.dart';
import 'package:flutter/material.dart';

//this is the entry point of application
void main() {
  runApp(const MyApp());
}

//a stateless widget that use light colour flutter theme and call our Home Page
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Blog App',
      theme: ThemeData.light(),
      home:  const HomePage(),
    );
  }
}
