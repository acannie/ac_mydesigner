import 'package:flutter/material.dart';

import 'upload_image.dart';
import 'create_mydesign.dart';
import 'create_palette.dart';
import 'pick_image.dart';

// ページ全体のレイアウトを生成
class MyDesigner extends StatelessWidget {
  Widget appBarMain() {
    return AppBar(
      leading: Icon(Icons.menu),
      title: const Text('AC MyDesigner'),
      backgroundColor: Colors.orange,
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.face,
            color: Colors.white,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.email,
            color: Colors.white,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.favorite,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(),
        body: Center(
            child: Container(
                child: SingleChildScrollView(
                    child: Container(
                        padding: EdgeInsets.all(30.0),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              PickedImageWidget(),
                              ImageUploadButtonWidget(),
                              Wrap(
                                direction: Axis.horizontal,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(20),
                                    child: MyDesignPreviewWidget(),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(20),
                                    child: MyDesignColorPalette(),
                                  ),
                                ],
                              ),
                            ]))))));
  }
}
