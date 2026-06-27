import 'package:flutter/material.dart';

class ScanSession {
  final List<List<Color>> faces = [];

  void addFace(List<Color> colors) {
    if (colors.length != 9) return;
    faces.add(List.from(colors));
  }

  bool get isComplete => faces.length == 6;

  void reset() {
    faces.clear();
  }
}