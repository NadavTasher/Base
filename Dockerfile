# Select initial base image
FROM node:buster-slim

# Set image metadata
LABEL maintainer="hey@nadav.app"
LABEL description="A simple Node & Caddy base image."

# Expose ports
EXPOSE 80

# Update package indexes and install certificates
RUN apt-get update
RUN apt-get -y install ca-certificates

# Add Caddy's Gemfury repository to apt sources
RUN echo "deb [trusted=yes] https://repo.fury.io/caddy/ /" > /etc/apt/sources.list.d/caddy.list

# Update package indexes and install caddy
RUN apt-get update
RUN apt-get -y install caddy

# Copy configurations
COPY configurations/node /tmp/default.mjs
COPY configurations/caddy /etc/caddy/Caddyfile

# Create application directories
RUN mkdir /app /app/frontend /app/backend

# Change working directory
WORKDIR /app

# Configure entrypoint
ENTRYPOINT cd /etc/caddy; caddy start > /dev/null 2>&1; cd /app/backend; node $0;

# Configure command
CMD ["/tmp/default.mjs"]