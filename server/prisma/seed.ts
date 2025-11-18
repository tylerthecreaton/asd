import { PrismaClient } from "@prisma/client";
import { mchatQuestionnaire } from "./seed-data/mchat.js";

const prisma = new PrismaClient();

async function seedQuestionnaire() {
  const questionnaire = await prisma.questionnaire.upsert({
    where: { slug: mchatQuestionnaire.slug },
    update: {
      title: mchatQuestionnaire.title,
      description: mchatQuestionnaire.description,
      passingScore: mchatQuestionnaire.passingScore,
    },
    create: {
      slug: mchatQuestionnaire.slug,
      title: mchatQuestionnaire.title,
      description: mchatQuestionnaire.description,
      passingScore: mchatQuestionnaire.passingScore,
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
    })),
  });
}

async function main() {
  await seedQuestionnaire();
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
