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
  scoringType: question.scoringType,
  maxPoints: question.maxPoints,
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
      points: number;
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

      let points = 0;
      if (question.scoringType === "qchat") {
        // Q-CHAT scoring: 0, 1, 2 points based on answer selection
        points = answer; // 0 for "Never/Rarely", 1 for "Sometimes", 2 for "Usually/Always"
        score += points;
        
        // Flag questions with higher scores (1 or 2 points)
        if (points >= 1) {
          flagged.push(question.text);
        }
      } else {
        // Standard binary scoring (M-CHAT style)
        if (answer !== question.correctAnswerIndex) {
          score = 1; // Each failed question adds 1 point
          flagged.push(question.text);
        } else {
          score = 0; // Correct answers add 0 points
        }
      }

      responses.push({
        questionId: question.id,
        externalId: question.externalId,
        selectedIndex: answer,
        points: points,
        text: question.text,
      });
    }

    // Determine risk level based on questionnaire type
    let riskLevel: "low" | "medium" | "high";
    if (questionnaire.type === "qchat") {
      // Q-CHAT risk levels: Low (0-15), Medium (16-30), High (31-50)
      if (score <= 15) {
        riskLevel = "low";
      } else if (score <= 30) {
        riskLevel = "medium";
      } else {
        riskLevel = "high";
      }
    } else {
      // Standard questionnaire risk levels
      riskLevel = determineRiskLevel(score);
    }
    
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
            points: response.points,
          })),
        },
      },
      include: {
        answers: {
          select: {
            id: true,
            questionId: true,
            selectedIndex: true,
            points: true,
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
