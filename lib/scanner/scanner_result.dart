import 'package:flutter/material.dart';

class ScannerResult {
  const ScannerResult({
    required this.colors,
    required this.timestamp,
  });

  final List<Color> colors;
  final DateTime timestamp;
}