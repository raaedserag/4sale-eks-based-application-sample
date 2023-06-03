

export async function checkLiveStatus(req, res) {
    try {
        return res.status(200).send("Pong !");
    } catch (error) {
        return res.status(503).send("Maintenance")
    }
}