import 'dart:async';

import 'package:flutter/material.dart';

import 'playback_controller.dart';
import '../../widgets/cube3D/cube3d_view.dart';

class PlaybackScreen extends StatefulWidget {
  final List<String> moves;
  final String? initialCubeString;

  const PlaybackScreen({
    super.key,
    this.moves = const [],
    this.initialCubeString,
  });

  @override
  State<PlaybackScreen> createState() => _PlaybackScreenState();
}

class _PlaybackScreenState extends State<PlaybackScreen> {
  late PlaybackController controller;

  final GlobalKey<Cube3DViewState> cubeKey =
      GlobalKey<Cube3DViewState>();

  String currentFrontFace = 'F';

  final List<String> _nextQueue = [];
  int _previousQueue = 0;

  bool _processingQueue = false;
  bool _nextMoveInProgress = false;
  bool _playRequested = false;

  @override
  void initState() {
    super.initState();

    controller = PlaybackController(
      moves: widget.moves,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String _reverseMove(String move) {
    if (move.endsWith('2')) {
      return move;
    }

    if (move.endsWith("'")) {
      return move.substring(0, move.length - 1);
    }

    return "$move'";
  }

  String _targetFaceForMove(String move) {
    switch (move[0]) {
      case 'U':
        return 'U';
      case 'R':
        return 'R';
      case 'F':
        return 'F';
      case 'D':
        return 'D';
      case 'L':
        return 'L';
      case 'B':
        return 'B';
      default:
        return 'F';
    }
  }

  String _faceInstruction(String face) {
    switch (face) {
      case 'F':
        return 'F is already in front';

      case 'R':
        return 'Turn cube right';

      case 'L':
        return 'Turn cube left';

      case 'U':
        return 'Tilt cube forward';

      case 'D':
        return 'Tilt cube backward';

      case 'B':
        return 'Turn cube 180°';

      default:
        return '';
    }
  }

  void _setCurrentFrontFace(String face) {
    if (face == 'U' ||
        face == 'R' ||
        face == 'F' ||
        face == 'D' ||
        face == 'L' ||
        face == 'B') {
      currentFrontFace = face;
    }
  }

  List<String> _orientationPath(String targetFace) {
    if (currentFrontFace == targetFace) {
      return [targetFace];
    }

    if (currentFrontFace == 'F') {
      return [targetFace];
    }

    return ['F', targetFace];
  }

  Future<void> _updateOrientationForMove(String move) async {
  final targetFace = _targetFaceForMove(move);

  if (currentFrontFace == targetFace) {
    return;
  }

  switch (targetFace) {
  case 'U':
  // First return to the normal F-front orientation.
  await cubeKey.currentState?.animateCameraTo(
    targetYaw: 0.0,
    targetPitch: 0.45,
    duration: const Duration(milliseconds: 700),
  );

  // Then tilt upward so U becomes the working face.
  await cubeKey.currentState?.animateCameraTo(
    targetYaw: 0.0,
    targetPitch: 1.0,
    duration: const Duration(milliseconds: 900),
  );
  break;

    case 'B':
  // First return to the normal F-front orientation.
  await cubeKey.currentState?.animateCameraTo(
    targetYaw: 0.0,
    targetPitch: 0.45,
    duration: const Duration(milliseconds: 700),
  );

  // Then turn the cube 180° so B becomes the front face.
  await cubeKey.currentState?.animateCameraTo(
    targetYaw: 3.1415926535,
    targetPitch: 0.45,
    duration: const Duration(milliseconds: 1200),
  );
  break;

  case 'D':
  // First return to the normal F-front orientation.
  await cubeKey.currentState?.animateCameraTo(
    targetYaw: 0.0,
    targetPitch: 0.45,
    duration: const Duration(milliseconds: 700),
  );

  // Then tilt downward so D becomes the working face.
  await cubeKey.currentState?.animateCameraTo(
    targetYaw: 0.0,
    targetPitch: -1.0,
    duration: const Duration(milliseconds: 900),
  );
  break;

  case 'L':
  // First return to the normal F-front orientation.
  await cubeKey.currentState?.animateCameraTo(
    targetYaw: 0.0,
    targetPitch: 0.45,
    duration: const Duration(milliseconds: 700),
  );

  // Then turn left so L becomes the working face.
  await cubeKey.currentState?.animateCameraTo(
    targetYaw: 1.57,
    targetPitch: 0.45,
    duration: const Duration(milliseconds: 900),
  );
  break;

  case 'R':
  // First return to the normal F-front orientation.
  await cubeKey.currentState?.animateCameraTo(
    targetYaw: 0.0,
    targetPitch: 0.45,
    duration: const Duration(milliseconds: 700),
  );

  // Then turn left so R becomes the working face.
  await cubeKey.currentState?.animateCameraTo(
    targetYaw: -1.57,
    targetPitch: 0.45,
    duration: const Duration(milliseconds: 900),
  );
  break;

  case 'F':
  // Return to the normal F-front orientation.
  await cubeKey.currentState?.animateCameraTo(
    targetYaw: 0.0,
    targetPitch: 0.45,
    duration: const Duration(milliseconds: 900),
  );
  break;

  default:
    return;
}

  currentFrontFace = targetFace;
}

  Widget _buildDirectionArrow(String move) {
    final targetFace = _targetFaceForMove(move);
    final instruction = _faceInstruction(targetFace);

    final bool isRight = targetFace == 'R';
    final bool isLeft = targetFace == 'L';
    final bool isUp = targetFace == 'U';
    final bool isDown = targetFace == 'D';
    final bool isBack = targetFace == 'B';

    return TweenAnimationBuilder<double>(
      key: ValueKey(
        '${controller.currentIndex}-$move',
      ),
      tween: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      builder: (context, progress, child) {
        final double movement =
            progress <= 0.5
                ? progress * 2.0
                : (1.0 - progress) * 2.0;

        Widget arrow;

        if (isRight) {
          arrow = Transform.translate(
            offset: Offset(
              18.0 * movement,
              0,
            ),
            child: const Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 32,
            ),
          );
        } else if (isLeft) {
          arrow = Transform.translate(
            offset: Offset(
              -18.0 * movement,
              0,
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 32,
            ),
          );
        } else if (isUp) {
          arrow = Transform.translate(
            offset: Offset(
              0,
              18.0 * movement,
            ),
            child: const Icon(
              Icons.arrow_downward,
              color: Colors.white,
              size: 32,
            ),
          );
        } else if (isDown) {
          arrow = Transform.translate(
            offset: Offset(
              0,
              -18.0 * movement,
            ),
            child: const Icon(
              Icons.arrow_upward,
              color: Colors.white,
              size: 32,
            ),
          );
        } else if (isBack) {
          arrow = Transform.rotate(
            angle: 2 * 3.1415926535 * progress,
            child: const Icon(
              Icons.threesixty,
              color: Colors.white,
              size: 32,
            ),
          );
        } else {
          arrow = const Icon(
            Icons.check_circle_outline,
            color: Colors.white,
            size: 30,
          );
        }

        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.72),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              arrow,
              const SizedBox(width: 10),
              Text(
                instruction,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _waitForAnimationToFinish() async {
    while (
        cubeKey.currentState?.cubeModel.isAnimating ?? false) {
      await Future.delayed(
        const Duration(milliseconds: 20),
      );

      if (!mounted) {
        return;
      }
    }
  }

  Future<void> _processQueue() async {
    if (_processingQueue) {
      return;
    }

    _processingQueue = true;

    try {
      while (mounted) {
        await _waitForAnimationToFinish();

        if (!mounted) {
          return;
        }

        if (_previousQueue > 0 &&
    !controller.canGoPrevious) {
  _previousQueue = 0;
}

        // Previous has priority over Next if both are queued.
        if (_previousQueue > 0 &&
            controller.canGoPrevious) {
          _previousQueue--;

          final move = controller.previousMove;

          if (move == null) {
            continue;
          }

          final reverseMove = _reverseMove(move);

// First reverse the current move while staying on its face.
await cubeKey.currentState
    ?.animateMove(reverseMove);

// Now move playback back to the destination step.
controller.markPreviousApplied();

final destinationMove = controller.currentMove;

if (mounted) {
  setState(() {});
}

// Then orient the camera to the destination step.
await _updateOrientationForMove(destinationMove);

          continue;
        }

        if (_nextQueue.isNotEmpty) {
  final move = _nextQueue.removeAt(0);

  _nextMoveInProgress = true;

  // Update the solution name and step FIRST.
  controller.markNextApplied();

  if (mounted) {
    setState(() {});
  }

  // Then orient the camera.
  await _updateOrientationForMove(move);

  // Finally perform the cube animation.
  await cubeKey.currentState?.animateMove(move);

  _nextMoveInProgress = false;

  continue;
}

        if (_playRequested &&
            controller.canGoNext) {
          final move = controller.nextMove;

          if (move == null) {
            _playRequested = false;
            controller.stopPlaying();
            continue;
          }

          controller.markNextApplied();

if (mounted) {
  setState(() {});
}

await _updateOrientationForMove(move);

await cubeKey.currentState
    ?.animateMove(move);

          continue;
        }

        break;
      }
    } finally {
      _processingQueue = false;

      if (!controller.canGoNext) {
        _playRequested = false;
        controller.stopPlaying();
      }

      if (mounted) {
        setState(() {});
      }
    }
  }

  void _queueNext() {
  if (!controller.canGoNext) {
    return;
  }

  final queuedIndex =
    controller.currentIndex + _nextQueue.length;

  if (queuedIndex >= controller.totalMoves) {
    return;
  }

  final nextMove = controller.moves[queuedIndex];

  _nextQueue.add(nextMove);

  _processQueue();
}

void _queuePrevious() {
  if (!controller.canGoPrevious) {
    return;
  }

  // Cancel all automatic/queued forward movement.
  _playRequested = false;
  controller.stopPlaying();
  _nextQueue.clear();

  _previousQueue++;

  _processQueue();

  if (mounted) {
    setState(() {});
  }
}

  void _togglePlayPause() {
    if (_playRequested) {
      _playRequested = false;
      controller.stopPlaying();

      if (mounted) {
        setState(() {});
      }

      return;
    }

    if (!controller.canGoNext) {
      return;
    }

    _playRequested = true;
    controller.startPlaying();

    _processQueue();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasMoves = controller.moves.isNotEmpty;

    final String displayedMove = controller.currentMove;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Solution Playback",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            Expanded(
              flex: 5,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Cube3DView(
                    key: cubeKey,
                    initialCubeString:
                        widget.initialCubeString,
                  ),

                  if (hasMoves)
                    Positioned(
                      top: 10,
                      child: _buildDirectionArrow(
                        displayedMove,
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text(
              hasMoves
                  ? displayedMove
                  : "Solution Animation",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              hasMoves
                  ? "Step ${controller.currentIndex} / ${controller.totalMoves}"
                  : "No solution loaded",
              style: const TextStyle(
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  iconSize: 42,
                  onPressed: hasMoves
                      ? _queuePrevious
                      : null,
                  icon: const Icon(
                    Icons.skip_previous,
                  ),
                ),

                IconButton(
                  iconSize: 52,
                  onPressed: hasMoves
                      ? _togglePlayPause
                      : null,
                  icon: Icon(
                    _playRequested
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
                ),

                IconButton(
                  iconSize: 42,
                  onPressed: hasMoves
                      ? _queueNext
                      : null,
                  icon: const Icon(
                    Icons.skip_next,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}