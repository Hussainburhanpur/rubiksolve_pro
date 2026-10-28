import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

import 'face3d.dart';

class Mesh {
  final List<Face3D> faces;

  Mesh(this.faces);

  factory Mesh.cube({
    required double size,
    required Map<String, Color> stickers,
  }) {
    final s = size / 2;

    final p000 = Vector3(-s, -s, -s);
    final p001 = Vector3(-s, -s,  s);
    final p010 = Vector3(-s,  s, -s);
    final p011 = Vector3(-s,  s,  s);

    final p100 = Vector3( s, -s, -s);
    final p101 = Vector3( s, -s,  s);
    final p110 = Vector3( s,  s, -s);
    final p111 = Vector3( s,  s,  s);

    return Mesh([
      if (stickers.containsKey("F"))
        Face3D(
          color: stickers["F"]!,
          vertices: [p001, p101, p111, p011],
        ),

      if (stickers.containsKey("B"))
        Face3D(
          color: stickers["B"]!,
          vertices: [p100, p000, p010, p110],
        ),

      if (stickers.containsKey("U"))
        Face3D(
          color: stickers["U"]!,
          vertices: [p011, p111, p110, p010],
        ),

      if (stickers.containsKey("D"))
        Face3D(
          color: stickers["D"]!,
          vertices: [p000, p100, p101, p001],
        ),

      if (stickers.containsKey("L"))
        Face3D(
          color: stickers["L"]!,
          vertices: [p000, p001, p011, p010],
        ),

      if (stickers.containsKey("R"))
        Face3D(
          color: stickers["R"]!,
          vertices: [p101, p100, p110, p111],
        ),
    ]);
  }
}