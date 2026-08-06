import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'preprocessor.dart';
import '../models/cube/cube_face.dart';

import 'scanner_state.dart';
import 'frame_processor.dart';
import 'edge_detector.dart';
import 'sticker_detector.dart';
import 'grid_detector.dart';
import 'geometry_validator.dart';

class ScannerController extends ChangeNotifier {
  ScannerState _state = const ScannerState();

  ScannerState get state => _state;

  bool get detected => _state.detected;

  bool get geometryValid => _state.geometryValid;

  List<Color> get sampleColors => _state.sampleColors;

  final List<CubeFace> _scannedFaces = [];

  List<CubeFace> get scannedFaces => List.unmodifiable(_scannedFaces);

  Future<void> process(CameraImage image) async {
    final rgbImage = FrameProcessor.process(image);

    if (rgbImage == null) {
      _updateDetection(
        detected: false,
        geometryValid: false,
      );
      return;
    }

    final preprocessed = Preprocessor.process(rgbImage);

final edges = EdgeDetector.detect(preprocessed.image);
debugPrint(edges.toString());

final stickerResult = StickerDetector.detect(preprocessed.image);

    _state = _state.copyWith(
      sampleColors: stickerResult.sampleColors,
    );
    notifyListeners();

    if (!stickerResult.valid) {
      _updateDetection(
        detected: false,
        geometryValid: false,
      );
      return;
    }

    final grid = GridDetector.detect(
      stickerResult.stickers,
    );

    if (!grid.valid) {
      _updateDetection(
        detected: false,
        geometryValid: false,
      );
      return;
    }

    final geometry = GeometryValidator.validate(
      grid.stickers,
    );

    _updateDetection(
      detected: true,
      geometryValid: geometry.valid,
    );
  }

  void captureFace() {
    if (!_state.geometryValid) {
      return;
    }

    // TODO
  }

  void reset() {
    _scannedFaces.clear();

    _state = const ScannerState();

    notifyListeners();
  }

  void disposeScanner() {
    reset();
  }

  void _updateDetection({
    required bool detected,
    required bool geometryValid,
  }) {
    _state = _state.copyWith(
      detected: detected,
      geometryValid: geometryValid,
    );

    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}