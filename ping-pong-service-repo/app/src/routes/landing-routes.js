import { Router } from "express";
import * as healthCheckControllers from "../controllers/health-checks-controller.js"
import {getCurrentTime} from "../helpers/time-helper.js"
const router = Router();

router.get("/", (req, res) => res.send(`Welcome to ping pong HTTP service, current server time is ${getCurrentTime()}`));
router.get("/ping", healthCheckControllers.checkLiveStatus);
export default router;