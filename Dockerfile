# Select initial base image
FROM debian:buster-slim

# Set image metadata
LABEL maintainer="hey@nadav.app"
LABEL description="Base image for the Webhood template"

# Expose ports
EXPOSE 80

# Update package indexes
RUN apt update

# APT and GPG configurations
COPY configurations/gpg/node /etc/apt/trusted.gpg.d/node.gpg
COPY configurations/apt/node /etc/apt/sources.list.d/node.list
COPY configurations/gpg/caddy /etc/apt/trusted.gpg.d/caddy.gpg
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
COPY configurations/services/caddy /etc/caddy/Caddyfile