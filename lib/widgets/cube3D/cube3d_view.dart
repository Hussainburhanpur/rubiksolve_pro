import 'dart:async';

import 'package:flutter/material.dart';

import 'camera.dart';
import 'cube3d.dart';
import 'cube_renderer.dart';

class Cube3DView extends StatefulWidget {
  final String? initialCubeString;

  const Cube3DView({
    super.key,
    this.initialCubeString,
  });

  @override
  State<Cube3DView> createState() => Cube3DViewState();
}

class Cube3DViewState extends State<Cube3DView> {
  late Cube3D cube;

  Cube3D get cubeModel => cube;

  final Camera camera = Camera();

  @override
  void initState() {
    super.initState();

    cube = Cube3D(
      cubeString: widget.initialCubeString,
    );
  }

  
Future<void> animateMove(String move) async {
  if (cube.isAnimating) return;

  final normalized = move.trim().toUpperCase();
  if (normalized.isEmpty) return;

  cube.startAnimation(normalized);

  const frameDuration = Duration(milliseconds: 16);

  // Target duration based on the original app's
  // previously extracted 1.5-second move setting.
  const totalDuration = Duration(milliseconds: 1500);

  final startTime = DateTime.now();

  while (mounted && cube.isAnimating) {
    final elapsed = DateTime.now().difference(startTime);

    final progress = (
      elapsed.inMilliseconds / totalDuration.inMilliseconds
    ).clamp(0.0, 1.0);

    // Smooth acceleration and deceleration.
    final easedProgress =
        Curves.easeInOutCubic.transform(progress);

    setState(() {
      cube.updateAnimation(easedProgress);
    });

    if (progress >= 1.0) break;

    await Future.delayed(frameDuration);
  }

  if (!mounted) return;

  setState(() {
    cube.finishAnimation();
  });
}


  void applyMove(String move) {
    setState(() {
      cube.applyMove(move);
    });
  }

  Future<void> animateCameraTo({
  required double targetYaw,
  required double targetPitch,
  Duration duration = const Duration(milliseconds: 900),
}) async {
  final startYaw = camera.yaw;
  final startPitch = camera.pitch;

  final startTime = DateTime.now();

  while (mounted) {
    final elapsed =
        DateTime.now().difference(startTime);

    double progress =
        elapsed.inMilliseconds /
        duration.inMilliseconds;

    if (progress >= 1.0) {
      progress = 1.0;
    }

    // Smooth ease-in/ease-out.
    final eased =
        progress * progress * (3.0 - 2.0 * progress);

    final newYaw =
        startYaw +
        (targetYaw - startYaw) * eased;

    final newPitch =
        startPitch +
        (targetPitch - startPitch) * eased;

    setState(() {
      camera.setOrientation(
        targetYaw: newYaw,
        targetPitch: newPitch,
      );
    });

    if (progress >= 1.0) {
      break;
    }

    await Future.delayed(
      const Duration(milliseconds: 16),
    );
  }
}

  void resetCube() {
    setState(() {
      cube = Cube3D(
        cubeString: widget.initialCubeString,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          camera.rotate(
            details.delta.dx * 0.01,
            details.delta.dy * 0.01,
          );
        });
      },
      child: CustomPaint(
        painter: CubeRenderer(
          cube,
          camera,
        ),
        size: Size.infinite,
      ),
    );
  }
}