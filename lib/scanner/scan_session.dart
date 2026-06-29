import '../models/cube/cube_face.dart';

class ScanSession {
  static const List<CubeFace> scanOrder = [
    CubeFace.up,
    CubeFace.front,
    CubeFace.right,
    CubeFace.back,
    CubeFace.left,
    CubeFace.down,
  ];

  int _currentIndex = 0;

  CubeFace get currentFace => scanOrder[_currentIndex];

  int get scannedFaces => _currentIndex;

  bool get isComplete => _currentIndex >= scanOrder.length;

  double get progress => _currentIndex / scanOrder.length;

  bool nextFace() {
    if (_currentIndex < scanOrder.length - 1) {
      _currentIndex++;
      return true;
    }

    _currentIndex = scanOrder.length;
    return false;
  }

  void reset() {
    _currentIndex = 0;
  }
}