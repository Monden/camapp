# Node 16.x
ARG NODE_VERSION=16

# Build phase
FROM node:$NODE_VERSION AS builder

WORKDIR /app

# Prepare node_modules
COPY ./.yarn ./.yarn
COPY ./package.json ./yarn.lock .
RUN yarn install --production
# RUN yarn install --frozen-lockfile --production

# Run phase
FROM gcr.io/distroless/nodejs:$NODE_VERSION AS runner

WORKDIR /app

COPY --from=builder /app .

# Copy artifacts
COPY ./next.config.js .
COPY ./public ./public
COPY ./.next ./.next

CMD ["./node_modules/next/dist/bin/next", "start"]
