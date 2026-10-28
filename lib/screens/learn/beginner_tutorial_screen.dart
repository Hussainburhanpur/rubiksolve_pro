import 'package:flutter/material.dart';

import '../../learning_cube/cube3d_view.dart';

class BeginnerTutorialScreen extends StatefulWidget {
  const BeginnerTutorialScreen({super.key});

  @override
  State<BeginnerTutorialScreen> createState() =>
      _BeginnerTutorialScreenState();
}

class _BeginnerTutorialScreenState
    extends State<BeginnerTutorialScreen> {
  final GlobalKey<LearningCube3DViewState> cubeKey =
      GlobalKey<LearningCube3DViewState>();

  int currentStep = 0;
  bool isPlaying = false;

  // Step-by-step practice state is local to this screen. The shared 3D
  // engine and Playback module are intentionally left unchanged.
  bool _casePrepared = false;
  bool _isStepping = false;
  int _nextMoveIndex = 0;
  int _selectedDemoIndex = 0;
  List<String> _stepMoves = const [];
  String? _practiceStatus;

  final List<_BeginnerStep> steps = const [
    // ------------------------------------------------------------
    // STEP 1
    // ------------------------------------------------------------
    _BeginnerStep(
      title: 'Before You Start',
      description:
          'Learn the correct cube orientation before following any instructions.',
      hold:
          'WHITE on top and GREEN facing you. Keep this orientation unless a step tells you to flip the cube.',
      tip:
          'The center pieces are your colour compass. Always match pieces to the center colours.',
      learningPoints: [
        'WHITE center = Up (U)',
        'GREEN center = Front (F)',
        'RED center = Right (R)',
        'ORANGE center = Left (L)',
        'YELLOW center = Down (D)',
        'BLUE center = Back (B)',
        'Center pieces define the six faces.',
        'Edge pieces have two colours.',
        'Corner pieces have three colours.',
      ],
    ),

    // ------------------------------------------------------------
    // STEP 2
    // ------------------------------------------------------------
    _BeginnerStep(
      title: 'Cube Notation',
      description:
          'Cube algorithms are written using six face letters and a few simple symbols.',
      hold:
          'When reading an algorithm, imagine you are looking directly at the face being turned.',
      tip:
          'Read clockwise or counter-clockwise while looking directly at the face being turned. A prime (′) reverses the direction; 2 means a 180° turn.',
      learningPoints: [
        'R = Right face',
        'L = Left face',
        'U = Up face',
        'D = Down face',
        'F = Front face',
        'B = Back face',
        "R' = Right face counter-clockwise",
        'R2 = Right face 180°',
        "U' = Up face counter-clockwise",
        'U2 = Up face 180°',
      ],
    ),

    // ------------------------------------------------------------
    // STEP 3
    // ------------------------------------------------------------
    _BeginnerStep(
      title: 'White Cross',
      description:
          'Build a white cross around the WHITE center. Every white edge must also match the center on its other colour.',
      hold:
    'Keep WHITE on top and GREEN facing you. Work on one white edge at a time.',
      tip:
          'The white cross is an intuitive stage, not a fixed algorithm. A scripted sequence can only demonstrate one specific case and may mislead you when your cube differs.',
      learningPoints: [
        'Find one edge piece containing WHITE.',
        'Identify its other colour and find that colour’s center.',
        'Move the edge so its non-white sticker lines up with that center.',
        'Turn the matching face to bring the white sticker onto the WHITE face.',
        'Repeat for the remaining three white edges, protecting edges already placed.',
        'Checkpoint: the WHITE face has a plus sign, and each of its four side stickers matches its side center.',
      ],
      demos: [
        _Demo(
          name: 'Restore the White Cross',
          moves: [
            'F2',
          ],
          explanation:
              'This specific practice case starts with one white edge displaced. F2 returns that edge to the WHITE face. The bottom layer remains turned, so you can check the white cross without the whole cube being solved.',
        ),
      ],
    ),

    // ------------------------------------------------------------
    // STEP 4
    // ------------------------------------------------------------
    _BeginnerStep(
      title: 'White Corners',
      description:
          'Complete the first layer by inserting the four white corner pieces.',
      hold:
    'Keep WHITE on top and GREEN facing you. Place the target white corner at the bottom-front-right position, directly below its destination.',
      tip:
          "Repeat R U R' U' until the white corner is correctly inserted. Keep WHITE on top.",
      learningPoints: [
        'Find a corner containing WHITE.',
        'Identify the two side colours of that corner.',
        'Use the two matching centers to find its destination.',
        'Place the corner directly below that destination.',
        "Hold it at bottom-front-right.",
        "Repeat R U R' U' until it enters correctly.",
        'Do not stop halfway through the sequence.',
        'Repeat for all four white corners.',
      ],
      demos: [
        _Demo(
          name: 'White Corner Trigger',
          moves: [
            'R',
            'U',
            "R'",
            "U'",
          ],
          explanation:
              "Repeat R U R' U' until the white corner reaches its correct position.",
        ),
      ],
    ),

    // ------------------------------------------------------------
    // STEP 5
    // ------------------------------------------------------------
    _BeginnerStep(
      title: 'Middle Layer',
      description:
          'Solve the four middle-layer edges after the entire white layer is complete.',
      hold:
    'Keep WHITE on top and GREEN facing you. Turn the cube only when needed to bring the target edge to the front.',
      tip:
          'Find an edge without WHITE or YELLOW in the bottom layer. Match its front colour with the front center, then use the right- or left-insertion case to move it into the middle layer.',
      learningPoints: [
        'Keep WHITE on top and YELLOW on the bottom.',
        'Find an edge piece without WHITE or YELLOW in the bottom layer.',
        'Turn D to bring the edge below the center matching its front colour.',
        'Choose the right or left insertion case based on the edge destination.',
        'Check that the white layer stays solved.',
      ],
      demos: [
        _Demo(
          name: 'Middle Edge → Right',
          moves: [
            "D'",
            "R'",
            'D',
            'R',
            'D',
            'F',
            "D'",
            "F'",
          ],
          explanation:
              'Moves the matched edge into the middle layer on the right.',
        ),
        _Demo(
          name: 'Middle Edge → Left',
          moves: [
            'D',
            'L',
            "D'",
            "L'",
            "D'",
            "F'",
            'D',
            'F',
          ],
          explanation:
              'Moves the matched edge into the middle layer on the left.',
        ),
      ],
    ),

    // ------------------------------------------------------------
    // STEP 6
    // ------------------------------------------------------------
    _BeginnerStep(
      title: 'Yellow Cross',
      description:
          'Create a yellow cross on the bottom face. Ignore the yellow corners for now.',
      hold:
    'Keep YELLOW on top and GREEN facing you. Identify the yellow edge pattern before applying the algorithm.',
      tip:
          'You may see a dot, an L, or a line. Hold the pattern correctly and repeat the algorithm until you have a cross.',
      learningPoints: [
        'Only the four yellow edges matter here.',
        'Do not worry about yellow corners yet.',
        'A dot can become an L or line.',
        'An L can become a line or cross.',
        'For this orientation, inspect the yellow pattern on the bottom face.',
        'The goal is a complete yellow cross.',
      ],
      demos: [
        _Demo(
          name: 'Yellow Cross',
          moves: [
            "F'",
            "R'",
            "D'",
            'R',
            'D',
            'F',
          ],
          explanation:
              "F' R' D' R D F changes the yellow edges on the bottom. Check the pattern and repeat if needed.",
        ),
      ],
    ),

    // ------------------------------------------------------------
    // STEP 7
    // ------------------------------------------------------------
    _BeginnerStep(
      title: 'Position Yellow Edges',
      description:
          'The yellow cross exists, but the side colours may not match their centers. Now position those four yellow edges.',
      hold:
    'Keep YELLOW on top and GREEN facing you. Rotate the top layer to inspect which side colours match their centers.',
      tip:
          'Find two neighbouring yellow-cross edges whose side colours match their centers. Put the matching pair at the BACK and RIGHT, then run the algorithm.',
      learningPoints: [
        'Keep the yellow cross intact.',
        'Check the side colour of each yellow edge.',
        'Two neighbouring edges should be matched when possible.',
        'Put the matching pair at BACK and RIGHT.',
        'Run the algorithm once.',
        'Turn only D and check the side colours again.',
        'If the edges are still not all matched, repeat the process.',
      ],
      demos: [
        _Demo(
          name: 'Yellow Edge Positioning',
          moves: [
            "R'",
            "D'",
            'R',
            "D'",
            "R'",
            'D2',
            'R',
            "D'",
          ],
          explanation:
              'Cycles the yellow-cross edges so their side colours can be aligned with the centers.',
        ),
      ],
    ),

    // ------------------------------------------------------------
    // STEP 8
    // ------------------------------------------------------------
    _BeginnerStep(
      title: 'Position Yellow Corners',
      description:
          'Put every yellow corner into its correct location. The yellow sticker does not need to face downward yet.',
      hold:
    'Keep YELLOW on top and GREEN facing you. Identify a correctly positioned yellow corner before applying the algorithm.',
      tip:
          'A corner is correctly positioned when its three colours belong between the same three centers, even if the corner is twisted.',
      learningPoints: [
        'Check all three colours of each yellow corner.',
        'Find a correctly positioned corner.',
        'Place that corner at front-right-bottom.',
        'Do not worry about whether YELLOW points downward yet.',
        'Run the corner-positioning algorithm.',
        'If no corner is correct, run the algorithm once and check again.',
      ],
      demos: [
        _Demo(
          name: 'Yellow Corner Position',
          moves: [
            "D'",
            "R'",
            'D',
            'L',
            "D'",
            'R',
            'D',
            "L'",
          ],
          explanation:
              'Cycles the yellow corners into their correct locations without requiring them to be oriented yet.',
        ),
      ],
    ),

    // ------------------------------------------------------------
    // STEP 9
    // ------------------------------------------------------------
    _BeginnerStep(
      title: 'Orient Yellow Corners',
      description:
          'The yellow corners are now in their correct locations. Twist them one at a time until YELLOW faces downward.',
      hold:
    'Keep YELLOW on top and GREEN facing you. Work on the front-right corner and turn only the faces specified by the algorithm.',
      tip:
          'The cube may look temporarily scrambled. Between corners, turn ONLY D — never rotate the whole cube.',
      learningPoints: [
        "Hold an unsolved corner at front-right-bottom.",
        "Repeat R U R' U' until that corner has YELLOW facing down.",
        'The sequence may need to be repeated several times.',
        'Do not rotate the entire cube.',
        'Turn only D to bring the next unsolved corner to front-right-bottom.',
        "Repeat R U R' U' again.",
        'Continue until all four corners are oriented.',
        'The cube will solve when the final corner is oriented.',
      ],
      demos: [
        _Demo(
          name: 'Yellow Corner Orientation',
          moves: [
            'R',
            'U',
            "R'",
            "U'",
          ],
          explanation:
              "Repeat R U R' U' until the front-right-bottom corner is oriented. Then turn only D to work on the next corner.",
        ),
      ],
    ),

    // ------------------------------------------------------------
    // STEP 10
    // ------------------------------------------------------------
    _BeginnerStep(
      title: 'Solved Cube',
      description:
          'Congratulations! The beginner method is complete when all six faces are solved.',
      hold:
    'Return to the normal viewing position: WHITE on top and GREEN facing you.',
      tip:
          'Practice each stage separately first. Once the recognition becomes automatic, combine all stages into complete solves.',
      learningPoints: [
        'WHITE face is solved.',
        'YELLOW face is solved.',
        'RED, GREEN, ORANGE and BLUE sides match their centers.',
        'All corners are correctly positioned and oriented.',
        'All edges are correctly positioned and oriented.',
        'You can now solve a complete cube using the beginner method.',
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resetCube();
    });
  }

  Future<void> _orientForStep() async {
  await cubeKey.currentState?.animateCameraTo(
    targetYaw: 0.0,
    targetPitch: -0.45,
    duration: const Duration(milliseconds: 700),
  );
}

Future<void> _resetCube() async {
  cubeKey.currentState?.resetCube();
  await _orientForStep();
}

  List<String> _inverseSequence(
    List<String> moves,
  ) {
    return moves.reversed
        .map(_reverseMove)
        .toList();
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

  Future<void> _animateSequence(
    List<String> moves,
  ) async {
    for (final move in moves) {
      if (!mounted) {
        return;
      }

      await cubeKey.currentState
          ?.animateMove(move);

      await Future.delayed(
        const Duration(milliseconds: 100),
      );
    }
  }

Future<void> _prepareStepByStep() async {
  if (isPlaying || _isStepping) return;

  final step = steps[currentStep];
  if (step.demos.isEmpty) return;

  final demo = step.demos[_selectedDemoIndex.clamp(0, step.demos.length - 1).toInt()];
  setState(() {
    _isStepping = true;
    _casePrepared = false;
    _nextMoveIndex = 0;
    _stepMoves = demo.moves;
    _practiceStatus = 'Preparing ${demo.name}…';
  });

  
  try {
    await _resetCube();
    if (!mounted) return;

    await _animateSequence(_inverseSequence(demo.moves));
    if (!mounted) return;

    setState(() {
      _casePrepared = true;
      _nextMoveIndex = 0;
      _practiceStatus =
          'Practice case ready. Follow the moves one at a time.';
    });
  } catch (e) {
    if (!mounted) return;
    setState(() {
      _casePrepared = false;
      _practiceStatus = 'Could not prepare case: $e';
    });
  } finally {
    if (mounted) {
      setState(() => _isStepping = false);
    }
  }
}

Future<void> _playNextMove() async {
  if (isPlaying || _isStepping) return;

  if (!_casePrepared) {
    await _prepareStepByStep();
    if (!mounted || !_casePrepared) return;
  }

  if (_nextMoveIndex >= _stepMoves.length) {
    setState(() {
      _practiceStatus = 'Demo complete. The algorithm has finished.';
    });
    return;
  }

  final move = _stepMoves[_nextMoveIndex];
  setState(() {
    _isStepping = true;
    _practiceStatus =
        'Move ${_nextMoveIndex + 1} of ${_stepMoves.length}: $move';
  });

  try {
    await cubeKey.currentState?.animateMove(move);
    if (!mounted) return;

    setState(() {
      _nextMoveIndex++;
      if (_nextMoveIndex >= _stepMoves.length) {
        _practiceStatus = 'Demo complete. The algorithm has finished.';
      }
    });
  } finally {
    if (mounted) {
      setState(() => _isStepping = false);
    }
  }
}

Future<void> _playStep() async {
  if (isPlaying) {
    return;
  }

  final step = steps[currentStep];

  if (step.demos.isEmpty) {
    return;
  }

  setState(() {
    isPlaying = true;
    _casePrepared = false;
    _nextMoveIndex = 0;
    _stepMoves = const [];
    _practiceStatus = null;
  });

  try {
    for (final demo in step.demos) {
      if (!mounted) {
        return;
      }

      // Reset the cube and wait for the correct camera orientation.
      await _resetCube();

      await Future.delayed(
        const Duration(milliseconds: 250),
      );

      // Build the practice case by reversing the demo algorithm.
      await _animateSequence(_inverseSequence(demo.moves));


      if (!mounted) {
        return;
      }

      await Future.delayed(
        const Duration(milliseconds: 500),
      );

      // Play the demonstration algorithm.
      await _animateSequence(demo.moves);

      if (!mounted) {
        return;
      }

      await Future.delayed(
        const Duration(milliseconds: 500),
      );
    }
  } finally {
    if (mounted) {
      await _resetCube();

      if (mounted) {
        setState(() {
          isPlaying = false;
        });
      }
    }
  }
}

  void _nextStep() {
    if (isPlaying) {
      return;
    }

    if (currentStep >= steps.length - 1) {
      return;
    }

    setState(() {
      currentStep++;
      _casePrepared = false;
      _nextMoveIndex = 0;
      _selectedDemoIndex = 0;
      _stepMoves = const [];
      _practiceStatus = null;
    });

    _resetCube();
  }

  void _previousStep() {
    if (isPlaying) {
      return;
    }

    if (currentStep <= 0) {
      return;
    }

    setState(() {
      currentStep--;
      _casePrepared = false;
      _nextMoveIndex = 0;
      _selectedDemoIndex = 0;
      _stepMoves = const [];
      _practiceStatus = null;
    });

    _resetCube();
  }

  Widget _buildOrientationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.08,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.view_in_ar,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Cube Orientation',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'WHITE on top • GREEN facing you',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Keep the same front and top orientation while reading an algorithm.',
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
              color: Colors.white.withValues(
                alpha: 0.70,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHoldCard(
    String hold,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF182235),
        borderRadius:
            BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.pan_tool_outlined,
            size: 19,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hold',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hold,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLearningCard(
    List<String> points,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.08,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'What You Learn',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ...points.map(
            (point) => Padding(
              padding:
                  const EdgeInsets.only(
                bottom: 8,
              ),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding:
                        EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.check_circle_outline,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      point,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoCard(
    _Demo demo,
    int index,
  ) {
    final isSelected = index == _selectedDemoIndex;
    return Container(
      width: double.infinity,
      margin:
          const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF22344B) : const Color(0xFF1C2638),
        border: Border.all(
          color: isSelected ? Colors.lightBlueAccent : Colors.white12,
        ),
        borderRadius:
            BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            demo.name,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 9),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: demo.moves.map(
              (move) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:
                        const Color(0xFF28364C),
                    borderRadius:
                        BorderRadius.circular(8),
                  ),
                  child: Text(
                    move,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ).toList(),
          ),
          const SizedBox(height: 9),
          Text(
            demo.explanation,
            style: const TextStyle(
              fontSize: 13,
              height: 1.4,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: (!isPlaying && !_isStepping)
                  ? () {
                      setState(() {
                        _selectedDemoIndex = index;
                        _casePrepared = false;
                        _nextMoveIndex = 0;
                        _stepMoves = const [];
                        _practiceStatus = 'Selected ${demo.name}. Tap Prepare case to begin.';
                      });
                    }
                  : null,
              icon: Icon(isSelected ? Icons.check_circle : Icons.play_circle_outline),
              label: Text(isSelected ? 'Selected for practice' : 'Practice this case'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final step = steps[currentStep];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Beginner Method',
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ------------------------------------------------------
            // Progress
            // ------------------------------------------------------
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                20,
                16,
                20,
                8,
              ),
              child: Row(
                children: [
                  Text(
                    'Step ${currentStep + 1}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${currentStep + 1} / ${steps.length}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: LinearProgressIndicator(
                value:
                    (currentStep + 1) /
                        steps.length,
                minHeight: 6,
                borderRadius:
                    BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 12),

            // ------------------------------------------------------
            // 3D Cube
            // ------------------------------------------------------
            Expanded(
              flex: 5,
              child: Container(
                margin:
                    const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color:
                      const Color(0xFF151922),
                  borderRadius:
                      BorderRadius.circular(20),
                  border: Border.all(
                    color:
                        Colors.white.withValues(
                      alpha: 0.10,
                    ),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    
                    LearningCube3DView(
                    key: cubeKey,
                    yellowTop: currentStep >= 5 && currentStep <= 8,
                    ),

                    Positioned(
                      top: 14,
                      child: Container(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 18,
                          vertical: 9,
                        ),
                        decoration:
                            BoxDecoration(
                          color:
                              Colors.black.withValues(
                            alpha: 0.75,
                          ),
                          borderRadius:
                              BorderRadius.circular(
                            24,
                          ),
                        ),
                        child: Text(
                          step.title,
                          style:
                              const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ------------------------------------------------------
            // Learning content
            // ------------------------------------------------------
            Expanded(
              flex: 4,
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.title,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      step.description,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.45,
                        color: Colors.white70,
                      ),
                    ),

                    const SizedBox(height: 14),

                    if (currentStep == 0)
                      _buildOrientationCard(),

                    if (currentStep == 0)
                      const SizedBox(height: 12),

                    _buildHoldCard(step.hold),

                    const SizedBox(height: 12),

                    _buildLearningCard(
                      step.learningPoints,
                    ),

                    if (step.demos.isNotEmpty) ...[
                      const SizedBox(height: 14),

                      const Text(
                        '3D Practice',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 7),

                      Text(
                        'Use Play for the full animation, or Prepare case and Next move '
                        'to study the algorithm at your own pace.',
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color:
                              Colors.white.withValues(
                            alpha: 0.65,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      ...step.demos.asMap().entries.map(
                        (entry) => _buildDemoCard(entry.value, entry.key),
                      ),

                      // Reference-inspired guided controls. These call
                      // only methods already exposed by Cube3DViewState.
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: !isPlaying && !_isStepping
                                  ? _prepareStepByStep
                                  : null,
                              icon: const Icon(Icons.tune),
                              label: const Text('Prepare case'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: !isPlaying && !_isStepping
                                  ? _playNextMove
                                  : null,
                              icon: Icon(
                                _casePrepared
                                    ? Icons.skip_next
                                    : Icons.play_arrow,
                              ),
                              label: Text(
                                _casePrepared
                                    ? (_nextMoveIndex < _stepMoves.length
                                        ? 'Next move'
                                        : 'Finished')
                                    : 'Prepare & start',
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_practiceStatus != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF111827),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _practiceStatus!,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ],

                    const SizedBox(height: 12),

                    Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color:
                            const Color(0xFF111827),
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),
                      ),
                      child: Text(
                        '💡 ${step.tip}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ------------------------------------------------------
            // Navigation
            // ------------------------------------------------------
            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed:
                          currentStep > 0 &&
                                  !isPlaying
                              ? _previousStep
                              : null,
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 18,
                      ),
                      label: const Text(
                        'Prev',
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed:
                          !isPlaying &&
                                  step.demos
                                      .isNotEmpty
                              ? _playStep
                              : null,
                      icon: Icon(
                        isPlaying
                            ? Icons.hourglass_top
                            : Icons.play_arrow,
                      ),
                      label: Text(
                        isPlaying
                            ? 'Playing...'
                            : 'Play',
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed:
                          currentStep <
                                      steps.length -
                                          1 &&
                                  !isPlaying
                              ? _nextStep
                              : null,
                      icon: const Icon(
                        Icons.arrow_forward,
                        size: 18,
                      ),
                      label: const Text(
                        'Next',
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}

class _BeginnerStep {
  final String title;
  final String description;
  final String hold;
  final String tip;
  final List<String> learningPoints;
  final List<_Demo> demos;

  const _BeginnerStep({
    required this.title,
    required this.description,
    required this.hold,
    required this.tip,
    required this.learningPoints,
    this.demos = const [],
  });
}

class _Demo {
  final String name;
  final List<String> moves;
  final String explanation;
  final List<String> setupMoves;

  const _Demo({
    required this.name,
    required this.moves,
    required this.explanation,
    this.setupMoves = const [],
  });
}