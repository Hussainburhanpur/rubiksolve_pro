import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;

class FrameProcessor {
  static img.Image? process(CameraImage cameraImage) {
    try {
      if (cameraImage.format.group != ImageFormatGroup.yuv420) {
        return null;
      }

      final width = cameraImage.width;
      final height = cameraImage.height;

      final image = img.Image(width: width, height: height);

      final Uint8List yPlane = cameraImage.planes[0].bytes;
      final int bytesPerRow = cameraImage.planes[0].bytesPerRow;

      for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
          final int index = y * bytesPerRow + x;
          final int luma = yPlane[index];

          image.setPixelRgb(x, y, luma, luma, luma);
        }
      }

      return image;
    } catch (_) {
      return null;
    }
  }
}