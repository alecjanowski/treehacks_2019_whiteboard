import 'package:flutter/material.dart';
import 'package:treehacks_2019_whiteboard/services/authentication.dart';
import 'package:treehacks_2019_whiteboard/pages/root_page.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Login',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
            primarySwatch: Colors.orange,
            fontFamily: 'Helvetica'
        ),
        home: new RootPage(auth: new Auth()));
  }
}