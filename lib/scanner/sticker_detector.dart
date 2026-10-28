
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

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
  static Color? _averageColor(img.Image image, Rect region) {
    final left = region.left.floor().clamp(0, image.width);
    final top = region.top.floor().clamp(0, image.height);
    final right = region.right.ceil().clamp(left, image.width);
    final bottom = region.bottom.ceil().clamp(top, image.height);

    if (right <= left || bottom <= top) return null;

    int r = 0, g = 0, b = 0, count = 0;

    for (int y = top; y < bottom; y++) {
      for (int x = left; x < right; x++) {
        final pixel = image.getPixel(x, y);
        r += pixel.r.toInt();
        g += pixel.g.toInt();
        b += pixel.b.toInt();
        count++;
      }
    }

    if (count == 0) return null;

    return Color.fromARGB(255, r ~/ count, g ~/ count, b ~/ count);
  }

  static StickerDetectionResult detect(
    img.Image image, {
    double regionFraction = 0.70,
  }) {
    if (image.width < 3 ||
        image.height < 3 ||
        regionFraction <= 0 ||
        regionFraction > 1) {
      return const StickerDetectionResult(
        valid: false,
        stickers: [],
      );
    }

    const grid = 3;
    final side = (image.width < image.height
            ? image.width
            : image.height) *
        regionFraction;
    final left = (image.width - side) / 2;
    final top = (image.height - side) / 2;
    final cell = side / grid;
    final inset = cell * 0.20;

    final stickers = <StickerCandidate>[];
    final colors = <Color>[];

    for (int row = 0; row < grid; row++) {
      for (int col = 0; col < grid; col++) {
        final cellLeft = left + col * cell;
        final cellTop = top + row * cell;
        final bounds = Rect.fromLTWH(cellLeft, cellTop, cell, cell);
        final sampleRegion = Rect.fromLTWH(
          cellLeft + inset,
          cellTop + inset,
          cell - 2 * inset,
          cell - 2 * inset,
        );

        final color = _averageColor(image, sampleRegion);
        if (color == null) {
          return StickerDetectionResult(
            valid: false,
            stickers: stickers,
            sampleColors: colors,
          );
        }

        stickers.add(StickerCandidate(
          bounds: bounds,
          center: bounds.center,
        ));
        colors.add(color);
      }
    }

    return StickerDetectionResult(
      valid: stickers.length == 9 && colors.length == 9,
      stickers: stickers,
      sampleColors: colors,
    );
  }
}
