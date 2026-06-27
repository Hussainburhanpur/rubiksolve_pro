import 'package:flutter/material.dart';

class StabilityFilter {
  final List<List<Color>> _history = [];

  static const int requiredFrames = 8;

  List<Color>? add(List<Color> colors) {
    if (colors.length != 9) return null;

    _history.add(List.from(colors));

    if (_history.length > requiredFrames) {
      _history.removeAt(0);
    }

    if (_history.length < requiredFrames) {
      return null;
    }

    final result = <Color>[];

    for (int i = 0; i < 9; i++) {
      final first = _history.first[i];

      bool stable = true;

      for (final frame in _history) {
        if (frame[i] != first) {
          stable = false;
          break;
        }
      }

      if (!stable) {
        return null;
      }

      result.add(first);
    }

    return result;
  }

  void reset() {
    _history.clear();
  }
}