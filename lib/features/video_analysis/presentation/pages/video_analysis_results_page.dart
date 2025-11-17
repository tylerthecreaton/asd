import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_constants.dart';
import '../../../common/widgets/custom_button.dart';
import '../../domain/entities/stimulus_video.dart';
import '../providers/video_analysis_provider.dart';
import '../widgets/analysis_summary.dart';

class VideoAnalysisResultsPage extends ConsumerWidget {
  const VideoAnalysisResultsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisState = ref.watch(videoAnalysisResultsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Analysis Results'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () => _shareResults(context),
          ),
        ],
      ),
      body: analysisState.when(
        data: (result) {
          if (result == null) {
            return _EmptyResults(onBack: () => context.go(RouteConstants.home));
          }

          final stimulusVideo = _resolveStimulusVideo(
            ref,
            result.stimulusVideoId,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnalysisSummary(result: result, stimulusVideo: stimulusVideo),
                const SizedBox(height: 24),
                _DisclaimerCard(),
                const SizedBox(height: 24),
                const _ActionButtons(),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _ErrorState(
          message: 'We could not load the analysis results. Please try again.',
          onRetry: () => context.pop(),
        ),
      ),
    );
  }

  StimulusVideo? _resolveStimulusVideo(WidgetRef ref, String id) {
    final videos = ref.read(stimulusVideoListProvider);
    try {
      return videos.firstWhere((video) => video.id == id);
    } catch (_) {
      return null;
    }
  }

  void _shareResults(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sharing not implemented in this demo.')),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          text: 'View Detailed Report',
          onPressed: () =>
              _showPlaceholder(context, 'Detailed report coming soon.'),
        ),
        const SizedBox(height: 12),
        CustomButton(
          text: 'Schedule Consultation',
          buttonType: ButtonType.outlined,
          onPressed: () => _showPlaceholder(
            context,
            'Consultation scheduling will be available in a future release.',
          ),
        ),
        const SizedBox(height: 12),
        CustomButton(
          text: 'Return Home',
          buttonType: ButtonType.text,
          onPressed: () => context.go(RouteConstants.home),
        ),
      ],
    );
  }

  void _showPlaceholder(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _DisclaimerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Important Disclaimer',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'The automated analysis provides preliminary insights only and is not a clinical diagnosis. '
              'Please share these results with a qualified professional for follow-up evaluation.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.video_library_outlined, size: 64),
          const SizedBox(height: 16),
          const Text('No analysis results available yet.'),
          const SizedBox(height: 16),
          CustomButton(text: 'Back', onPressed: onBack),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 56, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            CustomButton(text: 'Try Again', onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
