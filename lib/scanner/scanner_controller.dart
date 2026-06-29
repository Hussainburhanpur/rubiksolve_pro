import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'color_classifier.dart';
import 'color_sampler.dart';
import 'face_detector.dart';
import 'frame_processor.dart';
import 'stability_filter.dart';

class ScannerController extends ChangeNotifier {
  final StabilityFilter _stabilityFilter = StabilityFilter();

  List<Color> _sampleColors =
      List.generate(9, (_) => Colors.grey);

  bool _detected = false;

  bool _locked = false;

  List<Color> get sampleColors => _sampleColors;

  bool get detected => _detected;

  bool get locked => _locked;

  int get scannedFaces => 1;

  void unlock() {
    _locked = false;
    notifyListeners();
  }

  Future<void> process(CameraImage image) async {
    if (_locked) return;

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

    _sampleColors = face.colors;
    _detected = face.valid;

    notifyListeners();
  }

  void lockFace() {
    _locked = true;
    notifyListeners();
  }

  void reset() {
    _locked = false;
    _detected = false;

    _sampleColors =
        List.generate(9, (_) => Colors.grey);

    _stabilityFilter.reset();

    notifyListeners();
  }
}