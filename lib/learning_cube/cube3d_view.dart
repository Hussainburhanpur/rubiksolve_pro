import 'dart:async';

import 'package:flutter/material.dart';

import 'camera.dart';
import 'cube3d.dart';
import 'cube_renderer.dart';

class LearningCube3DView extends StatefulWidget {
  final String? initialCubeString;
  final bool yellowTop;

  const LearningCube3DView({
    super.key,
    this.initialCubeString,
    this.yellowTop = false,
  });

  @override
  State<LearningCube3DView> createState() => LearningCube3DViewState();
}

class LearningCube3DViewState extends State<LearningCube3DView> {
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

  // A "2" move is one solution step, but visually
  // consists of two separate 90° rotations.
  if (normalized.endsWith('2')) {
    final quarterMove = normalized[0];

    // First 90° rotation.
    cube.startAnimation(quarterMove);

    const frameDuration = Duration(milliseconds: 16);
    const totalDuration = Duration(milliseconds: 360);

    final start1 = DateTime.now();

    while (mounted && cube.isAnimating) {
      final elapsed = DateTime.now().difference(start1);

      double progress =
          elapsed.inMilliseconds /
          totalDuration.inMilliseconds;

      if (progress >= 1.0) {
        progress = 1.0;
      }

      setState(() {
        cube.updateAnimation(progress);
      });

      if (progress >= 1.0) {
        break;
      }

      await Future.delayed(frameDuration);
    }

    if (!mounted) return;

    setState(() {
      cube.finishAnimation();
    });

    // Very short pause between the two quarter-turns.
    await Future.delayed(
      const Duration(milliseconds: 80),
    );

    if (!mounted) return;

    // Second 90° rotation.
    cube.startAnimation(quarterMove);

    final start2 = DateTime.now();

    while (mounted && cube.isAnimating) {
      final elapsed = DateTime.now().difference(start2);

      double progress =
          elapsed.inMilliseconds /
          totalDuration.inMilliseconds;

      if (progress >= 1.0) {
        progress = 1.0;
      }

      setState(() {
        cube.updateAnimation(progress);
      });

      if (progress >= 1.0) {
        break;
      }

      await Future.delayed(frameDuration);
    }

    if (!mounted) return;

    // finishAnimation() applies the quarter move logically.
    // The two calls together therefore produce the required 180°.
    setState(() {
      cube.finishAnimation();
    });

    return;
  }

  // Normal 90° / prime move.
  cube.startAnimation(normalized);

  const frameDuration = Duration(milliseconds: 16);
  const totalDuration = Duration(milliseconds: 360);

  final start = DateTime.now();

  while (mounted && cube.isAnimating) {
    final elapsed = DateTime.now().difference(start);

    double progress =
        elapsed.inMilliseconds /
        totalDuration.inMilliseconds;

    if (progress >= 1.0) {
      progress = 1.0;
    }

    setState(() {
      cube.updateAnimation(progress);
    });

    if (progress >= 1.0) {
      break;
    }

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
            -details.delta.dy * 0.01,
          );
        });
      },
      child: CustomPaint(
        
        painter: CubeRenderer(
          cube,
          camera,
          yellowTop: widget.yellowTop,
        ),

        size: Size.infinite,
      ),
    );
  }
}