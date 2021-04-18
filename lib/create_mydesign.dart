import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'mydesign_model.dart';
import 'upload_image.dart';
import 'utils.dart';

// マイデザインのプレビューを生成
class MyDesignPreviewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ImageUploadController upload_controller =
        Provider.of<ImageUploadController>(context);
    return FutureBuilder<MyDesignData>(
      future: upload_controller.myDesignDataFuture,
      builder: (BuildContext context, AsyncSnapshot<MyDesignData> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          var myDesignData = snapshot.data!;
          // return CircularProgressIndicator();
          return ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: GridView.count(
                shrinkWrap: true,
                primary: false,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                crossAxisCount: 32,
                children: <Widget>[
                  for (var i = 0;
                      i < myDesignData.myDesignColorTable.length;
                      i++)
                    for (var j = 0;
                        j < myDesignData.myDesignColorTable.length;
                        j++)
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(
                            myDesignData.palette[
                                myDesignData.myDesignColorTable[i][j]][0],
                            myDesignData.palette[
                                myDesignData.myDesignColorTable[i][j]][1],
                            myDesignData.palette[
                                myDesignData.myDesignColorTable[i][j]][2],
                            1,
                          ),
                          border: Utils().markLineBorder(
                              i, j, myDesignData.myDesignColorTable.length),
                        ),
                        child: Text(
                          "${myDesignData.myDesignColorTable[i][j] + 1}",
                          maxLines: 1,
                          style: TextStyle(
                              color: Utils().fontColor(
                            Color.fromRGBO(
                              myDesignData.palette[
                                  myDesignData.myDesignColorTable[i][j]][0],
                              myDesignData.palette[
                                  myDesignData.myDesignColorTable[i][j]][1],
                              myDesignData.palette[
                                  myDesignData.myDesignColorTable[i][j]][2],
                              1,
                            ),
                          )),
                          textAlign: TextAlign.center,
                        ),
                      ),
                ],
              ),
            ),
          );
        } else if (null != snapshot.error) {
          return Container(
            child: Text(
              'No Image Selected',
              textAlign: TextAlign.center,
            ),
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
