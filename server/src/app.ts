import express from "express";
import cors from "cors";
import helmet from "helmet";
import morgan from "morgan";
import { env } from "./config/env.js";
import apiRouter from "./routes/index.js";
import { errorHandler, notFoundHandler } from "./middleware/error-handler.js";

const app = express();

app.use(helmet());
app.use(cors({ origin: env.CLIENT_URL === "*" ? undefined : env.CLIENT_URL }));
app.use(express.json({ limit: "1mb" }));
app.use(morgan("dev"));

app.get("/health", (_req, res) => {
  res.json({ status: "ok" });
});

app.use("/api", apiRouter);
app.use(notFoundHandler);
app.use(errorHandler);

export default app;
