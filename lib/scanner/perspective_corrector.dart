import 'package:image/image.dart' as img;

/// Result after perspective correction.
///
/// At the moment this simply returns the original image.
/// In the next iterations this class will transform the detected
/// Rubik's Cube face into a perfectly square image for ML.
class PerspectiveCorrectionResult {
  final img.Image image;

  const PerspectiveCorrectionResult({
    required this.image,
  });
}

class PerspectiveCorrector {
  /// Corrects the perspective of a detected cube face.
  ///
  /// Placeholder implementation.
  /// Later this will:
  /// - Compute the face corners.
  /// - Warp the image.
  /// - Produce a square face image.
  static PerspectiveCorrectionResult correct(
    img.Image image,
  ) {
    return PerspectiveCorrectionResult(
      image: image,
    );
  }
}