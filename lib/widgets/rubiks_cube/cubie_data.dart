import 'package:flutter/material.dart';

class CubieData {
  final int x;
  final int y;
  final int z;

  Color? front;
  Color? back;
  Color? left;
  Color? right;
  Color? top;
  Color? bottom;

  CubieData({
    required this.x,
    required this.y,
    required this.z,
    this.front,
    this.back,
    this.left,
    this.right,
    this.top,
    this.bottom,
  });
}