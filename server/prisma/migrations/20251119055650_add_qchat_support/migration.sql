-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Question" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "questionnaireId" TEXT NOT NULL,
    "externalId" TEXT NOT NULL,
    "text" TEXT NOT NULL,
    "description" TEXT,
    "optionsJson" TEXT NOT NULL,
    "correctAnswerIndex" INTEGER NOT NULL,
    "displayOrder" INTEGER NOT NULL,
    "scoringType" TEXT NOT NULL DEFAULT 'binary',
    "maxPoints" INTEGER NOT NULL DEFAULT 1,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    CONSTRAINT "Question_questionnaireId_fkey" FOREIGN KEY ("questionnaireId") REFERENCES "Questionnaire" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO "new_Question" ("correctAnswerIndex", "createdAt", "description", "displayOrder", "externalId", "id", "optionsJson", "questionnaireId", "text", "updatedAt") SELECT "correctAnswerIndex", "createdAt", "description", "displayOrder", "externalId", "id", "optionsJson", "questionnaireId", "text", "updatedAt" FROM "Question";
DROP TABLE "Question";
ALTER TABLE "new_Question" RENAME TO "Question";
CREATE UNIQUE INDEX "Question_questionnaireId_externalId_key" ON "Question"("questionnaireId", "externalId");
CREATE TABLE "new_Questionnaire" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "slug" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "passingScore" INTEGER NOT NULL,
    "type" TEXT NOT NULL DEFAULT 'standard',
    "maxScore" INTEGER NOT NULL DEFAULT 0,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL
);
INSERT INTO "new_Questionnaire" ("createdAt", "description", "id", "passingScore", "slug", "title", "updatedAt") SELECT "createdAt", "description", "id", "passingScore", "slug", "title", "updatedAt" FROM "Questionnaire";
DROP TABLE "Questionnaire";
ALTER TABLE "new_Questionnaire" RENAME TO "Questionnaire";
CREATE UNIQUE INDEX "Questionnaire_slug_key" ON "Questionnaire"("slug");
CREATE TABLE "new_Response" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "resultId" TEXT NOT NULL,
    "questionId" TEXT NOT NULL,
    "selectedIndex" INTEGER NOT NULL,
    "points" INTEGER NOT NULL DEFAULT 0,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "Response_resultId_fkey" FOREIGN KEY ("resultId") REFERENCES "AssessmentResult" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "Response_questionId_fkey" FOREIGN KEY ("questionId") REFERENCES "Question" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO "new_Response" ("createdAt", "id", "questionId", "resultId", "selectedIndex") SELECT "createdAt", "id", "questionId", "resultId", "selectedIndex" FROM "Response";
DROP TABLE "Response";
ALTER TABLE "new_Response" RENAME TO "Response";
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
