import 'package:flutter/material.dart';
import 'cube_scene.dart';
import 'cube_controller.dart';
import 'cubie_widget.dart';

class CubeWidget extends StatefulWidget {
  const CubeWidget({super.key});

  @override
  State<CubeWidget> createState() => _CubeWidgetState();
}

class _CubeWidgetState extends State<CubeWidget> {
  final CubeController controller = CubeController();


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        controller.rotate(
          details.delta.dx * 0.01,
          details.delta.dy * 0.01,
        );

        setState(() {});
      },
      child: Center(
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0015)
            ..rotateX(controller.rotationX)
            ..rotateY(controller.rotationY),
          child: CubeScene(
  controller: controller,
),
        ),
      ),
    );
  }
}