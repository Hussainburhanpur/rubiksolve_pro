import 'package:flutter/material.dart';

import 'sticker_detector.dart';

/// Result after ordering the detected stickers into
/// a consistent 3×3 grid.
class GridDetectionResult {
  /// True when exactly nine stickers were successfully ordered.
  final bool valid;

  /// Ordered stickers:
  ///
  /// 0 1 2
  /// 3 4 5
  /// 6 7 8
  final List<StickerCandidate> stickers;

  const GridDetectionResult({
    required this.valid,
    required this.stickers,
  });
}

class GridDetector {
  /// Orders sticker candidates into a consistent 3×3 grid.
  ///
  /// Version 2:
  /// - Validates there are exactly 9 stickers.
  /// - Sorts them from top to bottom (Y-axis).
  ///
  /// Future versions:
  /// - Split into rows.
  /// - Sort each row by X.
  /// - Validate spacing.
  /// - Validate geometry.
  static GridDetectionResult detect(
    List<StickerCandidate> stickers,
  ) {
    if (stickers.length != 9) {
      return const GridDetectionResult(
        valid: false,
        stickers: [],
      );
    }

    final List<StickerCandidate> ordered =
        List<StickerCandidate>.from(stickers);

    // First ordering step:
    // Arrange stickers from top to bottom.
    ordered.sort(
      (a, b) => a.center.dy.compareTo(b.center.dy),
    );

    return GridDetectionResult(
      valid: true,
      stickers: ordered,
    );
  }
}