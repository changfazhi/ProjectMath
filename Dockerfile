# Multi-stage build: Vite frontend + tsc backend → one runtime image where Express
# serves both the API (incl. Socket.IO) and the built frontend, all same-origin.
#
# Deploy: gcloud run deploy math-trainer --source . --max-instances=1 --session-affinity
# (see .planning/DEPLOYMENT.md — max-instances=1 is load-bearing: pairing state is in-memory)

FROM node:22-slim AS frontend-build
WORKDIR /build
COPY frontend/package*.json ./
RUN npm ci
COPY frontend/ ./
RUN npm run build

FROM node:22-slim AS backend-build
WORKDIR /build
COPY backend/package*.json ./
RUN npm ci
COPY backend/ ./
RUN npm run build

FROM node:22-slim
WORKDIR /app
ENV NODE_ENV=production
COPY backend/package*.json ./
RUN npm ci --omit=dev
COPY --from=backend-build /build/dist ./dist
COPY --from=frontend-build /build/dist ./public
# Cloud Run injects PORT (8080); index.ts reads process.env.PORT.
CMD ["node", "dist/index.js"]
