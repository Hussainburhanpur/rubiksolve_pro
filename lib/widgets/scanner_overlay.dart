import 'package:flutter/material.dart';

class ScannerOverlay extends StatelessWidget {
  const ScannerOverlay({
    super.key,
    this.size = 260,
    this.detected = false,
    required this.sampleColors,
  });

  final double size;
  final bool detected;
  final List<Color> sampleColors;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: ScannerOverlayPainter(
              detected: detected,
              sampleColors: sampleColors,
            ),
          ),
        ),
      ),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  ScannerOverlayPainter({
    required this.detected,
    required this.sampleColors,
  });

  final bool detected;
  final List<Color> sampleColors;

  @override
  void paint(Canvas canvas, Size size) {
    const double radius = 18;

    final Rect rect = Offset.zero & size;

    final Paint borderPaint = Paint()
      ..color = detected ? Colors.green : Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect,
        const Radius.circular(radius),
      ),
      borderPaint,
    );

    final Paint gridPaint = Paint()
      ..color = (detected ? Colors.green : Colors.white).withValues(alpha: 0.9)
      ..strokeWidth = 1.2;

    final double thirdX = size.width / 3;
    final double thirdY = size.height / 3;

    for (int i = 1; i < 3; i++) {
      canvas.drawLine(
        Offset(thirdX * i, 0),
        Offset(thirdX * i, size.height),
        gridPaint,
      );

      canvas.drawLine(
        Offset(0, thirdY * i),
        Offset(size.width, thirdY * i),
        gridPaint,
      );
    }

    final double cellW = size.width / 3;
    final double cellH = size.height / 3;

    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        final int index = row * 3 + col;

        final Color color =
            index < sampleColors.length
                ? sampleColors[index]
                : Colors.red;

        final Paint samplePaint = Paint()
          ..color = color
          ..style = PaintingStyle.fill;

        canvas.drawCircle(
          Offset(
            cellW * col + cellW / 2,
            cellH * row + cellH / 2,
          ),
          6,
          samplePaint,
        );
      }
    }

    final Paint cornerPaint = Paint()
      ..color = detected ? Colors.green : const Color(0xFF3B82F6)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    const double offset = 8;
    const double length = 20;

    // Top Left
    canvas.drawLine(
      const Offset(-offset, length),
      const Offset(-offset, -offset),
      cornerPaint,
    );

    canvas.drawLine(
      const Offset(-offset, -offset),
      const Offset(length, -offset),
      cornerPaint,
    );

    // Top Right
    canvas.drawLine(
      Offset(size.width - length, -offset),
      Offset(size.width + offset, -offset),
      cornerPaint,
    );

    canvas.drawLine(
      Offset(size.width + offset, -offset),
      Offset(size.width + offset, length),
      cornerPaint,
    );

    // Bottom Left
    canvas.drawLine(
      Offset(-offset, size.height - length),
      Offset(-offset, size.height + offset),
      cornerPaint,
    );

    canvas.drawLine(
      Offset(-offset, size.height + offset),
      Offset(length, size.height + offset),
      cornerPaint,
    );

    // Bottom Right
    canvas.drawLine(
      Offset(size.width - length, size.height + offset),
      Offset(size.width + offset, size.height + offset),
      cornerPaint,
    );

    canvas.drawLine(
      Offset(size.width + offset, size.height - length),
      Offset(size.width + offset, size.height + offset),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant ScannerOverlayPainter oldDelegate) {
    return oldDelegate.detected != detected ||
        oldDelegate.sampleColors != sampleColors;
  }
}