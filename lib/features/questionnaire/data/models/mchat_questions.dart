import 'package:asd/features/questionnaire/domain/entities/question.dart';
import 'package:asd/features/questionnaire/domain/entities/questionnaire.dart';

class MChatQuestions {
  const MChatQuestions._();

  static const Questionnaire questionnaire = Questionnaire(
    id: 'mchat',
    title: 'M-CHAT',
    description: 'Modified Checklist for Autism in Toddlers',
    questions: [
      Question(
        id: 'q1',
        text: 'Does your child enjoy being swung, bounced on your knee, etc.?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q2',
        text: 'Does your child take interest in other children?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q3',
        text: 'Does your child like climbing on things, such as up stairs?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q4',
        text: 'Does your child enjoy playing peek-a-boo/hide-and-seek?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q5',
        text:
            'Does your child ever pretend, for example, to talk on the phone or take care of a doll or pretend other things?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q6',
        text:
            'Does your child ever use his/her index finger to point, to ask for something?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q7',
        text:
            'Does your child ever use his/her index finger to point, to indicate interest in something?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q8',
        text:
            'Can your child play properly with small toys (e.g., cars or bricks) without just mouthing, fiddling, or dropping them?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q9',
        text:
            'Does your child ever bring objects over to you (parent) to show you something?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q10',
        text:
            'Does your child look you in the eye for more than a second or two?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q11',
        text:
            'Does your child ever seem oversensitive to noise? (e.g., plugging ears)',
        options: ['Yes', 'No'],
        correctAnswerIndex: 1,
      ),
      Question(
        id: 'q12',
        text: 'Does your child smile in response to your face or your smile?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q13',
        text:
            'Does your child imitate you? (e.g., you make a face-will your child imitate it?)',
        options: ['Yes', 'No'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q14',
        text:
            'Does your child respond to his/her name when you call their name?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q15',
        text:
            'If you point at a toy across the room, does your child look at it?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q16',
        text: 'Does your child walk?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q17',
        text: 'Does your child look at things you are looking at?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q18',
        text:
            'Does your child make unusual finger movements near his/her face?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 1,
      ),
      Question(
        id: 'q19',
        text:
            'Does your child try to attract your attention to his/her own activity?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q20',
        text: 'Have you ever wondered if your child is deaf?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 1,
      ),
      Question(
        id: 'q21',
        text: 'Does your child understand what people say?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q22',
        text:
            'Does your child sometimes stare at nothing or wander with no purpose?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 1,
      ),
      Question(
        id: 'q23',
        text:
            'Does your child look at your face to check your reaction when faced with something unfamiliar?',
        options: ['Yes', 'No'],
        correctAnswerIndex: 0,
      ),
    ],
    passingScore: 3,
  );
}
