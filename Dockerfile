FROM node:18 AS builder

WORKDIR /app

COPY . .

ENV XDG_CACHE_HOME=/tmp/.cache

RUN mkdir -p /tmp/.cache

RUN corepack enable && yarn install --immutable

RUN yarn build
