import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

/// Represents one detected sticker.
class StickerCandidate {
  final Rect bounds;
  final Offset center;

  const StickerCandidate({
    required this.bounds,
    required this.center,
  });
}

class StickerDetectionResult {
  final bool valid;
  final List<StickerCandidate> stickers;
  final List<Color> sampleColors;

  const StickerDetectionResult({
    required this.valid,
    required this.stickers,
    this.sampleColors = const [],
  });
}

class StickerDetector {
  static StickerDetectionResult detect(img.Image image) {
    final List<Color> colors = [];

    const int grid = 3;

    final double cellW = image.width / grid;
    final double cellH = image.height / grid;

    for (int row = 0; row < grid; row++) {
      for (int col = 0; col < grid; col++) {
        final int x = (cellW * (col + 0.5)).round();
        final int y = (cellH * (row + 0.5)).round();

        final pixel = image.getPixel(x, y);

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

    return StickerDetectionResult(
      valid: false,
      stickers: const [],
      sampleColors: colors,
    );
  }
}