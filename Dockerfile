FROM docker.io/tiredofit/alpine:3.16
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

### Set Defaults
ENV TRAEFIK_VERSION=2.7.3 \
    TRAEFIK_MIGRATION_TOOL_VERSION=0.13.4 \
    TRAEFIK_CERT_DUMPER_VERSION=2.8.1 \
    CONTAINER_ENABLE_MESSAGING=FALSE \
    IMAGE_NAME="tiredofit/traefik" \
    IMAGE_REPO_URL="https://github.com/tiredofit/docker-traefik/"

### Download Traefik
RUN set -x && \
    apk update && \
    apk upgrade && \
    apk add -t .traefik-run-deps \
            apache2-utils \
            && \
    \
## Multi Arch Support
    apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64) Arch='amd64' ;; \
		armv7) Arch='armv7' ;; \
        armhf) Arch='armv6' ;; \
		aarch64) Arch='arm64' ;; \
		*) Arch='386' ;; \
	esac; \
    \
    curl -sSL https://github.com/containous/traefik/releases/download/v${TRAEFIK_VERSION}/traefik_v${TRAEFIK_VERSION}_linux_${Arch}.tar.gz | tar xvfz - -C /usr/local/bin traefik && \
    chmod +x /usr/local/bin/traefik && \
    \
### Download Certificate Dumper
    curl -sSL https://github.com/ldez/traefik-certs-dumper/releases/download/v${TRAEFIK_CERT_DUMPER_VERSION}/traefik-certs-dumper_v${TRAEFIK_CERT_DUMPER_VERSION}_linux_${Arch}.tar.gz | tar xvfz - -C /usr/local/bin traefik-certs-dumper && \
    chmod +x /usr/local/bin/traefik-certs-dumper && \
    \
### Download Traefik Migration Tool
    curl -sSL https://github.com/containous/traefik-migration-tool/releases/download/v${TRAEFIK_MIGRATION_TOOL_VERSION}/traefik-migration-tool_v${TRAEFIK_MIGRATION_TOOL_VERSION}_linux_${Arch}.tar.gz | tar xvfz - -C /usr/local/bin traefik-migration-tool && \
    chmod +x /usr/local/bin/traefik-migration-tool && \
    \
### Cleanup
    rm -rf /usr/src/* /var/tmp/* /var/cache/apk/*

### Networking Configuration
EXPOSE 80 443

### Assets
ADD install /

