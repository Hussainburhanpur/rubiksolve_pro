import 'package:vector_math/vector_math_64.dart';

class Camera {
  double yaw;
  double pitch;
  double zoom;

  Camera({
  this.yaw = 0.0,
  this.pitch = 0.45,
  this.zoom = 230,
});

  Matrix4 get matrix {
    return Matrix4.identity()
      ..rotateX(pitch)
      ..rotateY(yaw);
  }

  void rotate(double dx, double dy) {
    yaw += dx;
    pitch += dy;

    pitch = pitch.clamp(-1.4, 1.4);
  }

  void setOrientation({
    required double targetYaw,
    required double targetPitch,
  }) {
    yaw = targetYaw;
    pitch = targetPitch;

    pitch = pitch.clamp(-1.4, 1.4);
  }
}