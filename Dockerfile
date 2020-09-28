# Select initial base image
FROM node:buster-slim

# Set image metadata
LABEL maintainer="hey@nadav.app"
LABEL description="A simple Node & Caddy base image."

# Expose ports
EXPOSE 80

# Install CA certificates for Gemfury
RUN apt-get update
RUN apt-get -y install ca-certificates

# Add Caddy's Gemfury repository to apt sources
RUN echo "deb [trusted=yes] https://repo.fury.io/caddy/ /" > /etc/apt/sources.list.d/caddy.list

# Install Caddy
RUN apt-get update
RUN apt-get -y install caddy=2.2.0

# Copy Caddy configuration
COPY configurations/caddy /etc/caddy/Caddyfile

# Copy default Node script
COPY configurations/default /tmp/default.mjs

# Create application directories
RUN mkdir /app /app/frontend /app/backend

# Change working directory
WORKDIR /app

# Configure entrypoint
ENTRYPOINT cd /etc/caddy && caddy start; cd /app/backend && node $0 $@;

# Configure command
CMD ["/tmp/default.mjs"]