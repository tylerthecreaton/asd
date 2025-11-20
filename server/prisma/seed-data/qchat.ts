export type QChatSeedQuestion = {
  externalId: string;
  text: string;
  options: string[];
  scoringType: string;
  maxPoints: number;
  displayOrder: number;
  description?: string | null;
};

export type QChatSeedQuestionnaire = {
  slug: string;
  title: string;
  description: string;
  type: string;
  maxScore: number;
  questions: QChatSeedQuestion[];
};

const qChatQuestions: Omit<QChatSeedQuestion, "displayOrder">[] = [
  {
    externalId: "q1",
    text: "ลูกของคุณชอบให้คนอื่นสัมผัสตัวหรือกอดหรือไม่?",
    options: ["ไม่เคย/น้อยมาก", "บางครั้ง", "มักจะ/เสมอ"],
    scoringType: "qchat",
    maxPoints: 2,
  },
  {
    externalId: "q2",
    text: "ลูกของคุณแสดงความสนใจต่อคนรอบข้างหรือไม่?",
    options: ["ไม่เคย/น้อยมาก", "บางครั้ง", "มักจะ/เสมอ"],
    scoringType: "qchat",
    maxPoints: 2,
  },
  {
    externalId: "q3",
    text: "ลูกของคุณใช้การชี้เพื่อบอกความต้องการหรือสิ่งที่อยากได้หรือไม่?",
    options: ["ไม่เคย/น้อยมาก", "บางครั้ง", "มักจะ/เสมอ"],
    scoringType: "qchat",
    maxPoints: 2,
  },
  {
    externalId: "q4",
    text: "ลูกของคุณนำสิ่งของมาให้เพื่อแสดงหรือแบ่งปันกับคุณหรือไม่?",
    options: ["ไม่เคย/น้อยมาก", "บางครั้ง", "มักจะ/เสมอ"],
    scoringType: "qchat",
    maxPoints: 2,
  },
  {
    externalId: "q5",
    text: "ลูกของคุณสามารถมองตามสายตาที่คุณมองไปหรือไม่?",
    options: ["ไม่เคย/น้อยมาก", "บางครั้ง", "มักจะ/เสมอ"],
    scoringType: "qchat",
    maxPoints: 2,
  },
  {
    externalId: "q6",
    text: "ลูกของคุณเลียนแบบการกระทำของคุณ เช่น ท่าทางหรือการเล่นต่างๆ หรือไม่?",
    options: ["ไม่เคย/น้อยมาก", "บางครั้ง", "มักจะ/เสมอ"],
    scoringType: "qchat",
    maxPoints: 2,
  },
  {
    externalId: "q7",
    text: "ลูกของคุณตอบสนองเมื่อคุณเรียกชื่อเขาหรือไม่?",
    options: ["ไม่เคย/น้อยมาก", "บางครั้ง", "มักจะ/เสมอ"],
    scoringType: "qchat",
    maxPoints: 2,
  },
  {
    externalId: "q8",
    text: "เมื่อคุณยิ้มให้ ลูกของคุณยิ้มตอบหรือไม่?",
    options: ["ไม่เคย/น้อยมาก", "บางครั้ง", "มักจะ/เสมอ"],
    scoringType: "qchat",
    maxPoints: 2,
  },
  {
    externalId: "q9",
    text: "ลูกของคุณแสดงอารมณ์หรือความรู้สึกเมื่ออยู่ใกล้คุณหรือไม่?",
    options: ["ไม่เคย/น้อยมาก", "บางครั้ง", "มักจะ/เสมอ"],
    scoringType: "qchat",
    maxPoints: 2,
  },
  {
    externalId: "q10",
    text: "ลูกของคุณชอบเล่นหรือทำกิจกรรมร่วมกับคุณหรือไม่?",
    options: ["ไม่เคย/น้อยมาก", "บางครั้ง", "มักจะ/เสมอ"],
    scoringType: "qchat",
    maxPoints: 2,
  },
];

export const qchatQuestionnaire: QChatSeedQuestionnaire = {
  slug: "qchat",
  title: "Q-CHAT-10",
  description:
    "แบบคัดกรองออทิสติกสำหรับเด็กเล็ก 10 ข้อ (Quantitative Checklist for Autism in Toddlers)",
  type: "qchat",
  maxScore: 20,
  questions: qChatQuestions.map((q, index) => ({
    ...q,
    displayOrder: index + 1,
  })),
};
