import 'sticker_detector.dart';

class GeometryValidationResult {
  final bool valid;

  const GeometryValidationResult({
    required this.valid,
  });
}

class GeometryValidator {
  /// Version 1
  ///
  /// Basic validation:
  /// - Exactly 9 stickers.
  /// - Sticker centers are finite numbers.
  static GeometryValidationResult validate(
    List<StickerCandidate> stickers,
  ) {
    if (stickers.length != 9) {
      return const GeometryValidationResult(
        valid: false,
      );
    }

    for (final sticker in stickers) {
      if (!sticker.center.dx.isFinite ||
          !sticker.center.dy.isFinite) {
        return const GeometryValidationResult(
          valid: false,
        );
      }
    }

    return const GeometryValidationResult(
      valid: true,
    );
  }
}