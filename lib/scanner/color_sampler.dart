import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';

class ColorSampler {
  static List<Color> sample3x3(
    img.Image image,
    Rect scanArea,
  ) {
    final List<Color> colors = [];

    final double cellW = scanArea.width / 3;
    final double cellH = scanArea.height / 3;

    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        final int x = (scanArea.left + cellW * col + cellW / 2).round();
        final int y = (scanArea.top + cellH * row + cellH / 2).round();

        final pixel = image.getPixel(
          x.clamp(0, image.width - 1),
          y.clamp(0, image.height - 1),
        );

        colors.add(
          Color.fromARGB(
            255,
            pixel.r.toInt(),
            pixel.g.toInt(),
            pixel.b.toInt(),
          ),
        );
      }
    }

    return colors;
  }
}