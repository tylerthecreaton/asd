import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_constants.dart';
import '../../../../core/services/camera_service.dart';
import '../../domain/entities/stimulus_video.dart';
import '../providers/video_analysis_provider.dart';
import '../widgets/camera_preview.dart';
import '../widgets/recording_controls.dart';
import '../widgets/stimulus_video_player.dart';
import 'video_preview_page.dart';

class VideoRecordingPage extends ConsumerStatefulWidget {
  const VideoRecordingPage({super.key, required this.stimulusVideoId});

  final String stimulusVideoId;

  @override
  ConsumerState<VideoRecordingPage> createState() => _VideoRecordingPageState();
}

class _VideoRecordingPageState extends ConsumerState<VideoRecordingPage>
    with WidgetsBindingObserver {
  bool _isRecording = false;
  bool _isStimulusPlaying = false;
  int _recordingDuration = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    unawaited(CameraService.dispose());
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      unawaited(CameraService.dispose());
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    await CameraService.initialize();
    if (mounted) setState(() {});
  }

  Future<void> _startRecording() async {
    if (_isRecording || !CameraService.isInitialized) return;

    await CameraService.startRecording();

    setState(() {
      _isRecording = true;
      _recordingDuration = 0;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _recordingDuration++;
      });
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _isStimulusPlaying = true;
      });
    });
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;

    _timer?.cancel();

    String? recordedPath;
    if (CameraService.isInitialized) {
      recordedPath = await CameraService.stopRecording();
    }

    setState(() {
      _isRecording = false;
      _isStimulusPlaying = false;
    });

    if (recordedPath == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to access recorded video.')),
      );
      return;
    }

    ref
        .read(videoAnalysisProvider.notifier)
        .saveRecording(
          stimulusVideoId: widget.stimulusVideoId,
          filePath: recordedPath,
          duration: _recordingDuration,
        );

    if (!mounted) return;
    context.push(
      RouteConstants.videoPreview,
      extra: VideoPreviewPageArgs(
        recordingPath: recordedPath,
        stimulusVideoId: widget.stimulusVideoId,
        duration: _recordingDuration,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stimulusVideoAsync = ref.watch(
      stimulusVideoProvider(widget.stimulusVideoId),
    );

    return stimulusVideoAsync.when(
      data: (stimulusVideo) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text(
              stimulusVideo.title,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child:
                    CameraService.isInitialized &&
                        CameraService.controller != null
                    ? CameraPreviewWidget(controller: CameraService.controller!)
                    : const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
              ),
              if (_isStimulusPlaying)
                Positioned(
                  top: 80,
                  right: 16,
                  child: SizedBox(
                    width: 200,
                    child: StimulusVideoPlayer(
                      video: stimulusVideo,
                      onPlaybackCompleted: () {
                        setState(() {
                          _isStimulusPlaying = false;
                        });
                      },
                    ),
                  ),
                ),
              if (!_isRecording)
                Positioned(
                  top: 80,
                  left: 16,
                  right: 16,
                  child: _RecordingInstructions(video: stimulusVideo),
                ),
              Positioned(
                bottom: 48,
                left: 0,
                right: 0,
                child: RecordingControls(
                  isRecording: _isRecording,
                  recordingDuration: _recordingDuration,
                  onStartRecording: _startRecording,
                  onStopRecording: _stopRecording,
                  onSwitchCamera: () async {
                    await CameraService.switchCamera();
                    if (mounted) setState(() {});
                  },
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      ),
      error: (error, stackTrace) => Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'Error loading video',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _RecordingInstructions extends StatelessWidget {
  const _RecordingInstructions({required this.video});

  final StimulusVideo video;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recording Instructions',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Stimulus: ${video.title}\nDuration: ${video.duration} seconds',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          const Text(
            '1. Frame the child with face and torso visible\n'
            '2. Ensure calm environment with good lighting\n'
            '3. Press record when ready, then follow on-screen prompt',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
