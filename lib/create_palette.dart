import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'utils.dart';
import 'upload_image.dart';
import 'mydesign_model.dart';

// マイデザインのパレットを生成
class MyDesignColorPalette extends StatelessWidget {
  final List<String> columnTitles = ["色番号", "色相", "彩度", "明度"];

  @override
  Widget build(BuildContext context) {
    final ImageUploadController upload_controller =
        Provider.of<ImageUploadController>(context);

    return FutureBuilder<MyDesignData>(
      future: upload_controller.myDesignDataFuture,
      builder: (BuildContext context, AsyncSnapshot<MyDesignData> snapshot) {
        // return CircularProgressIndicator();

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          var myDesignData = snapshot.data!;
          List<List<int>>? pallete = myDesignData.myDesignPalette;
          return ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 300),
            child: Table(
              children: <TableRow>[
                TableRow(
                  children: columnTitles
                      .map(
                        (columnTitle) => TableCell(
                          // flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              color: Colors.white,
                            ),
                            // width: screenSize.width * 0.1,
                            // height: screenSize.height * 0.025,
                            child: Text(
                              columnTitle.toString(),
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                // information of each color
                for (var i = 0; i < myDesignData.myDesignPalette.length; i++)
                  TableRow(
                    children: [
                      TableCell(
                        // flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            color: Color.fromRGBO(
                              myDesignData.palette[i][0],
                              myDesignData.palette[i][1],
                              myDesignData.palette[i][2],
                              1,
                            ),
                          ),
                          // width: screenSize.width * 0.1,
                          // height: screenSize.height * 0.025,
                          child: Text(
                            "${i + 1}",
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 20,
                              color: Utils().fontColor(
                                Color.fromRGBO(
                                  myDesignData.palette[i][0],
                                  myDesignData.palette[i][1],
                                  myDesignData.palette[i][2],
                                  1,
                                ),
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      for (var factor = 0;
                          factor < myDesignData.myDesignPalette[i].length;
                          factor++)
                        TableCell(
                          // flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              color: Colors.white,
                            ),
                            child: Text(
                              "${myDesignData.myDesignPalette[i][factor]}",
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  )
              ],
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
