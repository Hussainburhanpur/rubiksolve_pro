import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';

class CubeView extends StatelessWidget {
  const CubeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Cube(
      onSceneCreated: (Scene scene) {
        scene.world.add(
          Object(
            scale: Vector3(5.0, 5.0, 5.0),
            fileName: 'assets/cube/cube.obj',
          ),
        );

        scene.camera.zoom = 10;
      },
    );
  }
}