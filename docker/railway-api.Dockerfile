FROM node:24-bookworm-slim

RUN apt update && apt -y install python3 make gcc g++ && rm -rf /var/lib/apt/lists/*

WORKDIR /duelyst
COPY . /duelyst

RUN corepack enable
RUN yarn set version berry
RUN yarn install && yarn cache clean

ARG FIREBASE_URL
ARG API_URL
ARG SP_SERVER_URL
ARG GAME_SERVER_URL

ENV NODE_ENV=production
ENV FIREBASE_URL=${FIREBASE_URL}
ENV API_URL=${API_URL}
ENV SP_SERVER_URL=${SP_SERVER_URL}
ENV GAME_SERVER_URL=${GAME_SERVER_URL}

RUN yarn tsc:chroma-js
RUN yarn build:withallrsx

ENV NODE_ENV=development

EXPOSE 3000
CMD ["node", "./bin/api"]
