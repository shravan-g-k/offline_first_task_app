import { Router, Request, Response } from "express";
import { auth, AuthRequest } from "../middleware/auth";
import { db } from "../db";
import { NewTask, tasks } from "../db/schema";
import { eq } from "drizzle-orm";

const taskRouter = Router();

taskRouter.post("/", auth, async (req: AuthRequest, res: Response) => {
  try {
    req.body = { ...req.body,dueAt : new Date(req.body.dueAt), uid: req.user };
    const newTask: NewTask = req.body;
    const [task] = await db.insert(tasks).values(newTask).returning();
    res.status(201).json(task);
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: error });
  }
});
taskRouter.get("/", auth, async (req: AuthRequest, res: Response) => {
  try {
    const allTasks = await db
      .select()
      .from(tasks)
      .where(eq(tasks.uid, req.user!));

    res.json(allTasks);
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: error });
  }
});
taskRouter.delete("/", auth, async (req: AuthRequest, res: Response) => {
  try {
    const { taskId }: { taskId: string } = req.body;

    await db.delete(tasks).where(eq(tasks.id, taskId));

    res.json(true);
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: error });
  }
});

export default taskRouter;
