import 'dart:ui';

import 'package:flutter/material.dart';

class PodiumColors {
  static Color podiumColor(int i) {
    Color color = Colors.white;
    switch (i) {
      case 0:
        color = Colors.amberAccent[100];
        break;
      case 1:
        color = Colors.grey[300];
        break;
      case 2:
        color = Colors.brown[200];
        break;
    }
    return color;
  }
}
