import 'package:asd/features/questionnaire/domain/entities/question.dart';
import 'package:asd/features/questionnaire/domain/entities/questionnaire.dart';

class MChatQuestions {
  const MChatQuestions._();

  static const Questionnaire questionnaire = Questionnaire(
    id: 'mchat',
    title: 'M-CHAT',
    description: 'แบบคัดกรองออทิสติกแก้ไขสำหรับเด็กเล็ก (Modified Checklist for Autism in Toddlers)',
    questions: [
      Question(
        id: 'q1',
        text: 'ลูกของคุณสนุกกับการถูกโยกไปมา หรือถูกกระโดดบนหัวเข่าของคุณหรือไม่?',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q2',
        text: 'ลูกของคุณสนใจเด็กคนอื่นๆ หรือไม่?',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q3',
        text: 'ลูกของคุณชอบปีนขึ้นไปบนสิ่งต่างๆ เช่น ขั้นบันไดหรือไม่?',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q4',
        text: 'ลูกของคุณสนุกกับการเล่นซ่อนหาหรือเกมอุ๊ยอุ๊ย (peek-a-boo) หรือไม่?',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q5',
        text:
            'ลูกของคุณเคยแสดงการเล่นแบบจำลองหรือไม่ เช่น แกล้งโทรศัพท์ ดูแลตุ๊กตา หรือแกล้งทำสิ่งอื่นๆ?',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q6',
        text:
            'ลูกของคุณเคยใช้นิ้วชี้เพื่อขอสิ่งที่ต้องการหรือไม่?',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q7',
        text:
            'ลูกของคุณเคยใช้นิ้วชี้เพื่อแสดงความสนใจในสิ่งต่างๆ หรือไม่?',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q8',
        text:
            'ลูกของคุณสามารถเล่นของเล่นขนาดเล็ก (เช่น รถยนต์ หรือตัวต่อ) อย่างเหมาะสมโดยไม่ใช่แค่เอาเข้าปาก คลึงแค่ หรือทำทิ้งหรือไม่?',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q9',
        text:
            'ลูกของคุณเคยนำสิ่งของมาให้คุณ (ผู้ปกครอง) เพื่อแสดงสิ่งนั้นๆ หรือไม่?',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q10',
        text:
            'ลูกของคุณจะสบสายตากับคุณนานกว่าหนึ่งหรือสองวินาทีหรือไม่?',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q11',
        text:
            'ลูกของคุณดูเหมือนจะรู้สึกไวต่อเสียงมากเกินไปหรือไม่? (เช่น อุดหู)',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 1,
      ),
      Question(
        id: 'q12',
        text: 'ลูกของคุณจะยิ้มตอบสนองเมื่อเห็นใบหน้าหรือรอยยิ้มของคุณหรือไม่?',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q13',
        text:
            'ลูกของคุณเลียนแบบคุณหรือไม่? (เช่น คุณทำหน้า ลูกของคุณจะทำตามหรือไม่?)',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q14',
        text:
            'เมื่อคุณเรียกชื่อลูก ลูกของคุณจะตอบสนองหรือไม่?',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q15',
        text:
            'ถ้าคุณชี้ไปที่ของเล่นข้างห้อง ลูกของคุณจะมองไปที่ของเล่นนั้นหรือไม่?',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q16',
        text: 'ลูกของคุณเดินได้หรือไม่?',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q17',
        text: 'ลูกของคุณจะมองตามสิ่งที่คุณกำลังมองหรือไม่?',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q18',
        text:
            'ลูกของคุณมีการเคลื่อนไหวนิ้วที่ผิดปกติใกล้ใบหน้าหรือไม่?',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 1,
      ),
      Question(
        id: 'q19',
        text:
            'ลูกของคุณพยายามดึงดูดความสนใจของคุณไปยังกิจกรรมของตัวเองหรือไม่?',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q20',
        text: 'คุณเคยสงสัยว่าลูกของคุณหูหนวกหรือไม่?',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 1,
      ),
      Question(
        id: 'q21',
        text: 'ลูกของคุณเข้าใจสิ่งที่ผู้อื่นพูดหรือไม่?',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'q22',
        text:
            'ลูกของคุณบางครั้งจะจ้องมองไปที่อากาศหรือเดินไปมาโดยไม่มีจุดหมายหรือไม่?',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 1,
      ),
      Question(
        id: 'q23',
        text:
            'เมื่อเผชิญกับสิ่งที่ไม่คุ้นเคย ลูกของคุณจะมองหน้าคุณเพื่อตรวจสอบปฏิกิริยาของคุณหรือไม่?',
        options: ['ใช่', 'ไม่ใช่'],
        correctAnswerIndex: 0,
      ),
    ],
    passingScore: 3,
  );
}
