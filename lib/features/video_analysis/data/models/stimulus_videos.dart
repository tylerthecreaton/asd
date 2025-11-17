import 'package:asd/features/video_analysis/domain/entities/stimulus_video.dart';

class StimulusVideos {
  const StimulusVideos._();

  static const List<StimulusVideo> videos = [
    StimulusVideo(
      id: 'peekaboo',
      title: 'Peek-a-Boo',
      description:
          'A classic peek-a-boo game to observe social engagement and eye contact',
      videoPath: 'assets/videos/stimuli/peekaboo.mp4',
      duration: 30,
      targetBehaviors: ['eye_contact', 'social_smile', 'joint_attention'],
      type: StimulusType.social,
    ),
    StimulusVideo(
      id: 'bubbles',
      title: 'Bubbles',
      description: 'Bubbles floating to observe visual tracking and attention',
      videoPath: 'assets/videos/stimuli/bubbles.mp4',
      duration: 25,
      targetBehaviors: ['visual_tracking', 'attention_span', 'pointing'],
      type: StimulusType.visual,
    ),
    StimulusVideo(
      id: 'music',
      title: 'Music and Sounds',
      description: 'Various sounds and music to observe auditory responses',
      videoPath: 'assets/videos/stimuli/music.mp4',
      duration: 35,
      targetBehaviors: [
        'sound_localization',
        'emotional_response',
        'vocalization',
      ],
      type: StimulusType.auditory,
    ),
    StimulusVideo(
      id: 'toys',
      title: 'Toy Demonstration',
      description:
          'Demonstration of toy play to observe imitation and interest',
      videoPath: 'assets/videos/stimuli/toys.mp4',
      duration: 40,
      targetBehaviors: ['imitation', 'object_interest', 'motor_skills'],
      type: StimulusType.interactive,
    ),
    StimulusVideo(
      id: 'name_call',
      title: 'Name Calling',
      description: 'Calling child\'s name to observe response and attention',
      videoPath: 'assets/videos/stimuli/name_call.mp4',
      duration: 20,
      targetBehaviors: ['name_response', 'eye_contact', 'attention'],
      type: StimulusType.auditory,
    ),
  ];
}
