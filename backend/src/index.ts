import express from "express";
import authRouter from "./routes/auth";
import taskRouter from "./routes/task";

const app = express();

app.use(express.json());
app.use("/auth",authRouter);

app.use("/tasks", taskRouter    );
 
app.get("/", (req, res) => {
    res.send("Hello World!");
});

app.listen(8000, () => {
    console.log("Server is running on port 8000");
});