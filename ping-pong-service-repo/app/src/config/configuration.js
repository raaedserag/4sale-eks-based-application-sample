import config from "config"

export const
  port = config.get("PORT"),
  host = config.get("HOST"),
  environment = config.get("ENVIRONMENT"),
  }