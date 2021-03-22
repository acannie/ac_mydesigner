import 'package:flutter/material.dart'; //google提供のUIデザイン
import 'package:http/http.dart' as http; //httpリクエスト用
import 'dart:async'; //非同期処理用
import 'dart:convert'; //httpレスポンスをJSON形式に変換用
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';

class PickedImageController with ChangeNotifier {
  Future<MemoryImage> _imageFuture;

  Future<MemoryImage> get imageFuture => _imageFuture;

  Future<MemoryImage> pickImage() async {
    _imageFuture = ImagePicker().getImage(source: ImageSource.gallery).then(
        (file) => file.readAsBytes().then((bytes) => new MemoryImage(bytes)));

    // For other components
    notifyListeners();
    return _imageFuture;
  }
}

class PickedImageWidget extends StatelessWidget {
  final PickedImageController controller = PickedImageController();

  Future<MemoryImage> _future;

  @override
  Widget build(BuildContext context) {
    final PickedImageController controller =
        Provider.of<PickedImageController>(context);

    // https://qiita.com/beeeyan/items/8f39120501b6334350ed
    return Padding(
      padding: EdgeInsets.all(20),
      child: FutureBuilder<MemoryImage>(
          future: _future,
          builder: (BuildContext context, AsyncSnapshot<MemoryImage> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                null != snapshot.data) {
              final image = snapshot.data;
              return InkWell(
                  onTap: () {
                    _future = controller.pickImage();
                  },
                  child: Image.memory(image.bytes, fit: BoxFit.fill));
            } else {
              return Padding(
                padding: EdgeInsets.all(20),
                child: OutlinedButton(
                  onPressed: () {
                    _future = controller.pickImage();
                  },
                  child: Text('Choose Image'),
                ),
              );
            }
          }),
    );
  }
}

class ImageUploadController with ChangeNotifier {
  Future<MyDesignData> _myDesignDataFuture;

  Future<MyDesignData> get myDesignDataFuture => _myDesignDataFuture;

  static final String uploadEndPoint = 'http://127.0.0.1:3000/ac_mydesign/';

  Future<MyDesignData> upload(MemoryImage image) async {
    var url = Uri.parse(uploadEndPoint);
    var request = new http.MultipartRequest("POST", url);
    request.files.add(http.MultipartFile.fromBytes(
      'file',
      image.bytes,
      contentType: new MediaType('application', 'octet-stream'),
      filename: "file_up.jpg",
    ));

    // notify before
    _myDesignDataFuture = request.send().then((response) => response.stream
        .bytesToString()
        .then((body) => MyDesignData.fromJson(json.decode(body))));
    notifyListeners();
    return _myDesignDataFuture;
  }
}

class ImageUploadButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PickedImageController image_controller =
        Provider.of<PickedImageController>(context);

    final ImageUploadController upload_controller =
        Provider.of<ImageUploadController>(context);

    return FutureBuilder<MemoryImage>(
        future: image_controller.imageFuture,
        builder: (BuildContext context, AsyncSnapshot<MemoryImage> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              null != snapshot.data) {
            final image = snapshot.data;
            return Padding(
              padding: EdgeInsets.all(20),
              child: OutlinedButton(
                onPressed: () {
                  return upload_controller.upload(image);
                },
                child: Text('Upload Image'),
              ),
            );
          } else {
            return SizedBox.shrink();
          }
        });
  }
}

class Utils {
  Border markLineBorder(int i, int j, int n) {
    int halfwayPoint = (n / 2).round();
    return Border(
      bottom: (() {
        if (i + 1 == halfwayPoint) {
          return BorderSide(
            color: Colors.black38,
            width: 2,
          );
        } else {
          return BorderSide(
            color: Colors.black12,
            width: 1,
          );
        }
      })(),
      right: (() {
        if (j + 1 == halfwayPoint) {
          return BorderSide(
            color: Colors.black38,
            width: 2,
          );
        } else {
          return BorderSide(
            color: Colors.black12,
            width: 1,
          );
        }
      })(),
    );
  }

  Color fontColor(Color backgroundColor) {
    int brightness = [
      backgroundColor.red,
      backgroundColor.green,
      backgroundColor.blue
    ].reduce(max);
    if (brightness > 180) {
      return Colors.black;
    } else {
      return Colors.white;
    }
  }
}

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
          return ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: Container(
              child: Column(
                children: [
                  for (var i = 0;
                      i < myDesignData.myDesignColorTable.length;
                      i++)
                    Row(
                      children: [
                        for (var j = 0;
                            j < myDesignData.myDesignColorTable.length;
                            j++)
                          Expanded(
                            flex: 1,
                            child: Container(
                              // width: 10,
                              // height: 10,
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
                                border: Utils().markLineBorder(i, j,
                                    myDesignData.myDesignColorTable.length),
                              ),
                              child: AutoSizeText(
                                "${myDesignData.myDesignColorTable[i][j] + 1}",
                                maxLines: 1,
                                style: TextStyle(
                                    color: Utils().fontColor(
                                  Color.fromRGBO(
                                    myDesignData.palette[myDesignData
                                        .myDesignColorTable[i][j]][0],
                                    myDesignData.palette[myDesignData
                                        .myDesignColorTable[i][j]][1],
                                    myDesignData.palette[myDesignData
                                        .myDesignColorTable[i][j]][2],
                                    1,
                                  ),
                                )),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
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

class MyDesignColorPalette extends StatelessWidget {
  final List<String> columnTitles = ["", "色相", "彩度", "明度"];

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
          return ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 300),
            child: Column(
              children: [
                // index
                Row(
                  children: columnTitles
                      .map(
                        (columnTitle) => Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              color: Colors.white,
                            ),
                            // width: screenSize.width * 0.1,
                            // height: screenSize.height * 0.025,
                            child: AutoSizeText(
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
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
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
                          child: AutoSizeText(
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
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              color: Colors.white,
                            ),
                            child: AutoSizeText(
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

class MyDesignData {
  final List<List<int>> palette;
  final List<List<int>> myDesignColorTable;
  final List<List<int>> myDesignPalette;

  MyDesignData({
    this.palette,
    this.myDesignColorTable,
    this.myDesignPalette,
  });

  factory MyDesignData.fromJson(Map<String, dynamic> json) => MyDesignData(
        palette: List<List<int>>.from(json["palette"]
            .map((x) => List<int>.from(x.map((x) => x.toInt())))),
        myDesignColorTable: List<List<int>>.from(json["mydesign_color_table"]
            .map((x) => List<int>.from(x.map((x) => x.toInt())))),
        myDesignPalette: List<List<int>>.from(json["mydesign_palette"]
            .map((x) => List<int>.from(x.map((x) => x.toInt())))),
      );

  Map<String, dynamic> toJson() => {
        "palette": List<dynamic>.from(
            palette.map((x) => List<dynamic>.from(x.map((x) => x)))),
        "myDesignColorTable": List<dynamic>.from(
            myDesignColorTable.map((x) => List<dynamic>.from(x.map((x) => x)))),
        "myDesignPalette": List<dynamic>.from(
            myDesignPalette.map((x) => List<dynamic>.from(x.map((x) => x)))),
      };

  static String serialize(MyDesignData mat) {
    return jsonEncode(mat);
  }

  static MyDesignData deserialize(String jsonString) {
    Map mat = jsonDecode(jsonString);
    var result = MyDesignData.fromJson(mat);
    return result;
  }
}
