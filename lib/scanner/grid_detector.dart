

import 'sticker_detector.dart';

class GridDetectionResult {
  final bool valid;
  final List<StickerCandidate> stickers;

  const GridDetectionResult({
    required this.valid,
    required this.stickers,
  });
}

class GridDetector {
  static GridDetectionResult detect(
    List<StickerCandidate> stickers,
  ) {
    if (stickers.length != 9) {
      return const GridDetectionResult(
        valid: false,
        stickers: [],
      );
    }

    final ordered = List<StickerCandidate>.from(stickers);

    // Step 1
    // Sort vertically.
    ordered.sort(
      (a, b) => a.center.dy.compareTo(b.center.dy),
    );

    // Step 2
    // Split into three rows.
    final row1 = ordered.sublist(0, 3);
    final row2 = ordered.sublist(3, 6);
    final row3 = ordered.sublist(6, 9);

    // Step 3
    // Sort each row left-to-right.
    row1.sort((a, b) => a.center.dx.compareTo(b.center.dx));
    row2.sort((a, b) => a.center.dx.compareTo(b.center.dx));
    row3.sort((a, b) => a.center.dx.compareTo(b.center.dx));

    // Step 4
    // Merge.
    final result = <StickerCandidate>[
      ...row1,
      ...row2,
      ...row3,
    ];

    return GridDetectionResult(
      valid: true,
      stickers: result,
    );
  }
}