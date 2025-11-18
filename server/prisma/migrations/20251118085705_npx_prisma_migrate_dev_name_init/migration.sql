-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "email" TEXT NOT NULL,
    "name" TEXT,
    "passwordHash" TEXT NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL
);

-- CreateTable
CREATE TABLE "Questionnaire" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "slug" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "passingScore" INTEGER NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL
);

-- CreateTable
CREATE TABLE "Question" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "questionnaireId" TEXT NOT NULL,
    "externalId" TEXT NOT NULL,
    "text" TEXT NOT NULL,
    "description" TEXT,
    "optionsJson" TEXT NOT NULL,
    "correctAnswerIndex" INTEGER NOT NULL,
    "displayOrder" INTEGER NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    CONSTRAINT "Question_questionnaireId_fkey" FOREIGN KEY ("questionnaireId") REFERENCES "Questionnaire" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "AssessmentResult" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "questionnaireId" TEXT NOT NULL,
    "userId" TEXT,
    "score" INTEGER NOT NULL,
    "totalQuestions" INTEGER NOT NULL,
    "riskLevel" TEXT NOT NULL,
    "flaggedBehaviorsJson" TEXT NOT NULL,
    "recommendationsJson" TEXT NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    CONSTRAINT "AssessmentResult_questionnaireId_fkey" FOREIGN KEY ("questionnaireId") REFERENCES "Questionnaire" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "AssessmentResult_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Response" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "resultId" TEXT NOT NULL,
    "questionId" TEXT NOT NULL,
    "selectedIndex" INTEGER NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "Response_resultId_fkey" FOREIGN KEY ("resultId") REFERENCES "AssessmentResult" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "Response_questionId_fkey" FOREIGN KEY ("questionId") REFERENCES "Question" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Questionnaire_slug_key" ON "Questionnaire"("slug");

-- CreateIndex
CREATE UNIQUE INDEX "Question_questionnaireId_externalId_key" ON "Question"("questionnaireId", "externalId");
