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

export const changePasswordSchema = z
  .object({
    currentPassword: z.string().min(1, "Current password is required"),
    newPassword: z
      .string()
      .min(6, "New password must be at least 6 characters"),
    confirmPassword: z.string().min(1, "Confirm password is required"),
  })
  .refine((data) => data.newPassword === data.confirmPassword, {
    message: "Passwords do not match",
    path: ["confirmPassword"],
  });
