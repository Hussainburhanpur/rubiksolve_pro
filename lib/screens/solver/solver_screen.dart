import 'package:flutter/material.dart';

class SolverScreen extends StatelessWidget {
  const SolverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Solve Cube")),
      body: const Center(
        child: Text(
          "Solver Screen\n(Coming Soon)",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}