import 'dart:ui';

import 'package:flutter/material.dart';

class RainbowColors {
  static Color rainbowColor(int i) {
    i = getRainbowColorNumber(i);
    Color color = Colors.black;
    switch (i) {
      case 0:
        color = Colors.red[400];
        break;
      case 1:
        color = Colors.orange;
        break;
      case 2:
        color = Colors.yellowAccent[700];
        break;
      case 3:
        color = Colors.green[400];
        break;
      case 4:
        color = Colors.blue[400];
        break;
      case 5:
        color = Colors.indigo[300];
        break;
      case 6:
        color = Colors.purple[300];
        break;
    }
    return color;
  }

  static int getRainbowColorNumber(int index) => index < 7 ? index : (index % 7).toInt();
}
