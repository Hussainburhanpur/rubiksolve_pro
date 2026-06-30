import 'package:flutter/material.dart';

class ColorCalibration {
  final Map<String, Color> _references = {};

  bool get isComplete => _references.length == 6;

  void setReference(String face, Color color) {
    _references[face] = color;
  }

  Color? reference(String face) => _references[face];

  void clear() {
    _references.clear();
  }

  Map<String, Color> get references => _references;
}