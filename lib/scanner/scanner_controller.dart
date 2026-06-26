import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ScannerController extends ChangeNotifier {
  CameraController? cameraController;

  bool isInitialized = false;
  bool isFlashOn = false;
  bool isProcessing = false;

  Future<void> initialize() async {
    final cameras = await availableCameras();

    cameraController = CameraController(
      cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    await cameraController!.initialize();

    isInitialized = true;
    notifyListeners();
  }

  Future<void> toggleFlash() async {
    if (cameraController == null) return;

    isFlashOn = !isFlashOn;

    await cameraController!.setFlashMode(
      isFlashOn ? FlashMode.torch : FlashMode.off,
    );

    notifyListeners();
  }

  Future<void> disposeCamera() async {
    await cameraController?.dispose();
  }
}