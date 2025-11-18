import { z } from "zod";

export const registerSchema = z.object({
  email: z.string().email("Invalid email format").toLowerCase().trim(),
  password: z.string().min(8, "Password must be at least 8 characters"),
  name: z
    .string()
    .min(2, "Name must be at least 2 characters")
    .max(100, "Name is too long")
    .optional()
    .transform((val) => val?.trim() || undefined),
});

export const loginSchema = z.object({
  email: z.string().email("Invalid email format").toLowerCase().trim(),
  password: z.string().min(8, "Password must be at least 8 characters"),
});
