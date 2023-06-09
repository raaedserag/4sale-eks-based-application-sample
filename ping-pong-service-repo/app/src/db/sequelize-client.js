import { Sequelize } from "sequelize";
import mysql from "mysql2/promise";
import { setTimeout } from "timers/promises"
import { mysqlConfiguration } from "../config/configuration.js";

class MysqlClientConnection {
    constructor(connection = { host, port, user, password, database }) {
        this.connection = new Sequelize(
            connection.database,
            connection.user,
            connection.password,
            {
                host: connection.host,
                port: connection.port,
                dialect: "mysql",
            }
        );
    }
    async ping() {
        await this.connection.authenticate();
        console.log("Connection has been established successfully.");
    }
    async initialize() {
        try {
            const initialConnection = await mysql.createConnection({
                host: mysqlConfiguration.host,
                port: mysqlConfiguration.port,
                user: mysqlConfiguration.user,
                password: mysqlConfiguration.password,
            });
            await initialConnection.query(`CREATE DATABASE IF NOT EXISTS ${mysqlConfiguration.database};`);
            await initialConnection.end();
            await this.ping();

        } catch (error) {
            console.error("Connection", error);
            await setTimeout(5000)
            await this.initialize()
        }
    }
}
export default new MysqlClientConnection(mysqlConfiguration)