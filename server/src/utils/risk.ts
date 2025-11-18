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
        summary: "Low risk observed. Continue regular monitoring.",
        suggestedAction: "Re-screen in 3 months or sooner if concerns arise.",
      };
    case "medium":
      return {
        summary: "Moderate risk detected.",
        suggestedAction:
          "Consult a pediatric specialist and consider scheduling a professional screening.",
        flaggedBehaviors,
      };
    case "high":
    default:
      return {
        summary: "High risk detected for ASD indicators.",
        suggestedAction:
          "Seek immediate consultation with a developmental pediatrician.",
        flaggedBehaviors,
      };
  }
};
