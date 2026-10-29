import 'dart:async';
import 'dart:math' as math;
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

  final List<String> _commandQueue = [];

  bool _processingQueue = false;
  bool _playRequested = false;
  bool _showOrientationHint = true;


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


Future<void> _resetCameraView() async {
  await cubeKey.currentState?.animateCameraTo(
    targetYaw: -0.6,
    targetPitch: 0.55,
    duration: const Duration(milliseconds: 500),
  );
}
  

Future<void> _updateOrientationForMove(String move) async {
  // Keep the camera at the user's chosen viewing angle.
  // Face-turn animations will continue normally.
}



  
Widget _buildDirectionArrow(String move) {
  final normalizedMove = move.trim().toUpperCase();
  final isPrime = normalizedMove.endsWith("'");
  final face = normalizedMove[0];

  final faceNames = {
    'R': 'RIGHT',
    'L': 'LEFT',
    'U': 'TOP',
    'D': 'BOTTOM',
    'F': 'FRONT',
    'B': 'BACK',
  };

  final faceName = faceNames[face] ?? face;

  final direction = isPrime
      ? 'COUNTERCLOCKWISE'
      : 'CLOCKWISE';

  final directionSymbol = isPrime ? '↶' : '↷';

  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 10,
    ),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.78),
      borderRadius: BorderRadius.circular(24),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          normalizedMove,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          directionSymbol,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              faceName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              direction,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}



Future<void> _waitForAnimationToFinish() async {
  while (cubeKey.currentState?.cubeModel.isAnimating ?? false) {
    await Future.delayed(
      const Duration(milliseconds: 20),
    );

    if (!mounted) return;
  }
}

Future<void> _processQueue() async {
  if (_processingQueue) return;

  _processingQueue = true;

  try {
    while (mounted) {
      await _waitForAnimationToFinish();

      if (!mounted) return;

      // Process manual commands in the exact order tapped.
      if (_commandQueue.isNotEmpty) {
        final command = _commandQueue.removeAt(0);

        if (command == 'next') {
          if (!controller.canGoNext) continue;

          final move = controller.nextMove;
          final cube = cubeKey.currentState;

          if (move == null || cube == null) continue;

          // Update the step number and move label FIRST.
          controller.markNextApplied();
          if (mounted) setState(() {});

          await _updateOrientationForMove(move);
          await cube.animateMove(move);
        
          continue;
        }

        if (command == 'previous') {
          if (!controller.canGoPrevious) continue;

          final move = controller.previousMove;
          final cube = cubeKey.currentState;

          if (move == null || cube == null) continue;

          // Update the step and move label as the reverse animation starts.
          controller.markPreviousApplied();
          if (mounted) setState(() {});

          await cube.animateMove(_reverseMove(move));
          if (!mounted) return;
          continue;
        }
      }

      // Automatic playback runs only after manual commands are drained.
      if (_playRequested && controller.canGoNext) {
        final move = controller.nextMove;
        final cube = cubeKey.currentState;

        if (move == null || cube == null) {
          _playRequested = false;
          controller.stopPlaying();
          continue;
        }

        // Update the displayed step before animating.
        controller.markNextApplied();
        if (mounted) setState(() {});

        await cube.animateMove(move);
        if (!mounted) return;
        continue;
      }

      if (!controller.canGoNext) {
        _playRequested = false;
        controller.stopPlaying();
      }

      break;
    }
  } finally {
    _processingQueue = false;

    if (mounted) {
      setState(() {});
    }

    // Handle any command that arrived as processing was ending.
    if (mounted && (_commandQueue.isNotEmpty || _playRequested)) {
      _processQueue();
    }
  }
}

void _queueNext() {
  _commandQueue.add('next');
  _processQueue();
}

void _queuePrevious() {
  // Previous pauses automatic playback, but does not discard queued taps.
  _playRequested = false;
  controller.stopPlaying();

  _commandQueue.add('previous');
  _processQueue();
}

void _togglePlayPause() {
  if (_playRequested) {
    _playRequested = false;
    controller.stopPlaying();

    if (mounted) setState(() {});
    return;
  }

  if (!controller.canGoNext && _commandQueue.isEmpty) return;

  _playRequested = true;
  controller.startPlaying();

  _processQueue();

  if (mounted) setState(() {});
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
  if (_showOrientationHint) ...[
    Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Hold your physical cube in the same orientation as shown on the screen.',
            ),
          ),
          IconButton(
            tooltip: 'Dismiss orientation hint',
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.close),
            onPressed: () {
              setState(() {
                _showOrientationHint = false;
              });
            },
          ),
        ],
      ),
    ),
    const SizedBox(height: 12),
  ] else
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

                  Positioned(
                    top: 8,
                    right: 8,
                    child: Material(
                      color: Colors.black.withValues(alpha: 0.65),
                      shape: const CircleBorder(),
                      child: IconButton(
                        tooltip: 'Reset cube view',
                        icon: const Icon(
                          Icons.threed_rotation,
                          color: Colors.white,
                        ),
                        onPressed: _resetCameraView,
                      ),
                    ),
                  ),

                  if (hasMoves)
                    Positioned(
                      top: 10,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: _buildDirectionArrow(displayedMove),
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