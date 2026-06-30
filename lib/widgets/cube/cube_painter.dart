import 'package:flutter/material.dart';

class CubePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double gap = 4;

    final double sticker = (size.width - gap * 4) / 3;

    final paint = Paint()
      ..style = PaintingStyle.fill;

    final border = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final colors = [
      Colors.white,
      Colors.red,
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.yellow,
      Colors.white,
      Colors.red,
      Colors.blue,
    ];

    int index = 0;

    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        final rect = Rect.fromLTWH(
          gap + col * (sticker + gap),
          gap + row * (sticker + gap),
          sticker,
          sticker,
        );

        paint.color = colors[index++];

        canvas.drawRRect(
          RRect.fromRectAndRadius(
            rect,
            const Radius.circular(6),
          ),
          paint,
        );

        canvas.drawRRect(
          RRect.fromRectAndRadius(
            rect,
            const Radius.circular(6),
          ),
          border,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}