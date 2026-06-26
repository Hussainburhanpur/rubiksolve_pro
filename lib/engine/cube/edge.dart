import 'cube_color.dart';

class Edge {
  final int id;

  int orientation;

  List<CubeColor> colors;

  Edge({
    required this.id,
    required this.colors,
    this.orientation = 0,
  });

  Edge copy() {
    return Edge(
      id: id,
      colors: List.from(colors),
      orientation: orientation,
    );
  }
}