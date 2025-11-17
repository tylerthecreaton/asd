import 'package:flutter/material.dart';

class RecordingControls extends StatelessWidget {
  const RecordingControls({
    super.key,
    required this.isRecording,
    required this.recordingDuration,
    required this.onStartRecording,
    required this.onStopRecording,
    required this.onSwitchCamera,
  });

  final bool isRecording;
  final int recordingDuration;
  final VoidCallback onStartRecording;
  final VoidCallback onStopRecording;
  final VoidCallback onSwitchCamera;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isRecording) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Recording ${_formatDuration(recordingDuration)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (!isRecording)
              IconButton(
                onPressed: onSwitchCamera,
                icon: const Icon(
                  Icons.flip_camera_ios,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            GestureDetector(
              onTap: isRecording ? onStopRecording : onStartRecording,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: isRecording ? Colors.red : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: isRecording
                    ? const Icon(Icons.stop, color: Colors.white, size: 40)
                    : null,
              ),
            ),
            if (!isRecording) const SizedBox(width: 64),
          ],
        ),
      ],
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
