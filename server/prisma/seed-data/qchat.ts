export type QChatSeedQuestion = {
  externalId: string;
  text: string;
  options: string[];
  scoringType: string;
  maxPoints: number;
  displayOrder: number;
  description?: string | null;
  // แนะนำ: คุณอาจต้องเพิ่ม field เช่น 'riskAnswer' เพื่อบอกว่าตอบข้อไหนแล้วได้คะแนน
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
  // --- กลุ่มการสื่อสารและสังคม (ตอบ "ไม่ใช่" = เสี่ยง/ได้แต้ม) ---
  {
    externalId: "q1",
    text: "เมื่อคุณเรียกชื่อ ลูกหันมามองคุณหรือไม่?",
    options: ["ไม่ใช่", "ใช่"], // Risk: ไม่ใช่
    scoringType: "qchat_standard",
    maxPoints: 1,
  },
  {
    externalId: "q2",
    text: "ลูกสบตาคุณได้ง่ายดาย เวลาพูดคุยหรือเล่นด้วยกันหรือไม่?",
    options: ["ไม่ใช่", "ใช่"], // Risk: ไม่ใช่
    scoringType: "qchat_standard",
    maxPoints: 1,
  },

  // --- กลุ่มพฤติกรรมซ้ำๆ (ตอบ "ใช่" = เสี่ยง/ได้แต้ม) ---
  {
    externalId: "q3",
    text: "ลูกชอบนำสิ่งของมาเรียงต่อกันเป็นแถวๆ หรือไม่?",
    options: ["ไม่ใช่", "ใช่"], // Risk: ใช่ (*ข้อนี้กลับด้าน*)
    scoringType: "qchat_reverse",
    maxPoints: 1,
  },

  // --- กลับมากลุ่มปกติ ---
  {
    externalId: "q4",
    text: "คนอื่นๆ ฟังสิ่งที่ลูกพูดรู้เรื่อง หรือเข้าใจสิ่งที่ลูกสื่อสารหรือไม่?",
    options: ["ไม่ใช่", "ใช่"], // Risk: ไม่ใช่
    scoringType: "qchat_standard",
    maxPoints: 1,
  },
  {
    externalId: "q5",
    text: "ลูกใช้นิ้วชี้เพื่อบอกความต้องการ (เช่น ชี้ขอนม ชี้ของที่อยากได้) หรือไม่?",
    options: ["ไม่ใช่", "ใช่"], // Risk: ไม่ใช่
    scoringType: "qchat_standard",
    maxPoints: 1,
  },
  {
    externalId: "q6",
    text: "ลูกใช้นิ้วชี้เพื่อชวนให้คุณดูสิ่งที่เขาสนใจ (เช่น ชี้ให้ดูเครื่องบิน ชี้ให้ดูแมว) หรือไม่?",
    options: ["ไม่ใช่", "ใช่"], // Risk: ไม่ใช่
    scoringType: "qchat_standard",
    maxPoints: 1,
  },

  // --- กลุ่มพฤติกรรมซ้ำๆ ---
  {
    externalId: "q7",
    text: "ลูกชอบขยับนิ้วมือในลักษณะแปลกๆ ใกล้ๆ ดวงตาของเขาหรือไม่?",
    options: ["ไม่ใช่", "ใช่"], // Risk: ใช่ (*ข้อนี้กลับด้าน*)
    scoringType: "qchat_reverse",
    maxPoints: 1,
  },

  // --- กลับมากลุ่มปกติ ---
  {
    externalId: "q8",
    text: "ลูกเล่นบทบาทสมมติเป็นหรือไม่ (เช่น ป้อนข้าวตุ๊กตา, คุยโทรศัพท์ของเล่น)?",
    options: ["ไม่ใช่", "ใช่"], // Risk: ไม่ใช่
    scoringType: "qchat_standard",
    maxPoints: 1,
  },

  // --- กลุ่มพฤติกรรมซ้ำๆ ---
  {
    externalId: "q9",
    text: "ลูกชอบจ้องมองไปยังความว่างเปล่า หรือมองอย่างไร้จุดหมายบ่อยๆ หรือไม่?",
    options: ["ไม่ใช่", "ใช่"], // Risk: ใช่ (*ข้อนี้กลับด้าน*)
    scoringType: "qchat_reverse",
    maxPoints: 1,
  },

  // --- กลับมากลุ่มปกติ ---
  {
    externalId: "q10",
    text: "เมื่อลูกเจอสิ่งแปลกใหม่ ลูกหันกลับมามองหน้าคุณเพื่อดูปฏิกิริยาหรือไม่?",
    options: ["ไม่ใช่", "ใช่"], // Risk: ไม่ใช่
    scoringType: "qchat_standard",
    maxPoints: 1,
  },
];

export const qchatQuestionnaire: QChatSeedQuestionnaire = {
  slug: "qchat-10-binary",
  title: "Q-CHAT-10 (Adapted)",
  description:
    "แบบคัดกรองภาวะออทิสติก Q-CHAT-10 ฉบับปรับปรุงตัวเลือก (ใช่/ไม่ใช่)",
  type: "qchat",
  maxScore: 10,
  questions: qChatQuestions.map((q, index) => ({
    ...q,
    displayOrder: index + 1,
  })),
};
