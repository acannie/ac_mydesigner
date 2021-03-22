import 'package:flutter/material.dart';

import 'upload_image.dart';

class ACMyDesignerPage extends StatefulWidget {
  ACMyDesignerPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ACMyDesignerPage createState() => _ACMyDesignerPage();
}

class _ACMyDesignerPage extends State<ACMyDesignerPage> {
  @override
  Widget build(BuildContext context) {
    return UploadImageDemo();
  }
}
