class PlaybackController {
  PlaybackController({
    required List<String> moves,
  }) : _moves = List<String>.from(moves);

  final List<String> _moves;

  int _index = 0;
  bool _playing = false;

  List<String> get moves => _moves;

  int get currentIndex => _index;

  int get totalMoves => _moves.length;

  bool get isPlaying => _playing;

  String get currentMove {
    if (_moves.isEmpty) return "";

    if (_index == 0) {
      return _moves[0];
    }

    return _moves[_index - 1];
  }

  String? get nextMove {
    if (_index >= _moves.length) {
      return null;
    }

    return _moves[_index];
  }

  String? get previousMove {
    if (_index <= 0) {
      return null;
    }

    return _moves[_index - 1];
  }

  bool get canGoNext {
    return _index < _moves.length;
  }

  bool get canGoPrevious {
    return _index > 0;
  }

  void markNextApplied() {
    if (_index < _moves.length) {
      _index++;
    }
  }

  void markPreviousApplied() {
    if (_index > 0) {
      _index--;
    }
  }

  void startPlaying() {
    _playing = true;
  }

  void stopPlaying() {
    _playing = false;
  }

  void reset() {
    _index = 0;
    _playing = false;
  }

  void dispose() {}
}