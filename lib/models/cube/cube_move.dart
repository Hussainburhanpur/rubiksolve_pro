enum MoveDirection {
  clockwise,
  anticlockwise,
  doubleTurn,
}

class CubeMove {
  final String face;
  final MoveDirection direction;

  const CubeMove({
    required this.face,
    required this.direction,
  });

  factory CubeMove.fromNotation(String notation) {
    if (notation.isEmpty) {
      throw ArgumentError('Invalid move notation');
    }

    final face = notation[0];

    if (!'UDFBLR'.contains(face)) {
      throw ArgumentError('Unknown face: $face');
    }

    if (notation.endsWith("2")) {
      return CubeMove(
        face: face,
        direction: MoveDirection.doubleTurn,
      );
    }

    if (notation.endsWith("'")) {
      return CubeMove(
        face: face,
        direction: MoveDirection.anticlockwise,
      );
    }

    return CubeMove(
      face: face,
      direction: MoveDirection.clockwise,
    );
  }

  @override
  String toString() {
    switch (direction) {
      case MoveDirection.clockwise:
        return face;
      case MoveDirection.anticlockwise:
        return "$face'";
      case MoveDirection.doubleTurn:
        return "${face}2";
    }
  }
}