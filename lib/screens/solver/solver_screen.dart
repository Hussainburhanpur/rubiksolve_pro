import 'package:flutter/material.dart';
import '../../scanner/face_storage.dart';
import '../../services/cube_string_builder.dart';
import '../../services/solver_service.dart';

class SolverScreen extends StatefulWidget {
  const SolverScreen({super.key});

  @override
  State<SolverScreen> createState() => _SolverScreenState();
}

class _SolverScreenState extends State<SolverScreen> {
  String _cubeString = '';
  List<String> _solution = [];
  final SolverService _solver = SolverService(
  baseUrl: 'http://172.16.113.116:5001',
);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Solve Cube"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),

            const Text(
              "Cube String",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            SelectableText(
              _cubeString.isEmpty
                  ? "No cube scanned."
                  : _cubeString,
            ),

            const SizedBox(height: 30),

            ElevatedButton.icon(
  onPressed: () {
    try {
      final cube = CubeStringBuilder.build(
        FaceStorage.instance.cubeState,
      );

      setState(() {
        _cubeString = cube;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  },
  icon: const Icon(Icons.extension),
  label: const Text("Generate Cube String"),
),

            const SizedBox(height: 15),

            ElevatedButton.icon(
  onPressed: () async {
    if (_cubeString.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Generate the cube string first."),
        ),
      );
      return;
    }

    try {
      final moves = await _solver.solve(_cubeString);

      setState(() {
        _solution = moves;
      });

      if (moves.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Cube is already solved."),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  },
  icon: const Icon(Icons.play_arrow),
  label: const Text("Solve Cube"),
),

            const SizedBox(height: 30),

            const Text(
              "Solution",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: _solution.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text("${index + 1}"),
                    ),
                    title: Text(_solution[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}