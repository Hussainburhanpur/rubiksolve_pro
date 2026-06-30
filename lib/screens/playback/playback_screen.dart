import 'package:flutter/material.dart';
import 'playback_controller.dart';
import '../../widgets/cube/cube_view.dart';

class PlaybackScreen extends StatefulWidget {
  final List<String> moves;

  const PlaybackScreen({
    super.key,
    this.moves = const [],
  });

  @override
  State<PlaybackScreen> createState() => _PlaybackScreenState();
}

class _PlaybackScreenState extends State<PlaybackScreen> {
  late PlaybackController controller;

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

  void refresh() {
    setState(() {});
  }
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

            Text(
  controller.moves.isEmpty
      ? "Solution Animation"
      : controller.currentMove,
  style: const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 10),

Text(
  controller.moves.isEmpty
      ? "No solution loaded"
      : "Step ${controller.currentIndex + 1} / ${controller.totalMoves}",
  style: const TextStyle(
    fontSize: 18,
  ),
),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  iconSize: 42,
                  onPressed: () {
  controller.previous();
  refresh();
},
                  icon: const Icon(Icons.skip_previous),
                ),
                IconButton(
  iconSize: 52,
  onPressed: () {
    if (controller.isPlaying) {
      controller.pause();
    } else {
      controller.play(refresh);
    }

    refresh();
  },
  icon: Icon(
    controller.isPlaying
        ? Icons.pause
        : Icons.play_arrow,
  ),
),
                IconButton(
                  iconSize: 42,
                  onPressed: () {
  controller.next();
  refresh();
},
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