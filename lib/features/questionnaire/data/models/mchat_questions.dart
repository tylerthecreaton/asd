import 'package:asd/features/questionnaire/domain/entities/question.dart';
import 'package:asd/features/questionnaire/domain/entities/questionnaire.dart';

class MChatQuestions {
  const MChatQuestions._();

  static const Questionnaire questionnaire = Questionnaire(
    id: 'mchat',
    slug: 'mchat',
    title: 'M-CHAT',
    description:
        'แบบคัดกรองออทิสติกสำหรับเด็กเล็ก (Modified Checklist for Autism in Toddlers)',
    questions: [
      Question(
        id: 'q1',
        text: 'ลูกของคุณชอบให้โยกตัว หรือสนุกเวลาถูกเล่นกระโดดบนตักของคุณไหม?',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q2',
        text: 'ลูกของคุณสนใจเด็กคนอื่นไหม? เช่น มอง เล่นด้วย หรือเข้าไปหา',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q3',
        text: 'ลูกของคุณชอบปีนขึ้นสิ่งต่างๆ เช่น บันได หรือเฟอร์นิเจอร์ไหม?',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q4',
        text: 'ลูกของคุณสนุกกับการเล่นซ่อนหา หรือเกมอุ๊ยอุ๊ย (peek-a-boo) ไหม?',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q5',
        text:
            'ลูกของคุณเคยเล่นแบบเลียนแบบ เช่น แกล้งโทรศัพท์ เล่นตุ๊กตา หรือเล่นสมมติอื่นๆ ไหม?',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q6',
        text: 'ลูกของคุณเคยใช้นิ้วชี้เพื่อขอสิ่งที่ต้องการไหม?',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q7',
        text: 'ลูกของคุณเคยใช้นิ้วชี้เพื่อแสดงสิ่งที่สนใจหรือชวนให้คุณดูไหม?',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q8',
        text:
            'ลูกของคุณสามารถเล่นของเล่นชิ้นเล็กอย่างเหมาะสม ไม่ใช่แค่เอาเข้าปากหรือปัดทิ้ง ใช่ไหม?',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q9',
        text: 'ลูกของคุณเคยหยิบสิ่งของมาให้คุณเพื่อแบ่งปันหรือให้ดูไหม?',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q10',
        text: 'ลูกของคุณสามารถสบตากับคุณได้นานมากกว่า 1–2 วินาทีไหม?',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q11',
        text:
            'ลูกของคุณไวต่อเสียงมากผิดปกติไหม? เช่น ชอบอุดหูเวลาได้ยินเสียงดัง',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 1,
      ),
      Question(
        id: 'q12',
        text: 'ลูกของคุณยิ้มตอบเมื่อเห็นใบหน้าหรือรอยยิ้มของคุณไหม?',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q13',
        text: 'ลูกของคุณเคยเลียนแบบคุณไหม? เช่น คุณทำท่าอะไร เขาทำตาม',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q14',
        text:
            'เมื่อตามชื่อลูก เขามักจะตอบสนองไหม? เช่น หันมามองหรือแสดงว่ารับรู้',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q15',
        text: 'ถ้าคุณชี้ไปที่ของเล่นไกลๆ ลูกของคุณมองตามไหม?',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q16',
        text: 'ลูกของคุณเดินได้แล้วหรือยัง?',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q17',
        text: 'ลูกของคุณสามารถมองตามสิ่งที่คุณกำลังมองหรือชี้ได้ไหม?',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q18',
        text:
            'ลูกของคุณมีการเคลื่อนไหวของนิ้วหรือมือแบบผิดปกติใกล้ใบหน้าไหม? เช่น โบกนิ้วตรงหน้า',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 1,
      ),
      Question(
        id: 'q19',
        text: 'ลูกของคุณเคยพยายามดึงความสนใจของคุณให้ดูสิ่งที่เขากำลังทำไหม?',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q20',
        text: 'คุณเคยสงสัยว่าลูกของคุณอาจหูตึงหรือไม่ได้ยินไหม?',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 1,
      ),
      Question(
        id: 'q21',
        text: 'ลูกของคุณเข้าใจเวลาที่คนอื่นพูดกับเขาไหม?',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q22',
        text: 'ลูกของคุณเคยจ้องมองอากาศ หรือเดินไปมาโดยไม่มีจุดหมายไหม?',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 1,
      ),
      Question(
        id: 'q23',
        text:
            'เมื่อลูกเจอสิ่งใหม่ๆ เขามักจะมองหน้าคุณเพื่อตรวจสอบปฏิกิริยาของคุณไหม?',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 0,
      ),
    ],
    passingScore: 3,
  );
}
