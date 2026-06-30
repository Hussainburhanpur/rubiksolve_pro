import 'package:flutter/material.dart';

import '../models/cube/cube_color.dart';

class ColorMapper {
  static CubeColor fromFlutterColor(Color color) {
    if (color == Colors.white) {
      return CubeColor.white;
    }

    if (color == Colors.yellow) {
      return CubeColor.yellow;
    }

    if (color == Colors.red) {
      return CubeColor.red;
    }

    if (color == Colors.orange) {
      return CubeColor.orange;
    }

    if (color == Colors.blue) {
      return CubeColor.blue;
    }

    if (color == Colors.green) {
      return CubeColor.green;
    }

    return CubeColor.unknown;
  }

  static List<CubeColor> fromFlutterColors(
    List<Color> colors,
  ) {
    return colors.map(fromFlutterColor).toList();
  }
}