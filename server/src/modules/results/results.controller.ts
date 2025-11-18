import { Request, Response, NextFunction } from "express";
import { StatusCodes } from "http-status-codes";
import { prisma } from "../../lib/prisma.js";
import type { Prisma } from "@prisma/client";

const toStringArray = (value: string) => {
  try {
    const parsed = JSON.parse(value);
    return Array.isArray(parsed) ? parsed.map((item) => String(item)) : [];
  } catch (error) {
    return [];
  }
};

const parseJson = <T>(value: string, fallback: T): T => {
  try {
    return JSON.parse(value) as T;
  } catch (error) {
    return fallback;
  }
};

type ResultWithRelations = Prisma.AssessmentResultGetPayload<{
  include: {
    questionnaire: { select: { id: true; slug: true; title: true } };
  };
}>;

type SingleResultWithRelations = Prisma.AssessmentResultGetPayload<{
  include: {
    questionnaire: { select: { id: true; slug: true; title: true } };
    answers: {
      orderBy: { createdAt: "asc" };
      select: {
        id: true;
        questionId: true;
        selectedIndex: true;
        createdAt: true;
      };
    };
  };
}>;

export const listResults = async (
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

    const results = await prisma.assessmentResult.findMany({
      where: { userId: req.userId },
      orderBy: { createdAt: "desc" },
      include: {
        questionnaire: {
          select: { id: true, slug: true, title: true },
        },
      },
    });

    res.json({
      results: results.map((result: ResultWithRelations) => ({
        id: result.id,
        questionnaire: result.questionnaire,
        score: result.score,
        totalQuestions: result.totalQuestions,
        riskLevel: result.riskLevel,
        flaggedBehaviors: toStringArray(result.flaggedBehaviorsJson),
        recommendations: parseJson<Record<string, unknown>>(
          result.recommendationsJson,
          {}
        ),
        createdAt: result.createdAt,
      })),
    });
  } catch (error) {
    next(error);
  }
};

export const getResultById = async (
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

    const result = await prisma.assessmentResult.findFirst({
      where: { id: req.params.id, userId: req.userId },
      include: {
        questionnaire: { select: { id: true, slug: true, title: true } },
        answers: {
          orderBy: { createdAt: "asc" },
          select: {
            id: true,
            questionId: true,
            selectedIndex: true,
            createdAt: true,
          },
        },
      },
    });

    if (!result) {
      return res
        .status(StatusCodes.NOT_FOUND)
        .json({ message: "Result not found" });
    }

    res.json({
      result: {
        id: result.id,
        questionnaire: result.questionnaire,
        score: result.score,
        totalQuestions: result.totalQuestions,
        riskLevel: result.riskLevel,
        flaggedBehaviors: toStringArray(result.flaggedBehaviorsJson),
        recommendations: parseJson<Record<string, unknown>>(
          result.recommendationsJson,
          {}
        ),
        createdAt: result.createdAt,
        answers: result.answers,
      },
    });
  } catch (error) {
    next(error);
  }
};
