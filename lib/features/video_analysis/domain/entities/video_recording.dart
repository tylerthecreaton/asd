import 'package:equatable/equatable.dart';

class VideoRecording extends Equatable {
  const VideoRecording({
    required this.id,
    required this.filePath,
    required this.stimulusVideoId,
    required this.recordedAt,
    required this.duration,
    required this.fileSize,
    required this.status,
  });

  final String id;
  final String filePath;
  final String stimulusVideoId;
  final DateTime recordedAt;
  final int duration;
  final int fileSize;
  final VideoRecordingStatus status;

  @override
  List<Object?> get props => [
    id,
    filePath,
    stimulusVideoId,
    recordedAt,
    duration,
    fileSize,
    status,
  ];
}

enum VideoRecordingStatus { recording, completed, processing, uploaded, failed }
