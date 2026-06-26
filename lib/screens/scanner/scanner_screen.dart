import 'package:camera/camera.dart';
import 'package:rubiksolve_pro/widgets/scanner_overlay.dart';
import 'package:rubiksolve_pro/widgets/scanner_mask.dart';
import 'package:flutter/material.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  CameraController? _controller;
  bool _loading = true;
  bool _flash = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();

    _controller = CameraController(
      cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller!.initialize();

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

    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Widget _buildGrid() {
    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 9,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (_, index) {
          return Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          );
        },
      ),
    );
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
          const ScannerOverlay(),

          Center(
            child: SizedBox(
              width: 300,
              height: 300,
              child: _buildGrid(),
            ),
          ),

          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton.large(
                onPressed: () {
                  // Capture will be added next
                },
                child: const Icon(Icons.camera_alt),
              ),
            ),
          ),
        ],
      ),
    );
  }
}