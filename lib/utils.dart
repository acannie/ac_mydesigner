import 'dart:math';

import 'package:flutter/material.dart';

// ロジック系の関数
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
