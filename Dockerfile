# Select initial base image
FROM debian:buster-slim
# Expose ports
EXPOSE 80
# Change working directory
WORKDIR /app
# Install utilities
RUN apt-get update
RUN apt-get -y install --no-install-recommends --no-install-suggests supervisor
# Copy binaries
COPY binaries/deno /usr/bin/deno
COPY binaries/caddy /usr/bin/caddy
# Change binary permissions
RUN chmod +x /usr/bin/deno
RUN chmod +x /usr/bin/caddy
# Copy configurations
COPY configurations/caddy /etc/caddy/Caddyfile
COPY configurations/supervisor /etc/supervisor/conf.d/supervisord.conf
# Configure entrypoint
ENTRYPOINT cd /etc/caddy && caddy start; deno $@;