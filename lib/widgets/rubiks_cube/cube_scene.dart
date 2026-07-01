import 'package:flutter/material.dart';

import 'cube_controller.dart';
import 'cubie_widget.dart';

class CubeScene extends StatelessWidget {
  final CubeController controller;

  const CubeScene({
    super.key,
    required this.controller,
  });

  static const double cubieSize = 46;
  static const double cubieGap = 4;
  static const double spacing = cubieSize + cubieGap;
  static const double origin = 38;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        children: controller.cubies.map((cubie) {
          return Positioned(
            left: origin + (cubie.x + 1) * spacing,
            top: origin + (1 - cubie.y) * spacing,
            child: CubieWidget(
              data: cubie,
            ),
          );
        }).toList(),
      ),
    );
  }
}