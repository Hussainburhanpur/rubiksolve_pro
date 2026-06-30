import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'face_storage.dart';
import 'scan_session.dart';
import 'color_classifier.dart';
import 'color_sampler.dart';
import 'face_detector.dart';
import 'frame_processor.dart';
import 'stability_filter.dart';
import '../models/cube/scanned_face.dart';
import '../models/cube/cube_face.dart';
import 'color_mapper.dart';
import 'face_identifier.dart';

class ScannerController extends ChangeNotifier {
  final StabilityFilter _stabilityFilter = StabilityFilter();
  final FaceStorage _storage = FaceStorage.instance;
  final ScanSession _session = ScanSession();

  List<Color>? _lastCapturedFace;

  List<Color> _sampleColors =
      List.generate(9, (_) => Colors.grey);

  bool _detected = false;

  bool _locked = false;

  List<Color> get sampleColors => _sampleColors;

  bool get detected => _detected;

  bool get locked => _locked;
  
  int _scannedFaces = 0;

  int get scannedFaces => _storage.scannedFaces;

  bool _sameFace(List<Color> a, List<Color> b) {
  if (a.length != b.length) return false;

  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) {
      return false;
    }
  }

  return true;
}

  void captureFace() {
  final stickers = ColorMapper.fromFlutterColors(
    _sampleColors,
  );

  final face = FaceIdentifier.identify(
    stickers[4], // Center sticker
  );

  _storage.addFace(
    ScannedFace(
      face: face,
      stickers: stickers,
    ),
  );

  notifyListeners();
}

  Future<void> process(CameraImage image) async {
    if (_locked) {
  final frame = FrameProcessor.process(image);
  if (frame == null) return;

  final sampled = ColorSampler.sample3x3(
    frame,
    Rect.fromCenter(
      center: Offset(frame.width / 2, frame.height / 2),
      width: frame.width * 0.35,
      height: frame.width * 0.35,
    ),
  );

  final classified = ColorClassifier.classifyAll(sampled);
  final stable = _stabilityFilter.add(classified);

  if (stable == null) return;

  final face = FaceDetector.detect(stable);

  if (!_sameFace(_lastCapturedFace!, face.colors)) {
    _locked = false;
  }

  return;
}
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

  final classified = ColorClassifier.classifyAll(sampled);

  final stable = _stabilityFilter.add(classified);

  if (stable == null) return;

  final face = FaceDetector.detect(stable);

  _sampleColors = face.colors;
  _detected = face.valid;


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