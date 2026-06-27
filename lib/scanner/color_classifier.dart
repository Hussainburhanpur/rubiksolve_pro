import 'package:flutter/material.dart';

enum CubeStickerColor {
  white,
  yellow,
  red,
  orange,
  blue,
  green,
  unknown,
}

class ColorClassifier {
  static CubeStickerColor classify(Color color) {
    final hsv = HSVColor.fromColor(color);

    // White
    if (hsv.saturation < 0.18 && hsv.value > 0.70) {
      return CubeStickerColor.white;
    }

    // Yellow
    if (hsv.hue >= 40 && hsv.hue <= 75) {
      return CubeStickerColor.yellow;
    }

    // Orange
    if (hsv.hue >= 15 && hsv.hue < 40) {
      return CubeStickerColor.orange;
    }

    // Red
    if (hsv.hue < 15 || hsv.hue > 340) {
      return CubeStickerColor.red;
    }

    // Green
    if (hsv.hue >= 75 && hsv.hue <= 170) {
      return CubeStickerColor.green;
    }

    // Blue
    if (hsv.hue >= 170 && hsv.hue <= 280) {
      return CubeStickerColor.blue;
    }

    return CubeStickerColor.unknown;
  }
}