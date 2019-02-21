import 'dart:ui';

import 'package:flutter/material.dart';

class RainbowColors {
  static Color rainbowColor(int i) {
    i = getRainbowColorNumber(i);
    Color color = Colors.black;
    switch (i) {
      case 0:
        color = Colors.red;
        break;
      case 1:
        color = Colors.orange;
        break;
      case 2:
        color = Colors.yellow;
        break;
      case 3:
        color = Colors.green;
        break;
      case 4:
        color = Colors.blue;
        break;
      case 5:
        color = Colors.indigo;
        break;
      case 6:
        color = Colors.purple;
        break;
    }
    return color;
  }

  static int getRainbowColorNumber(int index) => index < 7 ? index : (index % 7).toInt();
}
