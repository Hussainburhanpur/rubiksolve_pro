import 'package:flutter/material.dart';

import '../../widgets/cube/cube_view.dart';

class PlaybackScreen extends StatelessWidget {
  const PlaybackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Solution Playback"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const Expanded(
              flex: 5,
              child: CubeView(),
            ),

            const SizedBox(height: 20),

            const Text(
              "Solution Animation",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  iconSize: 42,
                  onPressed: () {},
                  icon: const Icon(Icons.skip_previous),
                ),
                IconButton(
                  iconSize: 52,
                  onPressed: () {},
                  icon: const Icon(Icons.play_arrow),
                ),
                IconButton(
                  iconSize: 42,
                  onPressed: () {},
                  icon: const Icon(Icons.skip_next),
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