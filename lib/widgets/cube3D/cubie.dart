import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

class Cubie {
  Vector3 position;

  Vector3 rotation;

  final Map<String, Color> stickers;

  Cubie({
    required this.position,
    required this.stickers,
  }) : rotation = Vector3.zero();

  Cubie copy() {
    return Cubie(
      position: position.clone(),
      stickers: Map<String, Color>.from(stickers),
    )..rotation = rotation.clone();
  }
}