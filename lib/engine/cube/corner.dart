import 'cube_color.dart';

class Corner {
  final int id;

  int orientation;

  List<CubeColor> colors;

  Corner({
    required this.id,
    required this.colors,
    this.orientation = 0,
  });

  Corner copy() {
    return Corner(
      id: id,
      colors: List.from(colors),
      orientation: orientation,
    );
  }
}