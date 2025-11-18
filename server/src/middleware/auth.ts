import { NextFunction, Request, Response } from "express";
import { StatusCodes } from "http-status-codes";
import { verifyAccessToken } from "../utils/token.js";

const getTokenFromHeader = (req: Request) => {
  const header = req.headers.authorization;
  if (!header) return null;
  const [scheme, token] = header.split(" ");
  if (scheme !== "Bearer" || !token) return null;
  return token;
};

export const requireAuth = (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const token = getTokenFromHeader(req);
    if (!token) {
      return res
        .status(StatusCodes.UNAUTHORIZED)
        .json({ message: "Authentication required" });
    }
    const payload = verifyAccessToken(token);
    req.userId = payload.sub;
    next();
  } catch (error) {
    return res
      .status(StatusCodes.UNAUTHORIZED)
      .json({ message: "Invalid or expired token" });
  }
};

export const optionalAuth = (
  req: Request,
  _res: Response,
  next: NextFunction
) => {
  try {
    const token = getTokenFromHeader(req);
    if (!token) return next();
    const payload = verifyAccessToken(token);
    req.userId = payload.sub;
    return next();
  } catch (error) {
    return next();
  }
};
