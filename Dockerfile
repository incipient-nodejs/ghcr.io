# Stage 1: Build
FROM node:22 AS builder

# Set working directory
WORKDIR /app

# Install pnpm
RUN npm install -g pnpm

# Copy only package.json and install dependencies
COPY package.json ./
RUN pnpm install

# Copy application code and build the application
COPY . .
RUN pnpm run build

# Stage 2: Production
FROM node:22-alpine

# Set working directory
WORKDIR /app

# Install pnpm
RUN npm install -g pnpm

# Copy only package.json and install production dependencies
COPY package.json ./
RUN pnpm install --prod

# Copy built application from builder stage
COPY --from=builder /app/dist ./dist

# Expose application port
EXPOSE 3000

# Start the application
CMD ["node", "dist/main"]
