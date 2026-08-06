import 'package:image/image.dart' as img;

/// Result produced by the edge detector.
class EdgeDetectionResult {
  final img.Image image;

  const EdgeDetectionResult({
    required this.image,
  });
}

class EdgeDetector {
  static EdgeDetectionResult detect(
    img.Image image,
  ) {
    // Step 1
    final gray = img.grayscale(image);

    // Step 2
    final blurred = img.gaussianBlur(
      gray,
      radius: 2,
    );

    return EdgeDetectionResult(
      image: blurred,
    );
  }
}