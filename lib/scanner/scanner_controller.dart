import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../models/cube/cube_color.dart';
import '../models/cube/cube_face.dart';
import '../models/cube/scanned_face.dart';
import 'color_classifier.dart';
import 'color_mapper.dart';
import 'face_storage.dart';
import 'frame_processor.dart';
import 'geometry_validator.dart';
import 'grid_detector.dart';
import 'scan_session.dart';
import 'scanner_state.dart';
import 'stability_filter.dart';
import 'sticker_detector.dart';

/// Coordinates live 3x3 face scanning.
///
/// Note: StickerDetector currently samples a centered, fixed 3x3 guide. It is
/// not yet a contour-based cube detector; this controller does not claim that
/// a physical cube has been geometrically located in the camera frame.
class ScannerController extends ChangeNotifier {
  final StabilityFilter _stabilityFilter = StabilityFilter();
  final ScanSession _scanSession = ScanSession();

  ScannerState _state = const ScannerState();
  List<Color> _stableColors = const [];

  ScannerState get state => _state;
  bool get detected => _state.detected;
  bool get geometryValid => _state.geometryValid;
  List<Color> get sampleColors => _state.sampleColors;

  List<CubeFace> get scannedFaces => ScanSession.scanOrder
      .where((face) => FaceStorage.instance.hasFace(face))
      .toList();

  CubeFace? get currentFace => _scanSession.currentFace;
  bool get scanComplete => FaceStorage.instance.isComplete;

  Future<void> process(CameraImage image) async {
    if (scanComplete) return;

    final rgbImage = FrameProcessor.process(image);
    if (rgbImage == null) {
      _updateDetection(detected: false, geometryValid: false);
      return;
    }

    // IMPORTANT: sample colors from the RGB image. Grayscale preprocessing
    // destroys sticker color information, so it must not feed color sampling.
    final stickerResult = StickerDetector.detect(rgbImage);
    if (!stickerResult.valid) {
      _stableColors = const [];
      _state = _state.copyWith(sampleColors: const []);
      _updateDetection(detected: false, geometryValid: false);
      return;
    }

    // Normalize camera colors into the six supported cube colors before
    // stability checking. Raw RGB values fluctuate between frames.
    final classifiedColors =
        ColorClassifier.classifyAll(stickerResult.sampleColors);

    final stableColors = _stabilityFilter.add(classifiedColors);
    _state = _state.copyWith(sampleColors: classifiedColors);
    _stableColors = stableColors ?? const [];

    if (stableColors == null) {
      _updateDetection(detected: true, geometryValid: false);
      return;
    }

    final grid = GridDetector.detect(stickerResult.stickers);
    if (!grid.valid) {
      _updateDetection(detected: false, geometryValid: false);
      return;
    }

    final geometry = GeometryValidator.validate(grid.stickers);
    _updateDetection(
      detected: true,
      geometryValid: geometry.valid,
    );
  }

  void captureFace() {
    if (scanComplete) {
      debugPrint('Capture ignored: all six faces have already been scanned.');
      return;
    }

    if (!_state.geometryValid || _stableColors.length != 9) {
      debugPrint(
        'Capture rejected: no stable 3x3 sample is available '
        '(geometryValid=${_state.geometryValid}, '
        'stableColors=${_stableColors.length}).',
      );
      return;
    }

    final face = currentFace;
    if (face == null) return;

    final colors = ColorMapper.fromFlutterColors(_stableColors);
    if (colors.length != 9 || colors.contains(CubeColor.unknown)) {
      debugPrint('Capture rejected: one or more sticker colors are unknown.');
      return;
    }

    FaceStorage.instance.addFace(
      ScannedFace(face: face, stickers: colors),
    );

    // Do not let frames from the previous face count toward stability for
    // the next face. The next face must settle independently.
    _stabilityFilter.reset();
    _stableColors = const [];
    _state = _state.copyWith(
      detected: false,
      geometryValid: false,
      sampleColors: const [],
    );

    if (!_scanSession.isComplete) {
      _scanSession.nextFace();
    }

    notifyListeners();
  }

  void reset() {
    _scanSession.reset();
    FaceStorage.instance.reset();
    _stabilityFilter.reset();
    _stableColors = const [];
    _state = const ScannerState();
    notifyListeners();
  }

  void disposeScanner() => reset();

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
}
