# Stage 1: Build the application
# We use the standard node image for the build stage to ensure all build tools are present
FROM node:20 AS builder

WORKDIR /app

# Copy package files
COPY app/package.json app/package-lock.json ./

# Install dependencies with legacy-peer-deps to handle React/MUI conflicts
RUN npm install --legacy-peer-deps

# Copy source code
COPY app/ .

# Build the application
RUN npm run build

# Stage 2: Serve the application with Nginx
FROM nginx:alpine

# Copy built assets from builder stage to Nginx html directory
COPY --from=builder /app/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Nginx runs automatically, no CMD needed
