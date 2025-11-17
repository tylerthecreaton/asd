import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../domain/entities/stimulus_video.dart';

class StimulusVideoPlayer extends StatefulWidget {
  const StimulusVideoPlayer({
    super.key,
    required this.video,
    required this.onPlaybackCompleted,
  });

  final StimulusVideo video;
  final VoidCallback onPlaybackCompleted;

  @override
  State<StimulusVideoPlayer> createState() => _StimulusVideoPlayerState();
}

class _StimulusVideoPlayerState extends State<StimulusVideoPlayer> {
  late final VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasCompleted = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.video.videoPath)
      ..setLooping(false)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller.play();
      });

    _controller.addListener(_handlePlaybackState);
  }

  void _handlePlaybackState() {
    if (_controller.value.isInitialized &&
        !_controller.value.isPlaying &&
        _controller.value.position >= _controller.value.duration &&
        !_hasCompleted) {
      _hasCompleted = true;
      widget.onPlaybackCompleted();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handlePlaybackState);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
        const SizedBox(height: 12),
        _PlaybackControls(controller: _controller),
        const SizedBox(height: 8),
        Text(
          widget.video.title,
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          widget.video.description,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _PlaybackControls extends StatefulWidget {
  const _PlaybackControls({required this.controller});

  final VideoPlayerController controller;

  @override
  State<_PlaybackControls> createState() => _PlaybackControlsState();
}

class _PlaybackControlsState extends State<_PlaybackControls> {
  late final VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _listener = () => setState(() {});
    widget.controller.addListener(_listener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
          ),
          child: Slider(
            min: 0,
            max: controller.value.duration.inMilliseconds.toDouble(),
            value: controller.value.position.inMilliseconds
                .clamp(0, controller.value.duration.inMilliseconds)
                .toDouble(),
            onChanged: (value) {
              controller.seekTo(Duration(milliseconds: value.toInt()));
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
              onPressed: () {
                if (controller.value.isPlaying) {
                  controller.pause();
                } else {
                  controller.play();
                }
              },
            ),
            Text(
              _formatPosition(
                controller.value.position,
                controller.value.duration,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatPosition(Duration position, Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final positionMinutes = twoDigits(position.inMinutes.remainder(60));
    final positionSeconds = twoDigits(position.inSeconds.remainder(60));
    final durationMinutes = twoDigits(duration.inMinutes.remainder(60));
    final durationSeconds = twoDigits(duration.inSeconds.remainder(60));

    return '$positionMinutes:$positionSeconds / $durationMinutes:$durationSeconds';
  }
}
