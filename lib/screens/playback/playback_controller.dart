import 'dart:async';

class PlaybackController {
  PlaybackController({
    required List<String> moves,
  }) : _moves = List<String>.from(moves);

  final List<String> _moves;

  int _index = 0;
  bool _playing = false;

  Timer? _timer;

  List<String> get moves => _moves;

  int get currentIndex => _index;

  int get totalMoves => _moves.length;

  bool get isPlaying => _playing;

  String get currentMove {
    if (_moves.isEmpty) return "";
    return _moves[_index];
  }

  void next() {
    if (_index < _moves.length - 1) {
      _index++;
    }
  }

  void previous() {
    if (_index > 0) {
      _index--;
    }
  }

  void reset() {
    _index = 0;
  }

  void play(VoidCallback onTick) {
    if (_playing) return;

    _playing = true;

    _timer = Timer.periodic(
      const Duration(milliseconds: 700),
      (_) {
        if (_index >= _moves.length - 1) {
          pause();
          return;
        }

        next();
        onTick();
      },
    );
  }

  void pause() {
    _playing = false;
    _timer?.cancel();
  }

  void dispose() {
    _timer?.cancel();
  }
}

typedef VoidCallback = void Function();