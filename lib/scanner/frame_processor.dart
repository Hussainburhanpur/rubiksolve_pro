import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;

/// Converts a CameraImage in YUV420 format into an RGB image.
///
/// Uses each plane's row and pixel stride instead of assuming rows are tightly
/// packed. Camera plugins may add padding to a plane's rows.
class FrameProcessor {
  static img.Image? process(CameraImage image) {
    if (image.format.group != ImageFormatGroup.yuv420 ||
        image.planes.length < 3) {
      return null;
    }

    final width = image.width;
    final height = image.height;
    final yPlane = image.planes[0];
    final uPlane = image.planes[1];
    final vPlane = image.planes[2];

    final Uint8List yBytes = yPlane.bytes;
    final Uint8List uBytes = uPlane.bytes;
    final Uint8List vBytes = vPlane.bytes;

    final yRowStride = yPlane.bytesPerRow;
    final yPixelStride = yPlane.bytesPerPixel ?? 1;
    final uvRowStride = uPlane.bytesPerRow;
    final uvPixelStride = uPlane.bytesPerPixel ?? 1;
    final vRowStride = vPlane.bytesPerRow;
    final vPixelStride = vPlane.bytesPerPixel ?? uvPixelStride;

    final rgbImage = img.Image(width: width, height: height);

    for (var y = 0; y < height; y++) {
      final yRow = y * yRowStride;
      final uvY = y >> 1;
      final uRow = uvY * uvRowStride;
      final vRow = uvY * vRowStride;

      for (var x = 0; x < width; x++) {
        final yIndex = yRow + x * yPixelStride;
        final uvX = x >> 1;
        final uIndex = uRow + uvX * uvPixelStride;
        final vIndex = vRow + uvX * vPixelStride;

        if (yIndex >= yBytes.length ||
            uIndex >= uBytes.length ||
            vIndex >= vBytes.length) {
          continue;
        }

        final yp = yBytes[yIndex];
        final up = uBytes[uIndex];
        final vp = vBytes[vIndex];

        final r = (yp + 1.402 * (vp - 128)).round().clamp(0, 255);
        final g = (yp -
                0.344136 * (up - 128) -
                0.714136 * (vp - 128))
            .round()
            .clamp(0, 255);
        final b = (yp + 1.772 * (up - 128)).round().clamp(0, 255);

        rgbImage.setPixelRgb(x, y, r, g, b);
      }
    }

    return rgbImage;
  }
}
