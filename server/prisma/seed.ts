import { PrismaClient } from "@prisma/client";
import { mchatQuestionnaire } from "./seed-data/mchat.js";
import { qchatQuestionnaire } from "./seed-data/qchat.js";

const prisma = new PrismaClient();

async function seedMChatQuestionnaire() {
  const questionnaire = await prisma.questionnaire.upsert({
    where: { slug: mchatQuestionnaire.slug },
    update: {
      title: mchatQuestionnaire.title,
      description: mchatQuestionnaire.description,
      passingScore: mchatQuestionnaire.passingScore,
      type: "standard",
      maxScore: mchatQuestionnaire.questions.length,
    },
    create: {
      slug: mchatQuestionnaire.slug,
      title: mchatQuestionnaire.title,
      description: mchatQuestionnaire.description,
      passingScore: mchatQuestionnaire.passingScore,
      type: "standard",
      maxScore: mchatQuestionnaire.questions.length,
    },
  });

  await prisma.question.deleteMany({
    where: { questionnaireId: questionnaire.id },
  });

  await prisma.question.createMany({
    data: mchatQuestionnaire.questions.map((question) => ({
      questionnaireId: questionnaire.id,
      externalId: question.externalId,
      text: question.text,
      description: question.description ?? null,
      optionsJson: JSON.stringify(question.options),
      correctAnswerIndex: question.correctAnswerIndex,
      displayOrder: question.displayOrder,
      scoringType: "binary",
      maxPoints: 1,
    })),
  });
}

async function seedQChatQuestionnaire() {
  const questionnaire = await prisma.questionnaire.upsert({
    where: { slug: qchatQuestionnaire.slug },
    update: {
      title: qchatQuestionnaire.title,
      description: qchatQuestionnaire.description,
      type: qchatQuestionnaire.type,
      maxScore: qchatQuestionnaire.maxScore,
      passingScore: 30, // Medium risk threshold
    },
    create: {
      slug: qchatQuestionnaire.slug,
      title: qchatQuestionnaire.title,
      description: qchatQuestionnaire.description,
      type: qchatQuestionnaire.type,
      maxScore: qchatQuestionnaire.maxScore,
      passingScore: 30, // Medium risk threshold
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
      correctAnswerIndex: 0, // Not used in Q-CHAT
      displayOrder: question.displayOrder,
      scoringType: question.scoringType,
      maxPoints: question.maxPoints,
    })),
  });
}

async function main() {
  await seedMChatQuestionnaire();
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
