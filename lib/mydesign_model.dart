import 'dart:convert';

// サーバから受け取る JSON のモデル
class MyDesignData {
  final List<List<int>> palette;
  final List<List<int>> myDesignColorTable;
  final List<List<int>> myDesignPalette;

  MyDesignData({
    this.palette = const [],
    this.myDesignColorTable = const [[]],
    this.myDesignPalette = const [[]],
  });

  factory MyDesignData.fromJson(Map<String, dynamic> json) => MyDesignData(
        palette: List<List<int>>.from(json["palette"]
            .map((x) => List<int>.from(x.map((x) => x.toInt())))),
        myDesignColorTable: List<List<int>>.from(json["mydesign_color_table"]
            .map((x) => List<int>.from(x.map((x) => x.toInt())))),
        myDesignPalette: List<List<int>>.from(json["mydesign_palette"]
            .map((x) => List<int>.from(x.map((x) => x.toInt())))),
      );

  Map<String, dynamic> toJson() {
    return {
      "palette": List<dynamic>.from(
          palette.map((x) => List<dynamic>.from(x.map((x) => x)))),
      "myDesignColorTable": List<dynamic>.from(
          myDesignColorTable.map((x) => List<dynamic>.from(x.map((x) => x)))),
      "myDesignPalette": List<dynamic>.from(
          myDesignPalette.map((x) => List<dynamic>.from(x.map((x) => x)))),
    };
  }

  static String serialize(MyDesignData mat) {
    return jsonEncode(mat);
  }

  static MyDesignData deserialize(String jsonString) {
    Map<String, dynamic> mat = jsonDecode(jsonString);
    MyDesignData result = MyDesignData.fromJson(mat);
    return result;
  }
}
