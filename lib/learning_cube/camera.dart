import 'package:vector_math/vector_math_64.dart';
import 'dart:math' as math;

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
      ..rotateX(-pitch)
      ..rotateY(yaw);
  }

  
void rotate(double dx, double dy) {
  final horizontalDirection = math.cos(pitch);

  yaw += dx * horizontalDirection;
  pitch += dy;
}


  void setOrientation({
    required double targetYaw,
    required double targetPitch,
  }) {
    yaw = targetYaw;
    pitch = targetPitch;

  }
}