import 'cube_color.dart';
import 'cube_face.dart';

class ScannedFace {
  final CubeFace face;
  final List<CubeColor> stickers;

  const ScannedFace({
    required this.face,
    required this.stickers,
  });

  bool get isValid => stickers.length == 9;
}