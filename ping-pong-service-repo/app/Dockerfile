FROM node:18.16.0-alpine
WORKDIR /usr/ping-pong-service

COPY . .
RUN npm ci

EXPOSE 8080
ENTRYPOINT ["npm"]
CMD ["start"]
