import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/constants/route_constants.dart';
import '../../../common/widgets/custom_button.dart';
import '../providers/video_analysis_provider.dart';

class VideoPreviewPageArgs {
  const VideoPreviewPageArgs({
    required this.recordingPath,
    required this.stimulusVideoId,
    required this.duration,
  });

  final String recordingPath;
  final String stimulusVideoId;
  final int duration;
}

class VideoPreviewPage extends ConsumerStatefulWidget {
  const VideoPreviewPage({super.key, required this.args});

  final VideoPreviewPageArgs args;

  @override
  ConsumerState<VideoPreviewPage> createState() => _VideoPreviewPageState();
}

class _VideoPreviewPageState extends ConsumerState<VideoPreviewPage> {
  late final VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.args.recordingPath))
      ..setLooping(true)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _uploadVideo() async {
    setState(() => _isUploading = true);

    try {
      await ref
          .read(videoAnalysisProvider.notifier)
          .uploadVideo(
            filePath: widget.args.recordingPath,
            stimulusVideoId: widget.args.stimulusVideoId,
          );
      if (!mounted) return;
      context.go(RouteConstants.videoAnalysisResults);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Upload failed: $error')));
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  void _togglePlayback() {
    if (!_isInitialized) return;
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final stimulusVideoAsync = ref.watch(
      stimulusVideoProvider(widget.args.stimulusVideoId),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Preview Recording',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: _isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            VideoPlayer(_controller),
                            VideoProgressIndicator(
                              _controller,
                              allowScrubbing: true,
                              colors: VideoProgressColors(
                                playedColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const CircularProgressIndicator(color: Colors.white),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.white70),
                          children: [
                            const TextSpan(text: 'Duration: '),
                            TextSpan(
                              text: _formatDuration(widget.args.duration),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: _togglePlayback,
                        iconSize: 48,
                        icon: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause_circle
                              : Icons.play_circle,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  stimulusVideoAsync.when(
                    data: (video) => Text(
                      'Stimulus: ${video.title}',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Retake',
                          buttonType: ButtonType.outlined,
                          onPressed: _isUploading
                              ? null
                              : () {
                                  context.pop();
                                },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomButton(
                          text: 'Upload for Analysis',
                          onPressed: _isUploading ? null : _uploadVideo,
                          isLoading: _isUploading,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
