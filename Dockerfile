# syntax=docker/dockerfile:1

ARG NODE_VERSION=16.16.0

FROM node:${NODE_VERSION}-alpine

WORKDIR /usr/src/app

# Download dependencies as a separate step to take advantage of Docker's caching.
# Leverage a cache mount to /root/.npm to speed up subsequent builds.
# Leverage a bind mounts to package.json and package-lock.json to avoid having to copy them into
# into this layer.
RUN --mount=type=bind,source=package.json,target=package.json \
    --mount=type=bind,source=package-lock.json,target=package-lock.json \
    --mount=type=cache,target=/root/.npm \
    npm ci

# Use production node environment by default.
ENV NODE_ENV production

# Copy the rest of the source files into the container
COPY . .

# Set permissions for the working directory and its contents
RUN chown -R node:node /usr/src/app

# Run the application as a non-root user.
USER node

# Transpile TypeScript code to JavaScript
RUN npm run build

# Expose the port that the application listens on.
EXPOSE 3000

# Run the application.
CMD ["node", "./dist/index.js"]
