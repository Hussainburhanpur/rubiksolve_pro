import 'package:flutter/material.dart';

/// Represents one detected sticker on a Rubik's Cube face.
class StickerCandidate {
  /// Bounding rectangle of the detected sticker.
  final Rect bounds;

  /// Center point of the sticker.
  final Offset center;

  const StickerCandidate({
    required this.bounds,
    required this.center,
  });
}

/// Result returned by the sticker detector.
class StickerDetectionResult {
  /// Whether a valid face was detected.
  final bool valid;

  /// All detected sticker candidates.
  final List<StickerCandidate> stickers;

  const StickerDetectionResult({
    required this.valid,
    required this.stickers,
  });
}

/// Detects sticker locations from a camera frame.
///
/// NOTE:
/// This is currently a placeholder.
/// The OpenCV implementation will be added in the next step.
class StickerDetector {
  static StickerDetectionResult detect() {
    return const StickerDetectionResult(
      valid: false,
      stickers: [],
    );
  }
}