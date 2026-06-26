
import 'package:flutter/material.dart';

class ScannerMask extends StatelessWidget {
  const ScannerMask({
    super.key,
    this.scanSize = 300,
  });

  final double scanSize;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        size: Size.infinite,
        painter: ScannerMaskPainter(scanSize),
      ),
    );
  }
}

class ScannerMaskPainter extends CustomPainter {
  ScannerMaskPainter(this.scanSize);

  final double scanSize;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint overlayPaint =
        Paint()
          ..color = Colors.black.withValues(alpha: 0.55);

    final Path background =
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final Rect scanRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: scanSize,
      height: scanSize,
    );

    final Path hole =
        Path()
          ..addRRect(
            RRect.fromRectAndRadius(
              scanRect,
              const Radius.circular(22),
            ),
          );

    final Path finalPath = Path.combine(
      PathOperation.difference,
      background,
      hole,
    );

    canvas.drawPath(finalPath, overlayPaint);
  }

  @override
  bool shouldRepaint(covariant ScannerMaskPainter oldDelegate) {
    return oldDelegate.scanSize != scanSize;
  }
}