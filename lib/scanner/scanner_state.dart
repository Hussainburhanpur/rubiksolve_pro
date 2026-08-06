import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ScannerState {
  final CameraController? camera;

  final bool loading;
  final bool processing;
  final bool flash;

  final bool detected;
  final bool geometryValid;

  final List<Color> sampleColors;

  const ScannerState({
    this.camera,
    this.loading = true,
    this.processing = false,
    this.flash = false,
    this.detected = false,
    this.geometryValid = false,
    this.sampleColors = const [],
  });

  ScannerState copyWith({
    CameraController? camera,
    bool? loading,
    bool? processing,
    bool? flash,
    bool? detected,
    bool? geometryValid,
    List<Color>? sampleColors,
  }) {
    return ScannerState(
      camera: camera ?? this.camera,
      loading: loading ?? this.loading,
      processing: processing ?? this.processing,
      flash: flash ?? this.flash,
      detected: detected ?? this.detected,
      geometryValid: geometryValid ?? this.geometryValid,
      sampleColors: sampleColors ?? this.sampleColors,
    );
  }
}