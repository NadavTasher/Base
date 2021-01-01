# Select initial base image
FROM debian:buster-slim

# Set image metadata
LABEL maintainer="hey@nadav.app"
LABEL description="A simple Node & Caddy image."

# Expose ports
EXPOSE 80

# Update package indexes
RUN apt update

# APT and GPG configurations
COPY configurations/gpg/node /etc/apt/trusted.gpg.d/node.gpg
COPY configurations/apt/node /etc/apt/sources.list.d/node.list
COPY configurations/apt/caddy /etc/apt/sources.list.d/caddy.list

# Install CA certificates
RUN apt --yes install ca-certificates

# Update package indexes
RUN apt update

# Install Caddy & Node
RUN apt --yes install caddy nodejs

# Remove sources lists
RUN rm /etc/apt/sources.list.d/*

# Update package indexes
RUN apt update

# Copy configurations
COPY configurations/services/node /etc/node/default.mjs
COPY configurations/services/caddy /etc/caddy/Caddyfile

# Create application directories
RUN mkdir /project /project/frontend /project/backend

# Change working directory
WORKDIR /project

# Configure entrypoint
ENTRYPOINT cd /etc/caddy; caddy start > /dev/null 2>&1; cd /project/backend; node $0;

# Configure default command
CMD ["/etc/node/default.mjs"]