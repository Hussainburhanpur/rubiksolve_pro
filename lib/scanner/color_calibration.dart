import 'package:flutter/material.dart';

class ColorCalibration {
  static Color? whiteReference;

  static bool get isCalibrated => whiteReference != null;

  static void calibrateWhite(Color color) {
    whiteReference = color;
  }

  static void reset() {
    whiteReference = null;
  }
}