import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("RubikSolve Pro"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              const Icon(
                Icons.view_in_ar,
                size: 100,
              ),

              const SizedBox(height: 20),

              const Text(
                "RubikSolve Pro",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Professional Rubik's Cube Solver",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 40),

              _menuButton(
                icon: Icons.play_arrow_rounded,
                title: "Solve Cube",
              ),

              const SizedBox(height: 16),

              _menuButton(
                icon: Icons.camera_alt_rounded,
                title: "Scan Cube",
              ),

              const SizedBox(height: 16),

              _menuButton(
                icon: Icons.school_rounded,
                title: "Learn Algorithms",
              ),

              const SizedBox(height: 16),

              _menuButton(
                icon: Icons.slideshow_rounded,
                title: "Solution Playback",
              ),

              const SizedBox(height: 16),

              _menuButton(
                icon: Icons.bar_chart_rounded,
                title: "Statistics",
              ),

              const SizedBox(height: 16),

              _menuButton(
                icon: Icons.settings_rounded,
                title: "Settings",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuButton({
    required IconData icon,
    required String title,
  }) {
    return SizedBox(
      height: 60,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(icon),
        label: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}