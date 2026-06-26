import 'package:flutter/material.dart';

class ScannerOverlay extends StatelessWidget {
  const ScannerOverlay({
    super.key,
    this.size = 260,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: ScannerOverlayPainter(),
          ),
        ),
      ),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double radius = 18;

    final Rect rect = Offset.zero & size;

    final Paint borderPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect,
        const Radius.circular(radius),
      ),
      borderPaint,
    );

    final Paint gridPaint =
        Paint()
          ..color = Colors.white.withValues(alpha: 0.9)
          ..strokeWidth = 1.2;

    final double thirdX = size.width / 3;
    final double thirdY = size.height / 3;

    for (int index = 1; index < 3; index++) {
      final double x = thirdX * index;

      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        gridPaint,
      );
    }

    for (int index = 1; index < 3; index++) {
      final double y = thirdY * index;

      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    final Paint cornerPaint =
        Paint()
          ..color = const Color(0xFF3B82F6)
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
    return false;
  }
}