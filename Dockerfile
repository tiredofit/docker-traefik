FROM tiredofit/alpine:3.12
LABEL maintainer="Dave Conroy (dave at tiredofit dot ca)"

### Set Defaults
ENV TRAEFIK_VERSION=2.2.3 \
    TRAEFIK_MIGRATION_TOOL_VERSION=0.12.1 \
    TRAEFIK_CERT_DUMPER_VERSION=2.7.0 \
    ENABLE_SMTP=FALSE

### Download Traefik
RUN set -x && \
    apk update && \
    apk upgrade && \
    apk add -t .traefik-run-deps \
            apache2-utils \
            && \
    \
    curl -sSL https://github.com/containous/traefik/releases/download/v${TRAEFIK_VERSION}/traefik_v${TRAEFIK_VERSION}_linux_amd64.tar.gz | tar xvfz - -C /usr/local/bin traefik && \
    chmod +x /usr/local/bin/traefik && \
    \
### Download Certificate Dumper
    curl -sSL https://github.com/ldez/traefik-certs-dumper/releases/download/v${TRAEFIK_CERT_DUMPER_VERSION}/traefik-certs-dumper_v${TRAEFIK_CERT_DUMPER_VERSION}_linux_386.tar.gz | tar xvfz - -C /usr/local/bin traefik-certs-dumper && \
    chmod +x /usr/local/bin/traefik-certs-dumper && \
    \
### Download Traefik Migration Tool
    curl -sSL https://github.com/containous/traefik-migration-tool/releases/download/v${TRAEFIK_MIGRATION_TOOL_VERSION}/traefik-migration-tool_v${TRAEFIK_MIGRATION_TOOL_VERSION}_linux_386.tar.gz | tar xvfz - -C /usr/local/bin traefik-migration-tool && \
    chmod +x /usr/local/bin/traefik-migration-tool && \
    \
### Cleanup
    rm -rf /usr/src/* /var/tmp/* /var/cache/apk/*

### Networking Configuration
EXPOSE 80 443

### Assets
ADD install /

