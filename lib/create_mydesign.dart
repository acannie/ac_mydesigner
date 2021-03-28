import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
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
          var myDesignData = snapshot.data;
          return Table(
            border: TableBorder.all(),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            defaultColumnWidth: new FixedColumnWidth(16),
            children: List<TableRow>.generate(32, (row_index) {
              return TableRow(
                  children: new List<Widget>.generate(32, (column_index) {
                var color = Color.fromRGBO(
                  myDesignData.palette[myDesignData
                      .myDesignColorTable[row_index][column_index]][0],
                  myDesignData.palette[myDesignData
                      .myDesignColorTable[row_index][column_index]][1],
                  myDesignData.palette[myDesignData
                      .myDesignColorTable[row_index][column_index]][2],
                  1,
                );
                return Container(
                    color: color,
                    height: 16,
                    child: new Center(
                      child: new AutoSizeText(
                        "${myDesignData.myDesignColorTable[row_index][column_index] + 1}",
                        maxLines: 1,
                        style: TextStyle(color: Utils().fontColor(color)),
                        textAlign: TextAlign.center,
                      ),
                    ));
              }));
            }),
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
