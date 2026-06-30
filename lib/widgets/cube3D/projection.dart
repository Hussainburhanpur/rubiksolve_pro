import 'package:vector_math/vector_math_64.dart';

class Projection {
  static Vector2 project(
    Vector3 point,
    double width,
    double height,
    double scale,
  ) {
    const perspective = 4.5;

    final z = perspective - point.z;

    final factor = perspective / z;

    return Vector2(
      width / 2 + point.x * factor * scale,
      height / 2 - point.y * factor * scale,
    );
  }
}