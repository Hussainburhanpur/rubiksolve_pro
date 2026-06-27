import 'package:flutter/material.dart';

class FaceDetectionResult {
  final bool valid;
  final List<Color> colors;
  final Color center;

  const FaceDetectionResult({
    required this.valid,
    required this.colors,
    required this.center,
  });
}

class FaceDetector {
  static FaceDetectionResult detect(List<Color> colors) {
    if (colors.length != 9) {
      return const FaceDetectionResult(
        valid: false,
        colors: [],
        center: Colors.transparent,
      );
    }

    return FaceDetectionResult(
      valid: true,
      colors: List<Color>.from(colors),
      center: colors[4], // Center sticker
    );
  }
}