import 'package:flutter/material.dart';

/// Requires several consecutive frames to agree before a face can be captured.
/// Small per-channel camera noise is tolerated; returned colors are the mean
/// of the accepted frames.
class StabilityFilter {
  final List<List<Color>> _history = [];

  static const int requiredFrames = 8;
  static const int channelTolerance = 18;

  List<Color>? add(List<Color> colors) {
    if (colors.length != 9) return null;

    if (_history.isNotEmpty && !_matches(_history.last, colors)) {
      // Start a new run when the observed face changes or becomes unstable.
      _history.clear();
    }

    _history.add(List<Color>.from(colors));
    if (_history.length > requiredFrames) {
      _history.removeAt(0);
    }

    if (_history.length < requiredFrames) return null;

    final stable = <Color>[];
    for (var i = 0; i < 9; i++) {
      var r = 0;
      var g = 0;
      var b = 0;

      for (final frame in _history) {
        r += frame[i].red;
        g += frame[i].green;
        b += frame[i].blue;
      }

      stable.add(Color.fromARGB(
        255,
        (r / requiredFrames).round(),
        (g / requiredFrames).round(),
        (b / requiredFrames).round(),
      ));
    }

    return stable;
  }

  bool _matches(List<Color> a, List<Color> b) {
    if (a.length != b.length) return false;

    for (var i = 0; i < a.length; i++) {
      if ((a[i].red - b[i].red).abs() > channelTolerance ||
          (a[i].green - b[i].green).abs() > channelTolerance ||
          (a[i].blue - b[i].blue).abs() > channelTolerance) {
        return false;
      }
    }
    return true;
  }

  void reset() => _history.clear();
}
