import { Request, Response, NextFunction } from "express";
import { StatusCodes } from "http-status-codes";
import { prisma } from "../../lib/prisma.js";
import { buildRecommendations, determineRiskLevel } from "../../utils/risk.js";
import { submissionSchema } from "./questionnaire.validators.js";

type SubmissionAnswer = {
  questionId: string;
  answerIndex: number;
};

const toStringArray = (value: unknown) => {
  if (typeof value === "string") {
    try {
      const parsed = JSON.parse(value);
      return Array.isArray(parsed) ? parsed.map((item) => String(item)) : [];
    } catch (error) {
      return [];
    }
  }
  return Array.isArray(value) ? value.map((item) => String(item)) : [];
};

const parseJson = <T>(value: string, fallback: T): T => {
  try {
    return JSON.parse(value) as T;
  } catch (error) {
    return fallback;
  }
};

const toQuestionSummary = (question: any) => ({
  id: question.id,
  externalId: question.externalId,
  text: question.text,
  description: question.description,
  options: toStringArray(question.optionsJson),
  correctAnswerIndex: question.correctAnswerIndex,
  order: question.displayOrder,
});

const questionnaireWhere = (identifier: string) => ({
  OR: [{ id: identifier }, { slug: identifier }],
});

export const listQuestionnaires = async (
  _req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const questionnaires = await prisma.questionnaire.findMany({
      orderBy: { createdAt: "asc" },
      include: { _count: { select: { questions: true } } },
    });

    const payload = questionnaires.map((questionnaire: any) => ({
      id: questionnaire.id,
      slug: questionnaire.slug,
      title: questionnaire.title,
      description: questionnaire.description,
      passingScore: questionnaire.passingScore,
      questionCount: questionnaire._count.questions,
      createdAt: questionnaire.createdAt,
      updatedAt: questionnaire.updatedAt,
    }));

    res.json({ questionnaires: payload });
  } catch (error) {
    next(error);
  }
};

export const getQuestionnaire = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const questionnaire = await prisma.questionnaire.findFirst({
      where: questionnaireWhere(req.params.identifier),
      include: {
        questions: {
          orderBy: { displayOrder: "asc" },
        },
      },
    });

    if (!questionnaire) {
      return res
        .status(StatusCodes.NOT_FOUND)
        .json({ message: "Questionnaire not found" });
    }

    res.json({
      questionnaire: {
        id: questionnaire.id,
        slug: questionnaire.slug,
        title: questionnaire.title,
        description: questionnaire.description,
        passingScore: questionnaire.passingScore,
        questions: questionnaire.questions.map(toQuestionSummary),
      },
    });
  } catch (error) {
    next(error);
  }
};

export const submitQuestionnaire = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const payload = submissionSchema.parse(req.body);
    const questionnaire = await prisma.questionnaire.findFirst({
      where: questionnaireWhere(req.params.identifier),
      include: {
        questions: {
          orderBy: { displayOrder: "asc" },
        },
      },
    });

    if (!questionnaire) {
      return res
        .status(StatusCodes.NOT_FOUND)
        .json({ message: "Questionnaire not found" });
    }

    const answersMap = new Map<string, number>(
      payload.answers.map((answer: SubmissionAnswer) => [
        answer.questionId,
        answer.answerIndex,
      ])
    );

    const responses = [] as {
      questionId: string;
      externalId: string;
      selectedIndex: number;
      text: string;
    }[];
    let score = 0;
    const flagged: string[] = [];

    for (const question of questionnaire.questions) {
      const answer =
        answersMap.get(question.externalId) ?? answersMap.get(question.id);
      const options = toStringArray(question.optionsJson);

      if (typeof answer !== "number" || Number.isNaN(answer)) {
        return res.status(StatusCodes.BAD_REQUEST).json({
          message: `Missing answer for question ${question.externalId}`,
        });
      }
      if (answer < 0 || answer >= options.length) {
        return res.status(StatusCodes.BAD_REQUEST).json({
          message: `Invalid option for question ${question.externalId}`,
        });
      }
      if (answer !== question.correctAnswerIndex) {
        score++;
        flagged.push(question.text);
      }
      responses.push({
        questionId: question.id,
        externalId: question.externalId,
        selectedIndex: answer,
        text: question.text,
      });
    }

    const riskLevel = determineRiskLevel(score);
    const recommendations = buildRecommendations(riskLevel, flagged);

    const result = await prisma.assessmentResult.create({
      data: {
        questionnaireId: questionnaire.id,
        userId: req.userId ?? null,
        score,
        totalQuestions: questionnaire.questions.length,
        riskLevel,
        flaggedBehaviorsJson: JSON.stringify(flagged),
        recommendationsJson: JSON.stringify(recommendations),
        answers: {
          create: responses.map((response) => ({
            questionId: response.questionId,
            selectedIndex: response.selectedIndex,
          })),
        },
      },
      include: {
        answers: {
          select: {
            id: true,
            questionId: true,
            selectedIndex: true,
            createdAt: true,
          },
          orderBy: { createdAt: "asc" },
        },
      },
    });

    res.status(StatusCodes.CREATED).json({
      result: {
        id: result.id,
        questionnaireId: result.questionnaireId,
        userId: result.userId,
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
