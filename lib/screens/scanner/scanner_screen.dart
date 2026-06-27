import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:rubiksolve_pro/widgets/face_progress.dart';
import 'package:rubiksolve_pro/scanner/color_classifier.dart';
import 'package:rubiksolve_pro/scanner/color_sampler.dart';
import 'package:rubiksolve_pro/scanner/frame_processor.dart';
import 'package:rubiksolve_pro/scanner/stability_filter.dart';

import 'package:rubiksolve_pro/widgets/scanner_mask.dart';
import 'package:rubiksolve_pro/widgets/scanner_overlay.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  CameraController? _controller;

  bool _loading = true;
  bool _flash = false;
  bool _isProcessing = false;

  final StabilityFilter _stabilityFilter = StabilityFilter();

  List<Color> _sampleColors = List.generate(
    9,
    (_) => Colors.grey,
  );

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

    await _controller!.startImageStream((CameraImage image) {
      if (_isProcessing) return;

      _isProcessing = true;
      _processFrame(image);
    });

    if (!mounted) return;

    setState(() {
      _loading = false;
    });
  }

  Future<void> _processFrame(CameraImage image) async {
    final frame = FrameProcessor.process(image);

    if (frame != null) {
      final sampled = ColorSampler.sample3x3(
        frame,
        Rect.fromCenter(
          center: Offset(
            frame.width / 2,
            frame.height / 2,
          ),
          width: frame.width * 0.35,
          height: frame.width * 0.35,
        ),
      );

      final classified = ColorClassifier.classifyAll(sampled);

      final stable = _stabilityFilter.add(classified);

      if (stable != null && mounted) {
        setState(() {
          _sampleColors = stable;
        });
      }
    }

    _isProcessing = false;
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
    if (_controller != null &&
        _controller!.value.isStreamingImages) {
      _controller!.stopImageStream();
    }

    _controller?.dispose();

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
              scannedFaces: 1,
            ),
          ),

          ScannerOverlay(
            detected: true,
            sampleColors: _sampleColors,
          ),

          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton.large(
                onPressed: () {},
                child: const Icon(Icons.camera_alt),
              ),
            ),
          ),
        ],
      ),
    );
  }
}