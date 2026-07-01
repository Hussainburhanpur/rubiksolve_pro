import 'package:flutter/material.dart';

import 'cubie_data.dart';

class CubieWidget extends StatelessWidget {
  final CubieData data;
  final double size;

  const CubieWidget({
    super.key,
    required this.data,
    this.size = 46,
  });

  Widget _sticker(Color? color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(2),
      ),
      alignment: Alignment.center,
      child: Container(
        width: size * 0.96,
        height: size * 0.96,
        decoration: BoxDecoration(
          color: color ?? Colors.transparent,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _sticker(data.front);
  }
}