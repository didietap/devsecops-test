# ---- Builder ----
FROM node:20-bullseye AS builder
WORKDIR /app

# reduce layer size
COPY package.json package-lock.json* ./
RUN npm ci --silent

COPY tsconfig*.json ./
COPY src ./src

RUN npm run build

# ---- Runtime ----
FROM node:20-bullseye-slim AS runtime
# create non-root user
RUN useradd --uid 1001 --create-home --shell /bin/bash appuser

WORKDIR /app
COPY --from=builder /app/package.json /app/package-lock.json* /app/
COPY --from=builder /app/dist ./dist
RUN npm ci --production --silent

# fix permissions
RUN chown -R appuser:appuser /app
USER appuser

ENV NODE_ENV=production
EXPOSE 3000

HEALTHCHECK --interval=15s --timeout=3s --start-period=10s \
  CMD wget --quiet --tries=1 --spider http://localhost:3000/health || exit 1

CMD ["node", "dist/main.js"]
