export type RiskLevel = "low" | "medium" | "high";

export const determineRiskLevel = (score: number): RiskLevel => {
  if (score <= 2) return "low";
  if (score <= 5) return "medium";
  return "high";
};

export const buildRecommendations = (
  riskLevel: RiskLevel,
  flaggedBehaviors: string[]
) => {
  switch (riskLevel) {
    case "low":
      return {
        summary: "ผลการประเมินอยู่ในระดับความเสี่ยงต่ำ",
        suggestedAction:
          "แนะนำให้ติดตามพัฒนาการเด็กอย่างสม่ำเสมอ และทำแบบประเมินซ้ำใน 3 เดือน หรือเร็วกว่านั้นหากมีความกังวล",
        nextSteps: [
          "ติดตามพัฒนาการตามปกติ",
          "สังเกตพฤติกรรมการสื่อสารและการมีปฏิสัมพันธ์ทางสังคม",
          "ประเมินซ้ำใน 3 เดือน",
        ],
      };
    case "medium":
      return {
        summary: "ผลการประเมินอยู่ในระดับความเสี่ยงปานกลาง",
        suggestedAction:
          "แนะนำให้ปรึกษากุมารแพทย์เฉพาะทางด้านพัฒนาการ และพิจารณาทำการประเมินเชิงลึกเพิ่มเติม",
        nextSteps: [
          "นัดพบกุมารแพทย์เฉพาะทางด้านพัฒนาการ",
          "ทำการประเมินพัฒนาการอย่างละเอียด",
          "พิจารณาการกระตุ้นพัฒนาการเบื้องต้น",
        ],
        flaggedBehaviors,
      };
    case "high":
    default:
      return {
        summary: "ผลการประเมินอยู่ในระดับความเสี่ยงสูงที่บ่งชี้ถึงออทิสติก",
        suggestedAction:
          "แนะนำให้รีบปรึกษากุมารแพทย์เฉพาะทางด้านพัฒนาการโดยเร็วที่สุด เพื่อทำการวินิจฉัยและวางแผนการดูแลที่เหมาะสม",
        nextSteps: [
          "นัดพบกุมารแพทย์เฉพาะทางทันที",
          "ทำการวินิจฉัยและประเมินอย่างละเอียด",
          "เริ่มการบำบัดและพัฒนาทักษะตามความเหมาะสม",
          "ขอคำแนะนำเรื่องการดูแลและการศึกษา",
        ],
        flaggedBehaviors,
      };
  }
};
