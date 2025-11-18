import 'package:asd/features/video_analysis/domain/entities/stimulus_video.dart';

class StimulusVideos {
  const StimulusVideos._();

  static const List<StimulusVideo> videos = [
    StimulusVideo(
      id: 'peekaboo',
      title: 'ซ่อนหา',
      description:
          'เกมซ่อนหาแบบคลาสสิกเพื่อสังเกตการมีส่วนร่วมทางสังคมและการสบตา',
      videoPath: 'assets/videos/stimuli/peekaboo.mp4',
      duration: 30,
      targetBehaviors: ['การสบตา', 'รอยยิ้มทางสังคม', 'ความสนใจร่วม'],
      type: StimulusType.social,
    ),
    StimulusVideo(
      id: 'bubbles',
      title: 'ฟองสบู่',
      description: 'ฟองสบู่ลอยเพื่อสังเกตการติดตามสายตาและความสนใจ',
      videoPath: 'assets/videos/stimuli/bubbles.mp4',
      duration: 25,
      targetBehaviors: ['การติดตามสายตา', 'ความยาวของความสนใจ', 'การชี้นิ้ว'],
      type: StimulusType.visual,
    ),
    StimulusVideo(
      id: 'music',
      title: 'ดนตรีและเสียง',
      description: 'เสียงและดนตรีต่างๆ เพื่อสังเกตการตอบสนองทางหู',
      videoPath: 'assets/videos/stimuli/music.mp4',
      duration: 35,
      targetBehaviors: [
        'การระบุตำแหน่งเสียง',
        'การตอบสนองทางอารมณ์',
        'การเปล่งเสียง',
      ],
      type: StimulusType.auditory,
    ),
    StimulusVideo(
      id: 'toys',
      title: 'การสาธิตของเล่น',
      description: 'การสาธิตการเล่นของเล่นเพื่อสังเกตการเลียนแบบและความสนใจ',
      videoPath: 'assets/videos/stimuli/toys.mp4',
      duration: 40,
      targetBehaviors: ['การเลียนแบบ', 'ความสนใจในวัตถุ', 'ทักษะการเคลื่อนไหว'],
      type: StimulusType.interactive,
    ),
    StimulusVideo(
      id: 'name_call',
      title: 'การเรียกชื่อ',
      description: 'การเรียกชื่อเด็กเพื่อสังเกตการตอบสนองและความสนใจ',
      videoPath: 'assets/videos/stimuli/name_call.mp4',
      duration: 20,
      targetBehaviors: ['การตอบสนองต่อชื่อ', 'การสบตา', 'ความสนใจ'],
      type: StimulusType.auditory,
    ),
  ];
}
