# Build stage
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy project files
COPY . .

# Build the project
RUN npm run build:public

# Production stage
FROM node:20-alpine

WORKDIR /app

# Install a simple HTTP server
RUN npm install -g http-server

# Copy built files from builder
COPY --from=builder /app/public ./public

# Expose port
EXPOSE 8080

# Start HTTP server serving the public directory
CMD ["http-server", "public", "-p", "8080", "-c-1", "--gzip"]
