import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'frame_processor.dart';
import 'color_sampler.dart';
import 'color_classifier.dart';
import 'stability_filter.dart';
import 'face_detector.dart';

class ScannerController extends ChangeNotifier {
  final StabilityFilter _stabilityFilter = StabilityFilter();

  List<Color> sampleColors = List.generate(
    9,
    (_) => Colors.grey,
  );

  bool detected = false;

  Future<void> process(CameraImage image) async {
    final frame = FrameProcessor.process(image);

    if (frame == null) return;

    final sampled = ColorSampler.sample3x3(
      frame,
      Rect.fromCenter(
        center: Offset(
          frame.width / 2,
          frame.height / 2,
        ),
        width: frame.width * 0.35,
        height: frame.width * 0.35,
      ),
    );

    final classified =
        ColorClassifier.classifyAll(sampled);

    final stable =
        _stabilityFilter.add(classified);

    if (stable == null) return;

    final face = FaceDetector.detect(stable);

    if (!face.valid) return;

    sampleColors = face.colors;
    detected = true;

    notifyListeners();
  }

  void reset() {
    detected = false;

    sampleColors = List.generate(
      9,
      (_) => Colors.grey,
    );

    _stabilityFilter.reset();

    notifyListeners();
  }
}