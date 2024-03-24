ARG NODE_VERSION=20

FROM node:${NODE_VERSION}-alpine AS base

ARG PORT=3000

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
ENV NODE_ENV=production
RUN corepack enable

COPY . /app
WORKDIR /app

FROM base as build

RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --frozen-lockfile
RUN pnpm build

FROM base
COPY --from=build /app/.output /app/.output
EXPOSE $PORT
CMD ["node", ".output/server/index.mjs"]
