import sequelizeClient from "../db/sequelize-client.js";


export async function checkLiveStatus(req, res) {
    try {
        await sequelizeClient.ping();
        return res.status(200).send("Pong !");
    } catch (error) {
        return res.status(503).send("Maintenance")
    }
}