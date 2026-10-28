# RubiSolve Learning-only 3D cube copy

This is a separate copy of the existing 3D cube model and all its dependencies.
The copied view widget is renamed `LearningCube3DView`, so it can coexist with
`Cube3DView` without touching Playback.

Included: camera.dart, cube_renderer.dart, cube3d_view.dart, cube3d.dart,
cubie.dart, face3d.dart, mesh.dart, projection.dart.

Copy this folder to `lib/learning_cube/` in the Flutter project. In
`beginner_tutorial_screen.dart`, import `learning_cube/cube3d_view.dart` and
replace `Cube3DView` / `Cube3DViewState` references with
`LearningCube3DView` / `LearningCube3DViewState`.

Note: the existing model maps U=white and D=yellow. A learning-only view can
set a separate camera orientation to show yellow on top without changing the
cube's logical face colours or move semantics. The tutorial still needs to
supply the appropriate initial cube state and verified move sequence.
