import 'dart:io';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/stimulus_videos.dart';
import '../../domain/entities/stimulus_video.dart';
import '../../domain/entities/video_analysis_result.dart';
import '../../domain/entities/video_recording.dart';

final stimulusVideoListProvider = Provider<List<StimulusVideo>>(
  (ref) => StimulusVideos.videos,
);

final stimulusVideoProvider = FutureProvider.family<StimulusVideo, String>((
  ref,
  stimulusId,
) async {
  final videos = ref.read(stimulusVideoListProvider);
  return videos.firstWhere((video) => video.id == stimulusId);
});

class VideoAnalysisState {
  const VideoAnalysisState({
    this.recordings = const [],
    this.analysisResult = const AsyncValue.data(null),
    this.isUploading = false,
  });

  final List<VideoRecording> recordings;
  final AsyncValue<VideoAnalysisResult?> analysisResult;
  final bool isUploading;

  VideoAnalysisState copyWith({
    List<VideoRecording>? recordings,
    AsyncValue<VideoAnalysisResult?>? analysisResult,
    bool? isUploading,
  }) {
    return VideoAnalysisState(
      recordings: recordings ?? this.recordings,
      analysisResult: analysisResult ?? this.analysisResult,
      isUploading: isUploading ?? this.isUploading,
    );
  }
}

class VideoAnalysisNotifier extends StateNotifier<VideoAnalysisState> {
  VideoAnalysisNotifier() : super(const VideoAnalysisState());

  void saveRecording({
    required String stimulusVideoId,
    required String filePath,
    required int duration,
  }) {
    final file = File(filePath);
    final fileSize = file.existsSync() ? file.lengthSync() : 0;

    final recording = VideoRecording(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      filePath: filePath,
      stimulusVideoId: stimulusVideoId,
      recordedAt: DateTime.now(),
      duration: duration,
      fileSize: fileSize,
      status: VideoRecordingStatus.completed,
    );

    state = state.copyWith(recordings: [...state.recordings, recording]);
  }

  Future<VideoAnalysisResult> uploadVideo({
    required String filePath,
    required String stimulusVideoId,
  }) async {
    state = state.copyWith(
      isUploading: true,
      analysisResult: const AsyncValue.loading(),
    );

    try {
      await Future.delayed(const Duration(seconds: 2));

      final random = Random(stimulusVideoId.hashCode + filePath.hashCode);
      double generateScore() =>
          (random.nextDouble() * 40 + 60) / 100; // 0.60-1.00

      final engagement = generateScore();
      final responsiveness = generateScore();
      final sensory = generateScore();
      final overall = (engagement + responsiveness + sensory) / 3;

      final riskLevel = _mapScoreToRisk(overall);
      final relatedVideo = StimulusVideos.videos.firstWhere(
        (video) => video.id == stimulusVideoId,
        orElse: () => StimulusVideos.videos.first,
      );

      final result = VideoAnalysisResult(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        stimulusVideoId: stimulusVideoId,
        overallScore: overall,
        engagementScore: engagement,
        responsivenessScore: responsiveness,
        sensoryScore: sensory,
        riskLevel: riskLevel,
        detectedBehaviors: relatedVideo.targetBehaviors.take(3).toList(),
        recommendations: _recommendationsForRisk(riskLevel),
        summary:
            'Observed ${relatedVideo.title.toLowerCase()} stimulus with ${riskLevel.name} risk indicators.',
        analyzedAt: DateTime.now(),
      );

      state = state.copyWith(
        isUploading: false,
        analysisResult: AsyncValue.data(result),
      );

      return result;
    } catch (error, stackTrace) {
      state = state.copyWith(
        isUploading: false,
        analysisResult: AsyncValue.error(error, stackTrace),
      );
      rethrow;
    }
  }

  RiskLevel _mapScoreToRisk(double score) {
    if (score >= 0.8) return RiskLevel.low;
    if (score >= 0.7) return RiskLevel.moderate;
    return RiskLevel.high;
  }

  List<String> _recommendationsForRisk(RiskLevel risk) {
    switch (risk) {
      case RiskLevel.low:
        return [
          'Maintain consistent social play routines.',
          'Re-run the video assessment in 2-3 months.',
        ];
      case RiskLevel.moderate:
        return [
          'Introduce guided activities focusing on joint attention.',
          'Consider consulting a developmental specialist.',
        ];
      case RiskLevel.high:
        return [
          'Schedule a comprehensive evaluation with a clinician.',
          'Share recorded sessions with your pediatrician.',
          'Begin a structured observation log for daily behaviors.',
        ];
    }
  }
}

final videoAnalysisProvider =
    StateNotifierProvider<VideoAnalysisNotifier, VideoAnalysisState>(
      (ref) => VideoAnalysisNotifier(),
    );

final videoAnalysisResultsProvider = Provider<AsyncValue<VideoAnalysisResult?>>(
  (ref) => ref.watch(videoAnalysisProvider).analysisResult,
);
