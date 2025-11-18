import { z } from "zod";

export const submissionSchema = z.object({
  answers: z
    .array(
      z.object({
        questionId: z.string(),
        answerIndex: z.number().int().nonnegative(),
      })
    )
    .nonempty("At least one answer is required"),
});
