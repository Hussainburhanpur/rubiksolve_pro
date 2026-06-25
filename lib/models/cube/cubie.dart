import 'package:flutter/material.dart';

import 'cube_face.dart';

class Cubie {
  final int x;
  final int y;
  final int z;

  final Map<CubeFace, Color> stickers;

  Cubie({
    required this.x,
    required this.y,
    required this.z,
    required this.stickers,
  });

  bool hasFace(CubeFace face) => stickers.containsKey(face);

  Color? getColor(CubeFace face) => stickers[face];

  Cubie copyWith({
    int? x,
    int? y,
    int? z,
    Map<CubeFace, Color>? stickers,
  }) {
    return Cubie(
      x: x ?? this.x,
      y: y ?? this.y,
      z: z ?? this.z,
      stickers: stickers ?? Map.from(this.stickers),
    );
  }

  @override
  String toString() {
    return 'Cubie(x: $x, y: $y, z: $z)';
  }
}