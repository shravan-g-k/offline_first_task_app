import { Router, Request, Response } from "express";
import { db } from "../db";
import { NewUser, users } from "../db/schema";
import { eq } from "drizzle-orm";
import jwt from "jsonwebtoken";
import bcryptjs from "bcryptjs";
import { auth, AuthRequest } from "../middleware/auth";

const authRouter = Router();

interface SignupBody {
  name: string;
  email: string;
  password: string;
}

interface LoginBody {
  email: string;
  password: string;
}

authRouter.post(
  "/signup",
  async (req: Request<{}, {}, SignupBody>, res: Response) => {
    try {
      const { name, email, password } = req.body;

      const existingUser = await db
        .select()
        .from(users)
        .where(eq(users.email, email));

      if (existingUser.length) {
        res.status(400).json({
          error: "User already exists",
        });
        return;
      }

      const hashedPassword = await bcryptjs.hash(password, 8);

      const newUser: NewUser = {
        name: name,
        email: email,
        password: hashedPassword,
      };

      const [user] = await db.insert(users).values(newUser).returning();
      
      res.status(201).json(user);
    } catch (e) {
      res.status(500).json({ error: e });

    }
  }
);

authRouter.post(
  "/login",
  async (req: Request<{}, {}, LoginBody>, res: Response) => {
    try {
      // get req body
      const { email, password } = req.body;

      // check if the user doesnt exist
      const [existingUser] = await db
        .select()
        .from(users)
        .where(eq(users.email, email));

      if (!existingUser) {
        res.status(400).json({ error: "User with this email does not exist!" });
        return;
      }

      const isMatch = await bcryptjs.compare(password, existingUser.password);
      if (!isMatch) {
        res.status(400).json({ error: "Incorrect password!" });
        return;
      }

      const token = jwt.sign({ id: existingUser.id }, "passwordKey");

      res.json({ token, ...existingUser });
    } catch (e) {
      res.status(500).json({ error: e });
    }
  }
);

authRouter.post("/tokenIsValid", async (req, res) => {
  try {
    const token = req.header("x-auth-token");

    if (!token) {
      res.json(false);
      return;
    }

    const verified = jwt.verify(token, "passwordKey");

    if (!verified) {
      res.json(false);
      return;
    }

    const verifiedToken = verified as { id: string };

    const user = await db
      .select()
      .from(users)
      .where(eq(users.id, verifiedToken.id));

    if (!user) {
      res.json(false);
      return;
    }

    res.json(true);
  } catch (error) {
    res.status(500).json(false);
  }
});

authRouter.get("/",auth, async (req : AuthRequest, res) => {
    try {
        
        if(!req.user){
            res.status(401).json({error : "Unauthorized"});
            return;
        }
        const [user] = await db
        .select()
        .from(users)
        .where(eq(users.id, req.user));

        res.json({
            ...user,
            token : req.token
        });
    } catch (error) {
        
        res.status(500).json({error : error});
    }
});

export default authRouter;
