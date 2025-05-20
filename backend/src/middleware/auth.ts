import { UUID } from "crypto";
import { Request, Response, NextFunction } from "express";
import jwt from "jsonwebtoken";
import { db } from "../db";
import { users } from "../db/schema";
import { eq } from "drizzle-orm";

export interface AuthRequest extends Request {
  user?: UUID;
  token?: string;
}

export const auth = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const token = req.header("x-auth-token");

    if (!token) {
      res.status(401).json({ msg: "No token, authorization denied" });
      return;
    }

    const verified = jwt.verify(token, "passwordKey");

    if (!verified) {
      res.status(401).json({ msg: "Token is not valid" });
      return;
    }

    const verifiedToken = verified as { id: UUID };

    const [user] = await db
      .select()
      .from(users)
      .where(eq(users.id, verifiedToken.id));

    if (!user) {
      res.status(401).json({ msg: "User not found" });
      return;
    }

    req.user = verifiedToken.id;
    req.token = token;

    next();

  } catch (error) {
    res.status(500).json({ msg: "Server error" });
  }
};
