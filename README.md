# hub.docker.com/r/tiredofit/traefik

[![Build Status](https://img.shields.io/docker/build/tiredofit/traefik.svg)](https://hub.docker.com/r/tiredofit/traefik)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/traefik.svg)](https://hub.docker.com/r/tiredofit/traefik)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/traefik.svg)](https://hub.docker.com/r/tiredofit/traefik)
[![Docker Layers](https://images.microbadger.com/badges/image/tiredofit/traefik.svg)](https://microbadger.com/images/tiredofit/traefik)


# Introduction

This will build an image for [Traefik](https://traefik.io/) a modernized proxy built in go built for containerized service deployment.

* This Container uses a [customized Alpine Linux base](https://hub.docker.com/r/tiredofit/alpine) which includes [s6 overlay](https://github.com/just-containers/s6-overlay) enabled for PID 1 Init capabilities, [zabbix-agent](https://zabbix.org) for individual container monitoring, Cron also installed along with other tools (bash,curl, less, logrotate, nano, vim) for easier management. It also supports sending to external SMTP servers..

* Sane Defaults to have a working solution by just running the image
* Automatically generates configuration files on startup, or option to use your own
* Supports most traditional use cases w/Docker
* Choice of Logging (Console, File w/logrotation)

*This is an incredibly complex piece of software that will tries to get you up and running with sane defaults, you will need to switch eventually over to manually configuring the configuration file when depending on your usage case*

[Changelog](CHANGELOG.md)

# Authors

- [Dave Conroy](https://github.com/tiredofit)

# Table of Contents

- [Introduction](#introduction)
  - [Changelog](CHANGELOG.md)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
  - [Database](#database)
  - [Data Volumes](#data-volumes)
  - [Environment Variables](#environmentvariables)
  - [Networking](#networking)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
- [References](#references)

# Prerequisites

You must have access to create records on your DNS server to be able to fully use this image. While it will work locally, things like certificate issuing via LetsEncrypt will fail without proper resolving DNS.


# Installation

Automated builds of the image are available on [Docker Hub](https://hub.docker.com/tiredofit/traefik) and is the 
recommended method of installation.


```bash
docker pull tiredofit/traefik:<tag>
```

The following image tags are available:

* `latest` - Traefik 1.7.x Branch w/Alpine Linux
* `1.7-latest` - Traefik 1.7.x Branch w/Alpine Linux
* `2.0-latest` - Traefil 2.0 Alpha Branch w/Alpine Linux

# Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.


* Set various [environment variables](#environment-variables) to understand the capabilities of this image. A Sample `docker-compose.yml` is provided that will work right out of the box for most people without any fancy optimizations.

* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.

Once run, visit the newly created DNS entry and you should see the Traefik Dashboard

# Configuration

### Persistent Storage

The following directories/files should be mapped for persistent storage in order to utilize the container effectively.

| Folder    | Description |
|-----------|-------------|
| `/traefik/config` | (Optional) - LemonLDAP core configuration files. Auto Generates on Container startup |
| `/traefik/logs` | (Optional) - Logfiles if you wish to store to files |
| `/traefik/certs` | (Optional) - If you wish to utilize ACME/LetsEncrypt Certificates or SSL map this directory |
| `/var/run/docker.sock` | Easiest way to get going - Map the hosts docker socket to the container |

### Environment Variables

Along with the Environment Variables from the [Base image](https://hub.docker.com/r/tiredofit/alpine),  below is the complete list of available options that can be used to customize your installation.

There are a huge amount of configuration variables and it is recommended that you get comfortable for a few hours with the [Traefik Documentation](https://docs.traefik.io)

You will eventually based on your usage case switch over to `SETUP_TYPE=MANUAL` and edit your own `config.toml`. While I've tried to make this as easy to use as possible, once in production you'll find much better success with large implementations with this approach.

By Default this image is ready to run out of the box, without having to alter any of the settings with the exception of the `docker-compose.yml` hostname/domainname variables/labels.

#### General Settings

| Parameter | Description |
|-----------|-------------|
| `SETUP_TYPE` | Default: `AUTO` to auto generate config.toml on bootup, otherwise let admin control configuration. Set to `MANUAL` to stop auto generating|
| `CONFIG_FILE` | Configuration file to load - Default `config.toml`  |
| `CHECK_NEW_VERSION` | Check for new Traefik Release - Default `FALSE` |
| `SEND_ANONYMOUS_USAGE` | Send Anonymous Usage Stats - Default `FALSE` |

#### Logging Settings

| Parameter | Description |
|-----------|-------------|
| `ACCESS_LOG_FILE` | Location to store Access Log - Default `/traefik/logs/access.log` |
| `ACCESS_LOG_FORMAT` | Format to store logs in `common` / `json` - Default `common` |
| `ACCESS_LOG_TYPE` | Display logs via `CONSOLE` or write to `FILE` - Default `CONSOLE` |
| `TRAEFIK_LOG_FILE` | Location to store Access Log - Default `/traefik/logs/traefik.log` |
| `TRAEFIK_LOG_FORMAT` | Format to store logs in `common` / `json` - Default `common` |
| `TRAEFIK_LOG_TYPE` | Display logs via `CONSOLE` or write to `FILE` - Default `CONSOLE` |
| `TRAEFIK_LOG_LEVEL` | Log levels `DEBUG` `INFO` `WARN` `ERROR` `FATAL` - Default `ERROR` |

#### Docker Settings

| Parameter | Description |
|-----------|-------------|
| `ENABLE_DOCKER` | Enable Docker Mode - Default `TRUE`
| `DOCKER_ENDPOINT` | How to connect to Docker - Default `unix:///var/run/docker.sock` |
| `DOCKER_DEFAULT_HOST_RULE` | Docker Access rule - Default ` ` |
| `ENABLE_DOCKER_SWARM_MODE` | Enable Swarm Mode - Default `FALSE` |
| `DOCKER_SWARM_MODE_REFRESH` | Swarm refresh in seconds - Default `15` |
| `DOCKER_EXPOSE_CONTAINERS` | Expose Containers by Default - Default `FALSE` |

#### HTTP/HTTPS Settings

| Parameter | Description |
|-----------|-------------|
| `ENABLE_HTTP` | Enable HTTP Support - Default `TRUE` |
| `HTTP_LISTEN_IP` | Address to bind for HTTP - Default `empty` |
| `HTTP_LISTEN_PORT` | Port to bind for HTTP - Default `80` |
| `ENABLE_COMPRESSION_HTTP` | Enable Gzip Compression - Default `TRUE` |
| `ENABLE_HTTP_PROXY_PROTOCOL` | Enable HTTP Proxy Protocol Support - Default `FALSE` |
| `ENABLE_HTTPS` | Enable HTTPS Support - Default `TRUE` |
| `HTTPS_LISTEN_IP` | Address to bind for HTTP - Default `empty` |
| `HTTPS_LISTEN_PORT` | Port to bind for HTTPS - Default `443` |
| `ENABLE_COMPRESSION_HTTPS` | Enable Gzip Compression - Default `TRUE` |
| `ENABLE_HTTPS_UPGRADE` | Automatically forward HTTP -> HTTPS - Default `TRUE`
| `ENABLE_HTTPS_SNI_STRICT` | Enable Strict SNI Checking for Certificates - Default `FALSE` |
| `ENABLE_HTTPS_PROXY_PROTOCOL` | Enable HTTP Proxy Protocol Support - Default `FALSE` |
| `TRUSTED_IPS` | Use for Proxy Protocol Variables - Comma Seperated. Default - `127.0.0.1/32,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16` |
| `TLS_MINIMUM_VERSION` | Set TLS Minimum Version for HTTPS - Default `VersionTLS12` |
| `TLS_CIPHERS` | Set Ciphers - Default `TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA,TLS_ECDHE_RSA_WITH_3DES_EDE_CBC_SHA,TLS_RSA_WITH_AES_128_GCM_SHA256,TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_128_CBC_SHA,TLS_RSA_WITH_AES_256_CBC_SHA` |

#### LetsEncrypt Settings

| Parameter | Description |
|-----------|-------------|
| `ENABLE_LETSENCRYPT` | Enable LetsEncrypt Certificate Generation - Default `TRUE`
| `LETSENCRYPT_EMAIL` | Email address to register with Letsencrypt |
| `LETSENCRYPT_CHALLENGE` | Use `HTTP`, `TLS`, or `DNS` Challenges - Default `HTTP` |
| `LETSENCRYPT_ONHOST_GENERATE` | Dynamically Generate Certificates on start of container - Default `TRUE` |
| `LETSENCRYPT_ONDEMAND_GENERATE` | Dynamically Generate Certificates on First Load of site - Default `FALSE` |
| `LETSENCRYPT_KEYTYPE` | Keytype to use `EC256` `EC384` `RSA2048` `RSA4096` `RSA8192` - Default `RSA4096` |
| `LETSENCRYPT_SERVER` | Use `PRODUCTION` or `STAGING` server - Default `PRODUCTION` |
| `LETSENCRYPT_STORAGE` | Where to store Acme certificates - Default `/traefik/certs/acme.json` |
| `LETSENCRYPT_DNS_PROVIDER` | See [Traefik Documentation](https://docs.traefik.io) for values if using `DNS` Challenge |
| `LETSENCRYPT_DNS_RESOLVER` | Comma Seperated values values if using `DNS` Challenge e.g. `1.1.1.1:53,1.0.0.1:53` |
| `LETSENCRYPT_DNS_CHALLENGE_DELAY` | Wait for seconds before challengnging - Default `15` |
| `LETSENCRYPT_DNS_DOMAIN1_MAIN` | Single Value Domain Name for Wildcards e.g. `local1.com`
| `LETSENCRYPT_DNS_DOMAIN1_SANS` | Comma Seperated Values of Alternative Domains eg `test1.local1.com,test2.local1.com`
| `LETSENCRYPT_DNS_DOMAIN2_MAIN` | Similar to above, with additional number tacked on.. |
| `LETSENCRYPT_DNS_DOMAIN2_SANS` | Similar to above with additional number tacked on.. |

**If using DNS Challenges, you will need to add additional Environment Variables for your DNS servers API/credentials** See Traefik Documentation.

#### API / Dashboard Settings

| Parameter | Description |
|-----------|-------------|
| `ENABLE_API` | Enable Dashboard - Default `TRUE` |
| `API_ENTRYPOINT` | Entrypoint for API - Default `traefik` |
| `ENABLE_PING` | Enable Ping test/Health Check - Default `TRUE` |
| `PING_ENTRYPOINT` | Entrypoint for Ping test - Default `traefik` |
| `ENABLE_REST` | Enable REST functionality - Default `FALSE` |
| `REST_ENTRYPOINT` | Entrypoint for REST - Default `traefik` |
| `API_LISTEN_IP` | Address to bind for API/Dashboard - Default `empty` |
| `API_LISTEN_PORT` | Port to bind for API/Dashboard - Default `8080` |
| `ENABLE_DASHBOARD` | Enable Dashboard - Default `TRUE` |
| `ENABLE_DASHBOARD_AUTHENTICATION` | Enable Dashboard Authentication - Default `TRUE` |
| `DASHBOARD_ADMIN_USER` | Username for access to Dashboard - Default `admin` |
| `DASHBOARD_ADMIN_PASS` | Password for access to Dashboard - Default `traefik` |

      

### Networking

The following ports are exposed.

| Port      | Description |
|-----------|-------------|
| `80`      | HTTP        |
| `443`     | HTTPS       |

# Maintenance
#### Shell Access

For debugging and maintenance purposes you may want access the containers shell. 

```bash
docker exec -it (whatever your container name is e.g. traefik) bash
```

# References

* https://traefik.io
