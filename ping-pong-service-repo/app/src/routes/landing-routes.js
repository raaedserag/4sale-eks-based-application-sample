import { Router } from "express";
import * as healthCheckControllers from "../controllers/health-checks-controller.js"
const router = Router();
router.get("/ping", healthCheckControllers.checkLiveStatus);
export default router;