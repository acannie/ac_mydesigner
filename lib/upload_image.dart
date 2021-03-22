import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';

import 'mydesign_model.dart';

class UploadImageDemo extends StatefulWidget {
  UploadImageDemo() : super();

  @override
  UploadImageDemoState createState() => UploadImageDemoState();
}

class UploadImageDemoState extends State<UploadImageDemo> {
  //
  static final String uploadEndPoint = 'http://127.0.0.1:3000/ac_mydesign/';
  Future<MemoryImage> future_image_choice;
  MemoryImage image;
  Future<MyDesignData> future_my_design_data;
  String status = '';
  String errMessage = 'Error Uploading Image';

  chooseImage() {
    // debug
    print('Choose Image');
    setState(() {
      future_image_choice = ImagePicker()
          .getImage(source: ImageSource.gallery)
          .then((file) =>
              file.readAsBytes().then((bytes) => new MemoryImage(bytes)));
    });
    setStatus('');
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  startUpload() {
    // debug
    print('Start Upload');
    setStatus('Uploading Image...');
    if (image == null) {
      print('Image is null');
      setStatus(errMessage);
      return;
    }
    upload();
  }

  upload() async {
    var url = Uri.parse(uploadEndPoint);
    var request = new http.MultipartRequest("POST", url);
    request.files.add(await http.MultipartFile.fromBytes(
      'file',
      image.bytes,
      contentType: new MediaType('application', 'octet-stream'),
      filename: "file_up.jpg",
    ));

    // debug
    print('Uploading');
    // TODO
    // setStatus('Uploaded!');
    // TODO
    // status check
    future_my_design_data = request.send().then((response) => response.stream
        .bytesToString()
        .then((body) => MyDesignData.fromJson(json.decode(body))));
  }

  Widget showImage() {
    return FutureBuilder<MemoryImage>(
      future: future_image_choice,
      builder: (BuildContext context, AsyncSnapshot<MemoryImage> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          image = snapshot.data;
          return Flexible(child: Image.memory(image.bytes, fit: BoxFit.fill));
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

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

  Widget showMyDesign() {
    Size screenSize = MediaQuery.of(context).size;
    return FutureBuilder<MyDesignData>(
      future: future_my_design_data,
      builder: (BuildContext context, AsyncSnapshot<MyDesignData> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
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
                                border: markLineBorder(i, j,
                                    myDesignData.myDesignColorTable.length),
                              ),
                              child: AutoSizeText(
                                "${myDesignData.myDesignColorTable[i][j] + 1}",
                                maxLines: 1,
                                style: TextStyle(
                                    color: fontColor(
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
          return CircularProgressIndicator();
        }
      },
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

  Widget showColorPalette() {
    Size screenSize = MediaQuery.of(context).size;

    List<String> columnTitles = ["", "色相", "彩度", "明度"];
    return FutureBuilder<MyDesignData>(
      future: future_my_design_data,
      builder: (BuildContext context, AsyncSnapshot<MyDesignData> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
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
                              color: fontColor(
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
          return CircularProgressIndicator();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
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
                  showImage(),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: OutlinedButton(
                      onPressed: chooseImage,
                      child: Text('Choose Image'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: OutlinedButton(
                      onPressed: startUpload,
                      child: Text('Upload Image'),
                    ),
                  ),
                  Wrap(
                    direction: Axis.horizontal,

                    // mainAxisSize: MainAxisSize.max,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: showMyDesign(),
                      ),
                      // ConstrainedBox(
                      //   constraints: BoxConstraints(maxWidth: 300),
                      //   child: SizedBox(
                      //     width: screenSize.width * 0.6,
                      //     child: ElevatedButton(
                      //       child: Text('Happy Flutter'),
                      //       onPressed: () {},
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: showColorPalette(),
                      ),
                    ],
                  ),
                  // SelectableText(
                  //   status,
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //     color: Colors.green,
                  //     fontWeight: FontWeight.w500,
                  //     fontSize: 20.0,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
