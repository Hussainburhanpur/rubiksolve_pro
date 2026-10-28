import 'package:flutter/material.dart';
import 'color_calibration.dart';

class ColorClassifier {
  static final ColorCalibration calibration = ColorCalibration();
  static Color classify(Color color) {
    final hsv = HSVColor.fromColor(color);

    final h = hsv.hue;
    final s = hsv.saturation;
    final v = hsv.value;

    // White
    if (v > 0.82 && s < 0.22) {
      return Colors.white;
    }

    // Yellow
    if (h >= 38 && h <= 70 && s > 0.30) {
      return Colors.yellow;
    }

    // Orange
    if (h >= 15 && h < 38 && s > 0.35) {
      return Colors.orange;
    }

    // Red
    if ((h >= 345 || h <= 15) && s > 0.35) {
      return Colors.red;
    }

    // Green
    if (h >= 75 && h <= 165 && s > 0.25) {
      return Colors.green;
    }

    // Blue
    if (h >= 180 && h <= 260 && s > 0.25) {
      return Colors.blue;
    }

    // Bright but low saturation → White
    if (v > 0.75 && s < 0.30) {
      return Colors.white;
    }

    return Colors.grey;
  }

  static List<Color> classifyAll(List<Color> colors) {
    return colors.map(classify).toList();
  }
}