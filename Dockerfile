# Select initial base image
FROM node:buster-slim
# Expose ports
EXPOSE 80
# Install CA
RUN apt-get update
RUN apt-get -y install ca-certificates
# Add caddy repository to apt sources
RUN echo "deb [trusted=yes] https://repo.fury.io/caddy/ /" > /etc/apt/sources.list.d/caddy.list
# Install caddy
RUN apt-get update
RUN apt-get -y install caddy=2.2.0
# Copy configurations
COPY configurations/caddy /etc/caddy/Caddyfile
# Create application directories
RUN mkdir /app /app/frontend /app/backend
# Change working directory
WORKDIR /app
# Configure entrypoint
ENTRYPOINT cd /etc/caddy && caddy start; cd /app/backend && node $0 $@;