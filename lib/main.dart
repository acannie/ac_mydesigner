import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view.dart';
import 'pick_image.dart';
import 'upload_image.dart';

void main() {
  runApp(MyApp());
}

// ルートの Widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Emoji Art Maker',
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
