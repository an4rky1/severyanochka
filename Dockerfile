FROM node:22-slim AS base
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable
WORKDIR /app

# --- STAGE 1: Pruner ---
FROM base AS pruner
ARG APP_NAME
COPY . .
RUN npx turbo prune ${APP_NAME} --docker

# --- STAGE 2: Installer ---
FROM base AS installer
COPY --from=pruner /app/out/json/ .
COPY --from=pruner /app/out/pnpm-lock.yaml ./pnpm-lock.yaml
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --frozen-lockfile

# --- STAGE 3: Builder ---
FROM base AS builder
ARG APP_NAME
COPY --from=installer /app .
COPY --from=pruner /app/out/full/ .
COPY turbo.json turbo.json
RUN pnpm turbo run build --filter=${APP_NAME}...
RUN pnpm prune --prod

# --- STAGE 4: Runner (ФИНАЛ) ---
FROM node:22-slim AS runner
ARG APP_NAME
ARG APP_PATH=apps
WORKDIR /app
ENV NODE_ENV=production
USER node

# Копируем ТОЛЬКО результат
COPY --from=builder --chown=node:node /app/${APP_PATH}/${APP_NAME}/dist ./dist
COPY --from=builder --chown=node:node /app/${APP_PATH}/${APP_NAME}/package.json ./package.json
COPY --from=builder --chown=node:node /app/node_modules ./node_modules

EXPOSE 3000
CMD ["node", "dist/main.js"]
