import 'package:flutter/material.dart';
import '../models/cube/cube_color.dart';

class ColorCalibration {
  final Map<CubeColor, HSVColor> _references = {};

  bool get isComplete => _references.length == 6;

  void setReference(
  CubeColor face,
  Color color,
) {
  _references[face] = HSVColor.fromColor(color);
}

  HSVColor? reference(CubeColor face) {
  return _references[face];
}
  void clear() {
    _references.clear();
  }

  Map<CubeColor, HSVColor> get references => _references;
}