import 'package:vector_math/vector_math_64.dart';

class Camera {
  double yaw;
  double pitch;
  double zoom;

  Camera({
    this.yaw = 0.7,
    this.pitch = -0.5,
    this.zoom = 170,
  });

  Matrix4 get matrix {
    return Matrix4.identity()
      ..rotateX(pitch)
      ..rotateY(yaw);
  }

  void rotate(double dx, double dy) {
    yaw += dx;
    pitch += dy;

    // Prevent camera flipping upside down
    pitch = pitch.clamp(-1.4, 1.4);
  }
}