import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class CameraService {
  CameraService._();

  static CameraController? _cameraController;
  static List<CameraDescription>? _cameras;
  static int _currentCameraIndex = 0;

  static CameraController? get controller => _cameraController;
  static List<CameraDescription>? get cachedCameras => _cameras;
  static bool get isInitialized =>
      _cameraController?.value.isInitialized ?? false;

  static Future<void> initialize() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      await _initializeCamera(_currentCameraIndex);
    }
  }

  static Future<void> _initializeCamera(int cameraIndex) async {
    if (_cameras == null || cameraIndex >= _cameras!.length) return;

    await _cameraController?.dispose();

    _cameraController = CameraController(
      _cameras![cameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    try {
      await _cameraController!.initialize();
    } catch (e) {
      if (kDebugMode) {
        print('Camera initialization error: $e');
      }
    }
  }

  static Future<void> switchCamera() async {
    if (_cameras == null || _cameras!.length <= 1) return;

    _currentCameraIndex = (_currentCameraIndex + 1) % _cameras!.length;
    await _initializeCamera(_currentCameraIndex);
  }

  static Future<String?> startRecording() async {
    if (!isInitialized) return null;

    try {
      final directory = await getTemporaryDirectory();
      final filePath = path.join(
        directory.path,
        'recording_${DateTime.now().millisecondsSinceEpoch}.mp4',
      );

      await _cameraController!.startVideoRecording();
      return filePath;
    } catch (e) {
      if (kDebugMode) {
        print('Error starting recording: $e');
      }
      return null;
    }
  }

  static Future<String?> stopRecording() async {
    if (!isInitialized) return null;

    try {
      final videoFile = await _cameraController!.stopVideoRecording();
      return videoFile.path;
    } catch (e) {
      if (kDebugMode) {
        print('Error stopping recording: $e');
      }
      return null;
    }
  }

  static Future<void> dispose() async {
    await _cameraController?.dispose();
    _cameraController = null;
  }
}
