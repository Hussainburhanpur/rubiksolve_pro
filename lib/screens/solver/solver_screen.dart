import 'package:flutter/material.dart';
import '../playback/playback_screen.dart';
import '../../services/solver_service.dart';
import '../../widgets/cube3D/cube3d_view.dart';

class SolverScreen extends StatefulWidget {
  const SolverScreen({super.key});

  @override
  State<SolverScreen> createState() => _SolverScreenState();
}

class _SolverScreenState extends State<SolverScreen> {
  final SolverService _solver = SolverService(
    baseUrl: 'http://192.168.1.12:5001',
  );

  // ------------------------------------------------------------
  // Cube faces
  // ------------------------------------------------------------

  static const List<String> _faces = [
    'U',
    'R',
    'F',
    'D',
    'L',
    'B',
  ];

  static const Map<String, String> _faceNames = {
    'U': 'Up',
    'R': 'Right',
    'F': 'Front',
    'D': 'Down',
    'L': 'Left',
    'B': 'Back',
  };

  // ------------------------------------------------------------
  // Cube colors
  // ------------------------------------------------------------

  static const Map<String, Color> _colors = {
    'U': Color(0xFFF5F5F5), // White
    'R': Color(0xFFE53935), // Red
    'F': Color(0xFF43A047), // Green
    'D': Color(0xFFFDD835), // Yellow
    'L': Color(0xFFFB8C00), // Orange
    'B': Color(0xFF1E88E5), // Blue
  };

  static const Map<String, String> _colorNames = {
    'U': 'White',
    'R': 'Red',
    'F': 'Green',
    'D': 'Yellow',
    'L': 'Orange',
    'B': 'Blue',
  };

  // ------------------------------------------------------------
  // Cube state
  //
  // Each face contains 9 stickers.
  // ------------------------------------------------------------

  late Map<String, List<String>> _cube;

  int _currentFace = 0;

  String _selectedColor = 'U';

  List<String> _solution = [];
  String? _solvedCubeString;

  bool _isSolving = false;

  @override
  void initState() {
    super.initState();
    _initializeCube();
  }

  // ------------------------------------------------------------
  // Initialize solved cube
  // ------------------------------------------------------------

  void _initializeCube() {
  _cube = {
    for (final face in _faces)
      face: List<String>.filled(9, face),
  };
}
  // ------------------------------------------------------------
  // Current face
  // ------------------------------------------------------------

  String get _currentFaceName => _faces[_currentFace];

  List<String> get _currentStickers => _cube[_currentFaceName]!;

  // ------------------------------------------------------------
  // Change sticker color
  // ------------------------------------------------------------

  void _setStickerColor(int index) {
    // Center stickers represent the fixed center color.
    if (index == 4) {
      return;
    }

    setState(() {
      _currentStickers[index] = _selectedColor;
      _solution = [];
    });
  }

  // ------------------------------------------------------------
  // Change selected color
  // ------------------------------------------------------------

  void _selectColor(String color) {
    setState(() {
      _selectedColor = color;
    });
  }

  // ------------------------------------------------------------
  // Move to another face
  // ------------------------------------------------------------

  void _selectFace(int index) {
    setState(() {
      _currentFace = index;
    });
  }

  void _nextFace() {
    if (_currentFace < _faces.length - 1) {
      setState(() {
        _currentFace++;
      });
    }
  }

  void _previousFace() {
    if (_currentFace > 0) {
      setState(() {
        _currentFace--;
      });
    }
  }

  // ------------------------------------------------------------
  // Reset cube
  // ------------------------------------------------------------

  void _resetCube() {
    setState(() {
      _initializeCube();
      _currentFace = 0;
      _selectedColor = 'U';
      _solution = [];
    });
  }

  // ------------------------------------------------------------
  // Check whether every color occurs exactly 9 times
  // ------------------------------------------------------------

  String? _validateColorCounts() {
    final Map<String, int> counts = {
      for (final color in _faces) color: 0,
    };

    for (final face in _faces) {
      for (final sticker in _cube[face]!) {
        if (!counts.containsKey(sticker)) {
          return 'Invalid color detected.';
        }

        counts[sticker] = counts[sticker]! + 1;
      }
    }

    for (final color in _faces) {
      if (counts[color] != 9) {
        return '${_colorNames[color]} must appear exactly 9 times.';
      }
    }

    return null;
  }

  // ------------------------------------------------------------
  // Build Kociemba cube string
  //
  // Order:
  // U R F D L B
  // ------------------------------------------------------------

  String _buildCubeString() {
    final buffer = StringBuffer();

    for (final face in _faces) {
      for (final sticker in _cube[face]!) {
        buffer.write(sticker);
      }
    }

    return buffer.toString();
  }

  // ------------------------------------------------------------
  // Solve cube
  // ------------------------------------------------------------

  Future<void> _solveCube() async {
    final validationError = _validateColorCounts();

    if (validationError != null) {
      _showMessage(validationError);
      return;
    }

    final cubeString = _buildCubeString();

    debugPrint('Cube String: $cubeString | Length: ${cubeString.length}');

    setState(() {
  _isSolving = true;
  _solution = [];
  _solvedCubeString = cubeString;
});

    try {
      final moves = await _solver.solve(cubeString);

      if (!mounted) {
        return;
      }

      setState(() {
        _solution = moves;
      });

      if (moves.isEmpty) {
        _showMessage('Cube is already solved.');
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      _showMessage(
        'Unable to solve cube.\n${e.toString()}',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSolving = false;
        });
      }
    }
  }

  // ------------------------------------------------------------
  // Snackbar
  // ------------------------------------------------------------

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ------------------------------------------------------------
  // Face grid
  // ------------------------------------------------------------

  Widget _buildFaceGrid() {
    final stickers = _currentStickers;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF151922),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
        ),
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 9,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 7,
            mainAxisSpacing: 7,
          ),
          itemBuilder: (context, index) {
            final colorCode = stickers[index];
            final color = _colors[colorCode]!;

            final bool isCenter = index == 4;
            final bool isSelected =
                !isCenter && colorCode == _selectedColor;

            return GestureDetector(
              onTap: isCenter
                  ? null
                  : () {
                      _setStickerColor(index);
                    },
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                    color: isCenter
                        ? Colors.white
                        : isSelected
                            ? Colors.white
                            : Colors.black.withValues(alpha: 0.65),
                    width: isCenter || isSelected ? 3 : 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: isCenter
                    ? Center(
                        child: Text(
                          _currentFaceName,
                          style: TextStyle(
                            color: colorCode == 'U' ||
                                    colorCode == 'D'
                                ? Colors.black
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      )
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // Color palette
  // ------------------------------------------------------------

  Widget _buildColorPalette() {
  const colorLabels = {
    'U': 'W',
    'R': 'R',
    'F': 'G',
    'D': 'Y',
    'L': 'O',
    'B': 'B',
  };

  return Wrap(
    alignment: WrapAlignment.center,
    spacing: 10,
    runSpacing: 10,
    children: _faces.map((colorCode) {
      final selected = _selectedColor == colorCode;

      return GestureDetector(
        onTap: () {
          _selectColor(colorCode);
        },
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _colors[colorCode],
            shape: BoxShape.circle,
            border: Border.all(
              color: selected
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.25),
              width: selected ? 3 : 1.5,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: _colors[colorCode]!
                          .withValues(alpha: 0.45),
                      blurRadius: 10,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              colorLabels[colorCode]!,
              style: TextStyle(
                color: colorCode == 'U' || colorCode == 'D'
                    ? Colors.black
                    : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      );
    }).toList(),
  );
}

  // ------------------------------------------------------------
  // Face selector
  // ------------------------------------------------------------

  Widget _buildFaceSelector() {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _faces.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final face = _faces[index];

          final bool selected = index == _currentFace;

          final bool complete =
              _cube[face]!.every((sticker) => sticker == face);

          return GestureDetector(
            onTap: () {
              _selectFace(index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 48,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF3B82F6)
                    : const Color(0xFF191C24),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected
                      ? Colors.white.withValues(alpha: 0.7)
                      : Colors.white.withValues(alpha: 0.1),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      face,
                      style: TextStyle(
                        color: selected
                            ? Colors.white
                            : Colors.white70,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (complete)
                    const Positioned(
                      right: 5,
                      top: 4,
                      child: Icon(
                        Icons.check_circle,
                        size: 12,
                        color: Colors.greenAccent,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ------------------------------------------------------------
  // Solution list
  // ------------------------------------------------------------

  
Widget _buildSolution() {
  if (_solution.isEmpty) {
    return const SizedBox.shrink();
  }

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFF151922),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.1),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Solution',
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _solution.map((move) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF202532),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                move,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlaybackScreen(
  moves: List<String>.from(_solution),
  initialCubeString: _solvedCubeString,
),
                ),
              );
            },
            icon: const Icon(Icons.view_in_ar),
            label: const Text('View 3D Solution'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
          ),
        ),
      ],
    ),
  );
}


  // ------------------------------------------------------------
  // Build
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Solve Cube'),
        actions: [
          IconButton(
            tooltip: 'Reset Cube',
            onPressed: _isSolving ? null : _resetCube,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Enter Your Cube',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: const Color(0xFF151922),
    borderRadius: BorderRadius.circular(18),
    border: Border.all(
      color: Colors.white.withValues(alpha: 0.12),
    ),
  ),
  child: Column(
    children: [
      const CubeOrientationGuide(),
const SizedBox(height: 10),
      const Text(
        'Hold Your Cube Correctly',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        'Keep WHITE (U) on top and GREEN (F) facing you. '
        'Keep this orientation while entering every face.',
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: Colors.white70,
          height: 1.4,
        ),
      ),
    ],
  ),
),

const SizedBox(height: 14),

              Text(
                'Select a color, then tap the stickers.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white60,
                ),
              ),

              const SizedBox(height: 20),

              // Face name
              Text(
                '${_faceNames[_currentFaceName]} Face',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              _buildFaceSelector(),

              const SizedBox(height: 20),

              _buildFaceGrid(),

              const SizedBox(height: 22),

              const Text(
                'Choose Color',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              _buildColorPalette(),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed:
                          _currentFace > 0 && !_isSolving
                              ? _previousFace
                              : null,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Previous'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed:
                          _currentFace < 5 && !_isSolving
                              ? _nextFace
                              : null,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Next'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              ElevatedButton.icon(
                onPressed: _isSolving ? null : _solveCube,
                icon: _isSolving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.play_arrow),
                label: Text(
                  _isSolving ? 'Solving...' : 'Solve Cube',
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                ),
              ),

              const SizedBox(height: 20),

              _buildSolution(),
            ],
          ),
        ),
      ),
    );
  }
}

class CubeOrientationGuide extends StatefulWidget {
  const CubeOrientationGuide({super.key});

  @override
  State<CubeOrientationGuide> createState() =>
      _CubeOrientationGuideState();
}

class _CubeOrientationGuideState extends State<CubeOrientationGuide> {
  final GlobalKey<Cube3DViewState> _cubeKey =
      GlobalKey<Cube3DViewState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playGuide();
    });
  }

  Future<void> _playGuide() async {
  final cube = _cubeKey.currentState;
  if (cube == null) return;

  while (mounted) {
    // Starting orientation:
    // WHITE (U) = TOP
    // GREEN (F) = FRONT
    // RED (R) = RIGHT
    // ORANGE (L) = LEFT
    await cube.animateCameraTo(
      targetYaw: 0,
      targetPitch: 0.45,
      duration: const Duration(milliseconds: 700),
    );

    await Future.delayed(
      const Duration(milliseconds: 800),
    );

    // Gently rotate toward the RIGHT.
    // WHITE stays on top.
    await cube.animateCameraTo(
      targetYaw: -0.55,
      targetPitch: 0.45,
      duration: const Duration(milliseconds: 700),
    );

    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    // Return to center.
    await cube.animateCameraTo(
      targetYaw: 0,
      targetPitch: 0.45,
      duration: const Duration(milliseconds: 700),
    );

    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    // Gently rotate toward the LEFT.
    // WHITE stays on top.
    await cube.animateCameraTo(
      targetYaw: 0.55,
      targetPitch: 0.45,
      duration: const Duration(milliseconds: 700),
    );

    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    // Return to the correct starting orientation.
    await cube.animateCameraTo(
      targetYaw: 0,
      targetPitch: 0.45,
      duration: const Duration(milliseconds: 700),
    );

    await Future.delayed(
      const Duration(milliseconds: 500),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    const solvedCube =
        'UUUUUUUUURRRRRRRRRFFFFFFFFFDDDDDDDDDLLLLLLLLLBBBBBBBBB';

    return Column(
      children: [
        // TOP instruction
        _instructionLabel(
          'WHITE (U) • KEEP ON TOP',
          Colors.white,
        ),

        const SizedBox(height: 4),

        // 3D animation
        SizedBox(
  height: 155,
  child: Center(
    child: Transform.scale(
      scale: 0.68,
      child: IgnorePointer(
        child: Cube3DView(
          key: _cubeKey,
          initialCubeString: solvedCube,
        ),
      ),
    ),
  ),
),

const SizedBox(height: 18),

const SizedBox(height: 18),

// FRONT instruction
_instructionLabel(
  'GREEN (F) • KEEP FACING YOU',
  Colors.greenAccent,
),

        const SizedBox(height: 12),

        // Physical orientation instruction
        Text(
          'When viewing another face, rotate the cube while '
          'keeping WHITE on top. Do not flip or tilt the cube.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white70,
                height: 1.35,
              ),
        ),

        const SizedBox(height: 12),

        // Center sticker explanation
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                'Important: The center sticker identifies the face',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'White = U   •   Red = R   •   Green = F\n'
                'Yellow = D   •   Orange = L   •   Blue = B',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                      height: 1.5,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _instructionLabel(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}