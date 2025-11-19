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
    text: "บุตรหลายของคุณชอบที่จะถูกตัวเองหรือไม่?",
    options: ["ไม่เคย/น้อยมาก", "บางครั้ง", "มักจะ/เสมอ"],
    scoringType: "qchat",
    maxPoints: 2,
  },
  {
    externalId: "q2",
    text: "บุตรหลายของคุณสนใจคนอื่นหรือไม่?",
    options: ["ไม่เคย/น้อยมาก", "บางครั้ง", "มักจะ/เสมอ"],
    scoringType: "qchat",
    maxPoints: 2,
  },
  {
    externalId: "q3",
    text: "บุตรหลายของคุณจะชี้ไปที่สิ่งที่ต้องการหรือไม่?",
    options: ["ไม่เคย/น้อยมาก", "บางครั้ง", "มักจะ/เสมอ"],
    scoringType: "qchat",
    maxPoints: 2,
  },
  {
    externalId: "q4",
    text: "บุตรหลายของคุณจะนำของไปให้คุณเพื่อแสดงหรือไม่?",
    options: ["ไม่เคย/น้อยมาก", "บางครั้ง", "มักจะ/เสมอ"],
    scoringType: "qchat",
    maxPoints: 2,
  },
  {
    externalId: "q5",
    text: "บุตรหลายของคุณสามารถติดตามสายตาของคุณได้หรือไม่?",
    options: ["ไม่เคย/น้อยมาก", "บางครั้ง", "มักจะ/เสมอ"],
    scoringType: "qchat",
    maxPoints: 2,
  },
  {
    externalId: "q6",
    text: "บุตรหลายของคุณจะเลียนแบบการกระทำของคุณหรือไม่?",
    options: ["ไม่เคย/น้อยมาก", "บางครั้ง", "มักจะ/เสมอ"],
    scoringType: "qchat",
    maxPoints: 2,
  },
  {
    externalId: "q7",
    text: "บุตรหลายของคุณจะตอบสนองเมื่อคุณเรียกชื่อหรือไม่?",
    options: ["ไม่เคย/น้อยมาก", "บางครั้ง", "มักจะ/เสมอ"],
    scoringType: "qchat",
    maxPoints: 2,
  },
  {
    externalId: "q8",
    text: "บุตรหลายของคุณจะยิ้มเมื่อคุณยิ้มให้หรือไม่?",
    options: ["ไม่เคย/น้อยมาก", "บางครั้ง", "มักจะ/เสมอ"],
    scoringType: "qchat",
    maxPoints: 2,
  },
  {
    externalId: "q9",
    text: "บุตรหลายของคุณจะแสดงความรู้สึกเมื่อคุณอยู่ใกล้หรือไม่?",
    options: ["ไม่เคย/น้อยมาก", "บางครั้ง", "มักจะ/เสมอ"],
    scoringType: "qchat",
    maxPoints: 2,
  },
  {
    externalId: "q10",
    text: "บุตรหลายของคุณจะชอบที่จะเล่นกับคุณหรือไม่?",
    options: ["ไม่เคย/น้อยมาก", "บางครั้ง", "มักจะ/เสมอ"],
    scoringType: "qchat",
    maxPoints: 2,
  },
  {
    externalId: "q11",
    text: "บุตรหลายของคุณจะชอบที่จะเล่นกับเด็กคนอื่นหรือไม่?",
    options: ["ไม่เคย/น้อยมาก", "บางครั้ง", "มักจะ/เสมอ"],
    scoringType: "qchat",
    maxPoints: 2,
  },
  {
    externalId: "q12",
    text: "บุตรหลายของคุณจะชอบที่จะเล่นกับของเล่นหรือไม่?",
    options: ["ไม่เคย/น้อยมาก", "บางครั้ง", "มักจะ/เสมอ"],
    scoringType: "qchat",
    maxPoints: 2,
  },
  {
    externalId: "q13",
    text: "บุตรหลายของคุณจะชอบที่จะสำรวจสิ่งต่างๆ รอบๆ ตัวเองหรือไม่?",
    options: ["ไม่เคย/น้อยมาก", "บางครั้ง", "มักจะ/เสมอ"],
    scoringType: "qchat",
    maxPoints: 2,
  },
  {
    externalId: "q14",
    text: "บุตรหลายของคุณจะชอบที่จะเรียนรู้สิ่งใหม่ๆ หรือไม่?",
    options: ["ไม่เคย/น้อยมาก", "บางครั้ง", "มักจะ/เสมอ"],
    scoringType: "qchat",
    maxPoints: 2,
  },
  {
    externalId: "q15",
    text: "บุตรหลายของคุณจะชอบที่จะทำกิจกรรมต่างๆ หรือไม่?",
    options: ["ไม่เคย/น้อยมาก", "บางครั้ง", "มักจะ/เสมอ"],
    scoringType: "qchat",
    maxPoints: 2,
  },
  {
    externalId: "q16",
    text: "บุตรหลายของคุณจะชอบที่จะพูดคุยหรือไม่?",
    options: ["ไม่เคย/น้อยมาก", "บางครั้ง", "มักจะ/เสมอ"],
    scoringType: "qchat",
    maxPoints: 2,
  },
  {
    externalId: "q17",
    text: "บุตรหลายของคุณจะชอบที่จะฟังเพลงหรือไม่?",
    options: ["ไม่เคย/น้อยมาก", "บางครั้ง", "มักจะ/เสมอ"],
    scoringType: "qchat",
    maxPoints: 2,
  },
  {
    externalId: "q18",
    text: "บุตรหลายของคุณจะชอบที่จะอ่านหนังสือหรือไม่?",
    options: ["ไม่เคย/น้อยมาก", "บางครั้ง", "มักจะ/เสมอ"],
    scoringType: "qchat",
    maxPoints: 2,
  },
  {
    externalId: "q19",
    text: "บุตรหลายของคุณจะชอบที่จะดูโทรทัศน์หรือไม่?",
    options: ["ไม่เคย/น้อยมาก", "บางครั้ง", "มักจะ/เสมอ"],
    scoringType: "qchat",
    maxPoints: 2,
  },
  {
    externalId: "q20",
    text: "บุตรหลายของคุณจะชอบที่จะเล่นเกมหรือไม่?",
    options: ["ไม่เคย/น้อยมาก", "บางครั้ง", "มักจะ/เสมอ"],
    scoringType: "qchat",
    maxPoints: 2,
  },
  {
    externalId: "q21",
    text: "บุตรหลายของคุณจะชอบที่จะวาดรูปหรือไม่?",
    options: ["ไม่เคย/น้อยมาก", "บางครั้ง", "มักจะ/เสมอ"],
    scoringType: "qchat",
    maxPoints: 2,
  },
  {
    externalId: "q22",
    text: "บุตรหลายของคุณจะชอบที่จะสร้างสรรค์สิ่งต่างๆ หรือไม่?",
    options: ["ไม่เคย/น้อยมาก", "บางครั้ง", "มักจะ/เสมอ"],
    scoringType: "qchat",
    maxPoints: 2,
  },
  {
    externalId: "q23",
    text: "บุตรหลายของคุณจะชอบที่จะแก้ปัญหาหรือไม่?",
    options: ["ไม่เคย/น้อยมาก", "บางครั้ง", "มักจะ/เสมอ"],
    scoringType: "qchat",
    maxPoints: 2,
  },
  {
    externalId: "q24",
    text: "บุตรหลายของคุณจะชอบที่จะช่วยเหลือผู้อื่นหรือไม่?",
    options: ["ไม่เคย/น้อยมาก", "บางครั้ง", "มักจะ/เสมอ"],
    scoringType: "qchat",
    maxPoints: 2,
  },
  {
    externalId: "q25",
    text: "บุตรหลายของคุณจะชอบที่จะแบ่งปันสิ่งต่างๆ กับผู้อื่นหรือไม่?",
    options: ["ไม่เคย/น้อยมาก", "บางครั้ง", "มักจะ/เสมอ"],
    scoringType: "qchat",
    maxPoints: 2,
  },
];

export const qchatQuestionnaire: QChatSeedQuestionnaire = {
  slug: "qchat",
  title: "Q-CHAT",
  description: "แบบคัดกรองออทิสติกสำหรับเด็กเล็ก (Quantitative Checklist for Autism in Toddlers)",
  type: "qchat",
  maxScore: 50,
  questions: qChatQuestions.map((q, index) => ({
    ...q,
    displayOrder: index + 1,
  })),
};