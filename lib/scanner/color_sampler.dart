import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

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
        final int centerX =
            (scanArea.left + cellW * col + cellW / 2).round();

        final int centerY =
            (scanArea.top + cellH * row + cellH / 2).round();

        int r = 0;
        int g = 0;
        int b = 0;
        int count = 0;

        // Sample a 9x9 square around the center
        for (int dy = -4; dy <= 4; dy++) {
          for (int dx = -4; dx <= 4; dx++) {
            final int px =
                (centerX + dx).clamp(0, image.width - 1);

            final int py =
                (centerY + dy).clamp(0, image.height - 1);

            final pixel = image.getPixel(px, py);

            r += pixel.r.toInt();
            g += pixel.g.toInt();
            b += pixel.b.toInt();

            count++;
          }
        }

        colors.add(
          Color.fromARGB(
            255,
            (r / count).round(),
            (g / count).round(),
            (b / count).round(),
          ),
        );
      }
    }

    return colors;
  }
}