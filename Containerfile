# SPDX-FileCopyrightText: © 2026 Nfrastack <code@nfrastack.com>
#
# SPDX-License-Identifier: MIT

ARG \
    BASE_IMAGE

FROM ${BASE_IMAGE}

LABEL \
        org.opencontainers.image.title="Traefik" \
        org.opencontainers.image.description="Reverse proxy and ingress controller" \
        org.opencontainers.image.url="https://hub.docker.com/r/nfrastack/traefik" \
        org.opencontainers.image.documentation="https://github.com/nfrastack/container-traefik/blob/main/README.md" \
        org.opencontainers.image.source="https://github.com/nfrastack/container-traefik.git" \
        org.opencontainers.image.authors="Nfrastack <code@nfrastack.com>" \
        org.opencontainers.image.vendor="Nfrastack <https://www.nfrastack.com>" \
        org.opencontainers.image.licenses="MIT"
ARG \
    TRAEFIK_VERSION="v3.6.20" \
    TRAEFIK_CERT_DUMPER_VERSION="v2.11.2" \
    TRAEFIK_REPO_URL="https://github.com/traefik/traefik" \
    TRAEFIK_CERT_DUMPER_REPO_URL="https://github.com/ldez/traefik-certs-dumper"

ENV \
    CONTAINER_ENABLE_SCHEDULING=TRUE \
    IMAGE_NAME="nfrastack/traefik" \
    IMAGE_REPO_URL="https://github.com/nfrastack/container-traefik/"

COPY CHANGELOG.md /usr/src/container/CHANGELOG.md
COPY LICENSE /usr/src/container/LICENSE
COPY README.md /usr/src/container/README.md

RUN echo "" && \
    TRAEFIKCERTDDUMPER_BUILD_DEPS_ALPINE=" \
                                            binutils \
                                            make \
                                        " \
                                        && \
    TRAEFIK_RUN_DEPS_ALPINE=" \
                                apache2-utils \
                                inotify-tools \
                            " \
                            && \
    \
    source /container/base/functions/container/build && \
    container_build_log image && \
    create_user traefik 8080 traefik 8080 /dev/null && \
    package update && \
    package upgrade && \
    package install \
                        TRAEFIKCERTDDUMPER_BUILD_DEPS \
                        TRAEFIK_RUN_DEPS \
                        && \
    package build go buildtime && \
    package build yq && \
    \
    case "$(container_info arch)" in \
        x86_64 | amd64) Arch='amd64' ;; \
	aarch64 | arm64) Arch='arm64' ;; \
    esac; \
    \
    curl -sSL https://github.com/containous/traefik/releases/download/${TRAEFIK_VERSION}/traefik_${TRAEFIK_VERSION}_linux_${Arch}.tar.gz | tar xvfz - -C /usr/local/bin traefik && \
    chmod +x /usr/local/bin/traefik && \
    \
    container_build_log add "Traefik" "${TRAEFIK_VERSION}" "${TRAEFIK_REPO_URL}" && \
    clone_git_repo "${TRAEFIK_CERT_DUMPER_REPO_URL}" "${TRAEFIK_CERT_DUMPER_VERSION}" && \
    sed -i -e "s|keyPath, cert.Key, 0o600|keyPath, cert.Key, 0o644|g" dumper/*/dumper.go && \
    make build && \
    strip traefik-certs-dumper && \
    cp traefik-certs-dumper /usr/local/bin/ && \
    container_build_log add "Traefik Cert Dumper" "${TRAEFIK_CERT_DUMPER_VERSION}" "${TRAEFIK_CERT_DUMPER_REPO_URL}" && \
    \
    package remove \
                    TRAEFIKCERTDDUMPER_BUILD_DEPS \
                    && \
    package cleanup

EXPOSE 80 443

COPY rootfs /
