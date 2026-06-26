import 'package:flutter/material.dart';

import '../solver/solver_screen.dart';
import '../scanner/scanner_screen.dart';
import '../learn/learn_screen.dart';
import '../playback/playback_screen.dart';
import '../statistics/statistics_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _open(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  Widget buildButton(
    BuildContext context,
    IconData icon,
    String title,
    Widget page,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: double.infinity,
        height: 70,
        child: ElevatedButton.icon(
          onPressed: () => _open(context, page),
          icon: Icon(icon, size: 28),
          label: Text(
            title,
            style: const TextStyle(fontSize: 22),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [

              const SizedBox(height: 10),

              const Icon(
                Icons.view_in_ar,
                size: 110,
              ),

              const SizedBox(height: 20),

              const Center(
                child: Text(
                  "RubikSolve Pro",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              const Center(
                child: Text(
                  "Professional Rubik's Cube Solver",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),

              const SizedBox(height: 35),

              buildButton(
                context,
                Icons.play_arrow,
                "Solve Cube",
                const SolverScreen(),
              ),

              buildButton(
                context,
                Icons.camera_alt,
                "Scan Cube",
                const ScannerScreen(),
              ),

              buildButton(
                context,
                Icons.school,
                "Learn Algorithms",
                const LearnScreen(),
              ),

              buildButton(
                context,
                Icons.smart_display,
                "Solution Playback",
                const PlaybackScreen(),
              ),

              buildButton(
                context,
                Icons.bar_chart,
                "Statistics",
                const StatisticsScreen(),
              ),

              buildButton(
                context,
                Icons.settings,
                "Settings",
                const SettingsScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}