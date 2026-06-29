import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:rubiksolve_pro/scanner/scanner_controller.dart';

import 'package:rubiksolve_pro/widgets/face_progress.dart';
import 'package:rubiksolve_pro/widgets/scanner_mask.dart';
import 'package:rubiksolve_pro/widgets/scanner_overlay.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final ScannerController _scanner = ScannerController();

  CameraController? _controller;

  bool _loading = true;
  bool _flash = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();

    _controller = CameraController(
      cameras.first,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    await _controller!.initialize();

    await _controller!.startImageStream((image) {
      if (_isProcessing) return;

      _isProcessing = true;

      _scanner.process(image).whenComplete(() {
        _isProcessing = false;
      });
    });

    if (!mounted) return;

    setState(() {
      _loading = false;
    });
  }

  Future<void> _toggleFlash() async {
    if (_controller == null) return;

    _flash = !_flash;

    await _controller!.setFlashMode(
      _flash ? FlashMode.torch : FlashMode.off,
    );

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _scanner.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  if (_loading || _controller == null) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  return AnimatedBuilder(
    animation: _scanner,
    builder: (context, _) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Scan Cube"),
          actions: [
            IconButton(
              onPressed: _toggleFlash,
              icon: Icon(
                _flash ? Icons.flash_on : Icons.flash_off,
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: CameraPreview(_controller!),
            ),

            const ScannerMask(),

            Positioned(
              top: 10,
              left: 0,
              right: 0,
              child: FaceProgress(
                      scannedFaces: _scanner.scannedFaces,
                    ),
            ),

            ScannerOverlay(
              detected: _scanner.detected,
              sampleColors: _scanner.sampleColors,
            ),
          ],
        ),
      );
    },
  );
}
}