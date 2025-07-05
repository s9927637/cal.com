# 選擇官方 Node LTS 版本作為基底
FROM node:18-alpine AS builder

# 設定工作目錄
WORKDIR /app

# 複製 package.json 及 yarn.lock
COPY package.json yarn.lock ./

# 安裝依賴
RUN corepack enable && yarn install --frozen-lockfile
RUN yarn install --frozen-lockfile

# 複製所有程式碼
COPY . .

# 建置 Cal.com (build web 和 api)
RUN yarn build

# 測試 build 是否成功 (可選)
# RUN yarn test

# ---- 產生正式映像 ----
FROM node:18-alpine AS runner

WORKDIR /app

# 複製 build 從 builder
COPY --from=builder /app ./

# 設定執行用戶 (可選安全最佳實務)
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# 暴露 Zeabur 預設埠口
EXPOSE 3000

# 啟動 Cal.com API 和 Web (next.js SSR)
CMD ["yarn", "start"]


