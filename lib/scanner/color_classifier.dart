import 'package:flutter/material.dart';

class ColorClassifier {
  static Color classify(Color color) {
    final hsv = HSVColor.fromColor(color);

    final h = hsv.hue;
    final s = hsv.saturation;
    final v = hsv.value;

    // White
    if (s < 0.18 && v > 0.75) {
      return Colors.white;
    }

    // Yellow
    if (h >= 40 && h <= 75) {
      return Colors.yellow;
    }

    // Green
    if (h >= 75 && h <= 170) {
      return Colors.green;
    }

    // Blue
    if (h >= 170 && h <= 260) {
      return Colors.blue;
    }

    // Red
    if (h >= 340 || h <= 20) {
      return Colors.red;
    }

    // Orange
    if (h > 20 && h < 40) {
      return Colors.orange;
    }

    return Colors.grey;
  }

  static List<Color> classifyAll(List<Color> colors) {
    return colors.map(classify).toList();
  }
}