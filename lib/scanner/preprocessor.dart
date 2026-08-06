import 'package:image/image.dart' as img;

/// Image produced after preprocessing.
///
/// Later this class can also contain:
/// - blurred image
/// - threshold image
/// - edge image
/// - debug images
class PreprocessedImage {
  final img.Image image;

  const PreprocessedImage({
    required this.image,
  });
}

class Preprocessor {
  /// Improves the input image before feature detection.
  ///
  /// Current pipeline:
  /// 1. Clone image
  /// 2. Convert to grayscale
  ///
  /// Future pipeline:
  /// 1. White balance
  /// 2. Contrast normalization
  /// 3. Gaussian blur
  /// 4. Adaptive threshold
  /// 5. Morphological cleanup
  static PreprocessedImage process(
    img.Image input,
  ) {
    final img.Image image = img.Image.from(input);

    img.grayscale(image);

    return PreprocessedImage(
      image: image,
    );
  }
}