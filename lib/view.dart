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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: appBarMain(),
        ),
        body: Center(
            child: Container(
                child: SingleChildScrollView(
                    child: Container(
                        padding: EdgeInsets.all(0),
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
