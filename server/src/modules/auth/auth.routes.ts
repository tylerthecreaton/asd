import { Router } from "express";
import {
  getProfile,
  getUserStats,
  login,
  register,
  updateProfile,
} from "./auth.controller.js";
import { requireAuth } from "../../middleware/auth.js";

const router = Router();

router.post("/register", register);
router.post("/login", login);
router.get("/me", requireAuth, getProfile);
router.put("/me", requireAuth, updateProfile);
router.get("/stats", requireAuth, getUserStats);

export default router;
