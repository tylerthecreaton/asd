import jwt from "jsonwebtoken";
import { env } from "../config/env.js";

interface TokenPayload {
  sub: string;
}

const TOKEN_EXPIRY = "7d";

export const generateAccessToken = (userId: string) => {
  return jwt.sign({ sub: userId }, env.JWT_SECRET, { expiresIn: TOKEN_EXPIRY });
};

export const verifyAccessToken = (token: string) => {
  return jwt.verify(token, env.JWT_SECRET) as TokenPayload;
};
