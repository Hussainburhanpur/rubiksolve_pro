import 'package:image/image.dart' as img;

/// Result produced by the edge detector.
///
/// Later this image will be passed to the StickerDetector.
class EdgeDetectionResult {
  final img.Image image;

  const EdgeDetectionResult({
    required this.image,
  });
}

class EdgeDetector {
  /// Detects edges in an RGB image.
  ///
  /// Current Version:
  /// - Converts the image to grayscale.
  ///
  /// Future Versions:
  /// - Gaussian Blur
  /// - Sobel Gradient
  /// - Canny Edge Detection
  /// - Morphological Cleanup
  static EdgeDetectionResult detect(
    img.Image image,
  ) {
    final img.Image gray = img.grayscale(image);

    return EdgeDetectionResult(
      image: gray,
    );
  }
}