import app from "./app.js";
import { env } from "./config/env.js";
import { prisma } from "./lib/prisma.js";

const bootstrap = async () => {
  process.on("SIGINT", async () => {
    await prisma.$disconnect();
    process.exit(0);
  });

  process.on("SIGTERM", async () => {
    await prisma.$disconnect();
    process.exit(0);
  });

  app.listen(env.PORT, () => {
    console.log(`API listening on http://localhost:${env.PORT}`);
  });
};

bootstrap().catch(async (error) => {
  console.error(error);
  await prisma.$disconnect();
  process.exit(1);
});
