import { Request, Response, NextFunction } from "express";
import { StatusCodes } from "http-status-codes";
import { User } from "@prisma/client";
import { prisma } from "../../lib/prisma.js";
import { hashPassword, verifyPassword } from "../../utils/password.js";
import { generateAccessToken } from "../../utils/token.js";
import { loginSchema, registerSchema } from "./auth.validators.js";

const toPublicUser = (user: User) => ({
  id: user.id,
  email: user.email,
  name: user.name,
  createdAt: user.createdAt,
  updatedAt: user.updatedAt,
});

export const register = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const payload = registerSchema.parse(req.body);

    const existing = await prisma.user.findUnique({
      where: { email: payload.email },
    });
    if (existing) {
      return res
        .status(StatusCodes.CONFLICT)
        .json({ message: "Email is already registered" });
    }

    const passwordHash = await hashPassword(payload.password);

    const user = await prisma.user.create({
      data: {
        email: payload.email,
        name: payload.name,
        passwordHash,
      },
    });

    const token = generateAccessToken(user.id);

    res.status(StatusCodes.CREATED).json({
      user: toPublicUser(user),
      token,
    });
  } catch (error) {
    next(error);
  }
};

export const login = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const payload = loginSchema.parse(req.body);

    const user = await prisma.user.findUnique({
      where: { email: payload.email },
    });
    if (!user) {
      return res
        .status(StatusCodes.UNAUTHORIZED)
        .json({ message: "Invalid credentials" });
    }

    const isValid = await verifyPassword(payload.password, user.passwordHash);
    if (!isValid) {
      return res
        .status(StatusCodes.UNAUTHORIZED)
        .json({ message: "Invalid credentials" });
    }

    const token = generateAccessToken(user.id);

    res.json({
      user: toPublicUser(user),
      token,
    });
  } catch (error) {
    next(error);
  }
};

export const getProfile = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    if (!req.userId) {
      return res
        .status(StatusCodes.UNAUTHORIZED)
        .json({ message: "Authentication required" });
    }

    const user = await prisma.user.findUnique({ where: { id: req.userId } });

    if (!user) {
      return res
        .status(StatusCodes.NOT_FOUND)
        .json({ message: "User not found" });
    }

    res.json({ user: toPublicUser(user) });
  } catch (error) {
    next(error);
  }
};
