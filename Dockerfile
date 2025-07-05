# ─── Base Build ──────────────────────────────────────
FROM node:18 AS builder

WORKDIR /calcom

ARG NEXTAUTH_SECRET
ARG CALENDSO_ENCRYPTION_KEY
ARG DATABASE_URL
ARG NEXT_PUBLIC_WEBAPP_URL

ENV NEXTAUTH_SECRET=${NEXTAUTH_SECRET}
ENV CALENDSO_ENCRYPTION_KEY=${CALENDSO_ENCRYPTION_KEY}
ENV DATABASE_URL=${DATABASE_URL}
ENV NEXT_PUBLIC_WEBAPP_URL=${NEXT_PUBLIC_WEBAPP_URL}
ENV NODE_ENV=production
ENV BUILD_STANDALONE=true

COPY . .

RUN npm install -g yarn && yarn set version berry
RUN yarn config set httpTimeout 1200000

RUN yarn install
RUN yarn workspace @calcom/trpc run build
RUN yarn workspace @calcom/web run build

# ─── Runner ──────────────────────────────────────────
FROM node:18 AS runner

WORKDIR /calcom

COPY --from=builder /calcom .

ENV NODE_ENV=production
EXPOSE 3000

CMD ["yarn", "workspace", "@calcom/web", "start"]
