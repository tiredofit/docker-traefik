ARG DISTRO="alpine"
ARG DISTRO_VARIANT="3.17"

FROM docker.io/tiredofit/${DISTRO}:${DISTRO_VARIANT}
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ARG TRAEFIK_VERSION
ARG TRAEFIK_CERT_DUMPER_VERSION

ENV TRAEFIK_VERSION=${TRAEFIK_VERSION:-"2.9.5"} \
    TRAEFIK_CERT_DUMPER_VERSION=${TRAEFIK_CERT_DUMPER_VERSION:-"2.8.1"} \
    CONTAINER_ENABLE_MESSAGING=FALSE \
    IMAGE_NAME="tiredofit/traefik" \
    IMAGE_REPO_URL="https://github.com/tiredofit/docker-traefik/"

RUN source /assets/functions/00-container && \
    set -x && \
    package update && \
    package upgrade && \
    package install .traefik-run-deps \
            apache2-utils \
            && \
    \
## Multi Arch Support
    packageArch="$(package --print-arch)"; \
	case "$packageArch" in \
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
    package cleanup && \
    rm -rf /usr/src/* \
           /var/tmp/*

EXPOSE 80 443

COPY install /

