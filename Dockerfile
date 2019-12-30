FROM tiredofit/alpine:3.11
LABEL maintainer="Dave Conroy (dave at tiredofit dot ca)"

### Set Defaults
ENV TRAEFIK_VERSION=1.7.20 \
    TRAEFIK_CERT_DUMPER_VERSION=2.3.4 \
    DASHBOARD_ADMIN_USER=admin \
    DASHBOARD_ADMIN_PASS=traefik \
    ENABLE_API=TRUE \
    ENABLE_DASHBOARD=TRUE \
    ENABLE_DASHBOARD_AUTHENTICATION=TRUE \
    ENABLE_SMTP=FALSE

### Download Traefik
RUN set -x && \
    apk update && \
    apk upgrade && \
    apk add -t .traefik-run-deps \
            apache2-utils \
            jq \
            zabbix-utils \
            && \
    \
    curl -sSL https://github.com/containous/traefik/releases/download/v${TRAEFIK_VERSION}/traefik_linux-amd64 --output /usr/local/bin/traefik && \
    chmod +x /usr/local/bin/traefik && \
    \
### Download Certificate Dumper
    curl -ssL https://github.com/ldez/traefik-certs-dumper/releases/download/v${TRAEFIK_CERT_DUMPER_VERSION}/traefik-certs-dumper_v${TRAEFIK_CERT_DUMPER_VERSION}_linux_amd64.tar.gz | tar xvfz - -C /usr/local/bin traefik-certs-dumper && \
    chmod +x /usr/local/bin/traefik-certs-dumper && \
    \
### Cleanup
    rm -rf /usr/src/* /var/tmp/* /var/cache/apk/*

### Networking Configuration
EXPOSE 80 443

### Assets
ADD install /

