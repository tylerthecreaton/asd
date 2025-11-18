import { NextFunction, Request, Response } from "express";
import { Prisma } from "@prisma/client";
import { StatusCodes } from "http-status-codes";
import { ZodError } from "zod";

export const notFoundHandler = (_req: Request, res: Response) => {
  res.status(StatusCodes.NOT_FOUND).json({ message: "Route not found" });
};

export const errorHandler = (
  err: unknown,
  _req: Request,
  res: Response,
  _next: NextFunction
) => {
  console.error(err);

  // Zod validation errors
  if (err instanceof ZodError) {
    const firstError = err.errors[0];
    return res.status(StatusCodes.BAD_REQUEST).json({
      message: firstError.message || "Validation error",
      field: firstError.path.join("."),
      issues: err.errors,
    });
  }

  // Prisma errors
  if (err instanceof Prisma.PrismaClientKnownRequestError) {
    // Unique constraint violation
    if (err.code === "P2002") {
      return res.status(StatusCodes.CONFLICT).json({
        message: "Email is already registered",
        error: "EMAIL_EXISTS",
      });
    }

    return res.status(StatusCodes.BAD_REQUEST).json({
      message: err.message,
      code: err.code,
    });
  }

  const status =
    (err as { status?: number }).status || StatusCodes.INTERNAL_SERVER_ERROR;
  const message =
    (err as { message?: string }).message ||
    "Something went wrong. Please try again later.";

  return res.status(status).json({ message });
};
