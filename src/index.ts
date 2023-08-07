import { Request, Response } from "express";
import express from 'express'
import bodyParser from "body-parser";

const app = express();

app.use(bodyParser.urlencoded({ extended: false }));

app.use("/", (req: Request, res: Response)=>{
    return res.status(200).json({message: "Home Page"})
})

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server listening on port ${PORT}`);
});