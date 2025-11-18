import { Router } from "express";
import {
  getQuestionnaire,
  listQuestionnaires,
  submitQuestionnaire,
} from "./questionnaire.controller.js";
import { optionalAuth } from "../../middleware/auth.js";

const router = Router();

router.get("/", listQuestionnaires);
router.get("/:identifier", getQuestionnaire);
router.post("/:identifier/submissions", optionalAuth, submitQuestionnaire);

export default router;
