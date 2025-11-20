import { PrismaClient } from "@prisma/client";
import { qchatQuestionnaire } from "./seed-data/qchat.js";

const prisma = new PrismaClient();

async function seedQChatQuestionnaire() {
  const questionnaire = await prisma.questionnaire.upsert({
    where: { slug: qchatQuestionnaire.slug },
    update: {
      title: qchatQuestionnaire.title,
      description: qchatQuestionnaire.description,
      type: qchatQuestionnaire.type,
      maxScore: qchatQuestionnaire.maxScore,
      passingScore: 13, // Medium risk threshold for Q-CHAT-10
    },
    create: {
      slug: qchatQuestionnaire.slug,
      title: qchatQuestionnaire.title,
      description: qchatQuestionnaire.description,
      type: qchatQuestionnaire.type,
      maxScore: qchatQuestionnaire.maxScore,
      passingScore: 13, // Medium risk threshold for Q-CHAT-10
    },
  });

  await prisma.question.deleteMany({
    where: { questionnaireId: questionnaire.id },
  });

  await prisma.question.createMany({
    data: qchatQuestionnaire.questions.map((question) => ({
      questionnaireId: questionnaire.id,
      externalId: question.externalId,
      text: question.text,
      description: question.description ?? null,
      optionsJson: JSON.stringify(question.options),
      correctAnswerIndex: 2, // Q-CHAT uses reverse scoring: "Usually/Always" (index 2) = typical development
      displayOrder: question.displayOrder,
      scoringType: question.scoringType,
      maxPoints: question.maxPoints,
    })),
  });
}

async function main() {
  await seedQChatQuestionnaire();
}

main()
  .then(async () => {
    console.log("Database seeded");
    await prisma.$disconnect();
  })
  .catch(async (error) => {
    console.error(error);
    await prisma.$disconnect();
    process.exit(1);
  });
