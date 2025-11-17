import 'package:equatable/equatable.dart';

class StimulusVideo extends Equatable {
  const StimulusVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.videoPath,
    required this.duration,
    required this.targetBehaviors,
    required this.type,
  });

  final String id;
  final String title;
  final String description;
  final String videoPath;
  final int duration;
  final List<String> targetBehaviors;
  final StimulusType type;

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    videoPath,
    duration,
    targetBehaviors,
    type,
  ];
}

enum StimulusType { social, auditory, visual, interactive }
