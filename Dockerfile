ARG DISTRO="alpine"
ARG DISTRO_VARIANT="3.18"

FROM docker.io/tiredofit/${DISTRO}:${DISTRO_VARIANT}
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ARG TRAEFIK_VERSION
ARG TRAEFIK_CERT_DUMPER_VERSION

ENV TRAEFIK_VERSION=${TRAEFIK_VERSION:-"v2.10.7"} \
    TRAEFIK_CERT_DUMPER_VERSION=${TRAEFIK_CERT_DUMPER_VERSION:-"v2.8.1"} \
    TRAEFIK_REPO_URL=${TRAEFIK_REPO_URL:-"https://github.com/traefik/traefik"} \
    TRAEFIK_CERT_DUMPER_REPO_URL=${TRAEFIK_CERT_DUMPER_REPO_URL:-"https://github.com/ldez/traefik-certs-dumper"} \
    CONTAINER_ENABLE_MESSAGING=FALSE \
    IMAGE_NAME="tiredofit/traefik" \
    IMAGE_REPO_URL="https://github.com/tiredofit/docker-traefik/"

RUN source /assets/functions/00-container && \
    set -x && \
    addgroup -S -g 8080 traefik && \
    adduser -D -S -s /sbin/nologin \
            -h /dev/null \
            -G traefik \
            -g "traefik" \
            -u 8080 traefik \
            && \
    \
    package update && \
    package upgrade && \
    #package install .traefik-build-deps \
    #                go \
    #                make \
    #                nodejs \
    #                yarn \
    #                && \
    package install .traefik-cert-dumper-build-deps \
                    binutils \
                    go \
                    make \
                    && \
    package install .traefik-run-deps \
            apache2-utils \
            && \
    \
## Multi Arch Support
    packageArch="$(apk --print-arch)"; \
	case "$packageArch" in \
		x86_64) Arch='amd64' ;; \
		armv7) Arch='armv7' ;; \
        armhf) Arch='armv6' ;; \
		aarch64) Arch='arm64' ;; \
		*) Arch='386' ;; \
	esac; \
    \
    #clone_git_repo "${TRAEFIK_REPO_URL}" "${TRAEFIK_VERSION}" && \
    #cd web-ui && \
    #NODE_ENV=production yarn install && \
    #NODE_ENV=production yarn build && \
    #go generate && \
    #go build ./cmd/traefik && \
    curl -sSL https://github.com/containous/traefik/releases/download/${TRAEFIK_VERSION}/traefik_${TRAEFIK_VERSION}_linux_${Arch}.tar.gz | tar xvfz - -C /usr/local/bin traefik && \
    chmod +x /usr/local/bin/traefik && \
    \
### Download Certificate Dumper
    clone_git_repo "${TRAEFIK_CERT_DUMPER_REPO_URL}" "${TRAEFIK_CERT_DUMPER_VERSION}" && \
    sed -i -e "s|keyPath, cert.Key, 0o600|keyPath, cert.Key, 0o644|g" dumper/*/dumper.go && \
    make build && \
    strip traefik-certs-dumper && \
    cp traefik-certs-dumper /usr/sbin/ && \
    \
    package remove \
                    #.traefik-build-deps \
                    .traefik-cert-dumper-build-deps \
                    && \
    package cleanup && \
    rm -rf \
            /root/.cache \
            /root/go \
            /usr/src/*


EXPOSE 80 443

COPY install /
