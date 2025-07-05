FROM node:18 AS builder

WORKDIR /app

# 複製全部檔案（package.json、yarn.lock 及 workspace）
COPY . .

# 啟用 corepack 並安裝依賴（immutable 確保 lockfile 不被修改）
RUN corepack enable && yarn install --immutable-cache

# 建置 Cal.com
RUN yarn build

# 測試建置（選擇性）
# RUN yarn test

FROM node:18 AS runner

WORKDIR /app

COPY --from=builder /app ./

RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

EXPOSE 3000

CMD ["yarn", "start"]
