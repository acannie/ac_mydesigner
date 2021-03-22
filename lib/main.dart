import 'package:flutter/material.dart';
import 'mydesign_model.dart';
import 'package:provider/provider.dart';

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
        home: MultiProvider(
          child: MyDesigner(),
          providers: [
            ChangeNotifierProvider(
                create: (context) => PickedImageController()),
            ChangeNotifierProvider(
                create: (context) => ImageUploadController()),
          ],
        ));
  }
}
