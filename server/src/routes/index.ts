import { Router } from "express";
import authRoutes from "../modules/auth/auth.routes.js";
import questionnaireRoutes from "../modules/questionnaire/questionnaire.routes.js";
import resultsRoutes from "../modules/results/results.routes.js";

const router = Router();

router.use("/auth", authRoutes);
router.use("/questionnaires", questionnaireRoutes);
router.use("/results", resultsRoutes);

export default router;
