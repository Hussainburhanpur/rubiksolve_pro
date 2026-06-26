import 'corner.dart';
import 'edge.dart';
import 'cube_color.dart';

class CubeState {
  final List<Corner> corners;
  final List<Edge> edges;

  CubeState({
    required this.corners,
    required this.edges,
  });

  factory CubeState.solved() {
    return CubeState(
      corners: [
        Corner(id: 0, colors: [CubeColor.white, CubeColor.red, CubeColor.green]),
        Corner(id: 1, colors: [CubeColor.white, CubeColor.green, CubeColor.orange]),
        Corner(id: 2, colors: [CubeColor.white, CubeColor.orange, CubeColor.blue]),
        Corner(id: 3, colors: [CubeColor.white, CubeColor.blue, CubeColor.red]),
        Corner(id: 4, colors: [CubeColor.yellow, CubeColor.green, CubeColor.red]),
        Corner(id: 5, colors: [CubeColor.yellow, CubeColor.orange, CubeColor.green]),
        Corner(id: 6, colors: [CubeColor.yellow, CubeColor.blue, CubeColor.orange]),
        Corner(id: 7, colors: [CubeColor.yellow, CubeColor.red, CubeColor.blue]),
      ],
      edges: [
        Edge(id: 0, colors: [CubeColor.white, CubeColor.green]),
        Edge(id: 1, colors: [CubeColor.white, CubeColor.red]),
        Edge(id: 2, colors: [CubeColor.white, CubeColor.blue]),
        Edge(id: 3, colors: [CubeColor.white, CubeColor.orange]),
        Edge(id: 4, colors: [CubeColor.green, CubeColor.red]),
        Edge(id: 5, colors: [CubeColor.green, CubeColor.orange]),
        Edge(id: 6, colors: [CubeColor.blue, CubeColor.orange]),
        Edge(id: 7, colors: [CubeColor.blue, CubeColor.red]),
        Edge(id: 8, colors: [CubeColor.yellow, CubeColor.green]),
        Edge(id: 9, colors: [CubeColor.yellow, CubeColor.red]),
        Edge(id: 10, colors: [CubeColor.yellow, CubeColor.blue]),
        Edge(id: 11, colors: [CubeColor.yellow, CubeColor.orange]),
      ],
    );
  }

  CubeState copy() {
    return CubeState(
      corners: corners.map((c) => c.copy()).toList(),
      edges: edges.map((e) => e.copy()).toList(),
    );
  }
}