import 'package:flutter/material.dart';

class FaceProgress extends StatelessWidget {
  final int scannedFaces;

  const FaceProgress({
    super.key,
    required this.scannedFaces,
  });

  @override
  Widget build(BuildContext context) {
    final progress = scannedFaces / 6;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.65),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Scanning Cube",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            borderRadius: BorderRadius.circular(20),
          ),

          const SizedBox(height: 10),

          Text(
            "$scannedFaces / 6 Faces",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}