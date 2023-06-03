FROM node:18.16.0-alpine
WORKDIR /usr/ping-pong-service

ARG dynamic_node_env
ENV NODE_ENV=$dynamic_node_env
COPY . .
RUN npm ci

EXPOSE 8080
ENTRYPOINT ["npm"]
CMD ["start"]
