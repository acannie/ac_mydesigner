import 'package:flutter/material.dart';
import 'ac_mydesigner_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AC MyDesigner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ACMyDesignerPage(),
    );
  }
}
