import dotenv from "dotenv";
import { z } from "zod";

dotenv.config();

const envSchema = z.object({
  NODE_ENV: z
    .enum(["development", "test", "production"])
    .default("development"),
  PORT: z.string().regex(/^\d+$/).default("4000"),
  DATABASE_URL: z.string().min(1, "DATABASE_URL is required"),
  JWT_SECRET: z.string().min(10, "JWT_SECRET should be harder to guess"),
  CLIENT_URL: z.string().default("*"),
});

const parsed = envSchema.safeParse(process.env);

if (!parsed.success) {
  console.error(
    "Invalid environment variables",
    parsed.error.flatten().fieldErrors
  );
  throw new Error("Environment validation failed");
}

export const env = {
  ...parsed.data,
  PORT: Number(parsed.data.PORT),
};
