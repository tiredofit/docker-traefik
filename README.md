# hub.docker.com/r/tiredofit/traefik

[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/traefik.svg)](https://hub.docker.com/r/tiredofit/traefik)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/traefik.svg)](https://hub.docker.com/r/tiredofit/traefik)
[![Docker Layers](https://images.microbadger.com/badges/image/tiredofit/traefik.svg)](https://microbadger.com/images/tiredofit/traefik)

## Introduction

This will build an image for [Traefik](https://traefik.io/) a modernized proxy built in go built for containerized service deployment.

* This Container uses a [customized Alpine Linux base](https://hub.docker.com/r/tiredofit/alpine) which includes [s6 overlay](https://github.com/just-containers/s6-overlay) enabled for PID 1 Init capabilities, [zabbix-agent](https://zabbix.org) for individual container monitoring, Cron also installed along with other tools (bash,curl, less, logrotate, nano, vim) for easier management. It also supports sending to external SMTP servers..

* Sane Defaults to have a working solution by just running the image
* Automatically generates configuration files on startup, or option to use your own
* Supports most traditional use cases w/Docker
* Choice of Logging (Console, File w/logrotation)

*This is an incredibly complex piece of software that will tries to get you up and running with sane defaults, you will need to switch eventually over to manually configuring the configuration file when depending on your usage case*

[Changelog](CHANGELOG.md)

## Authors

- [Dave Conroy](https://github.com/tiredofit)

## Table of Contents

- [Introduction](#introduction)
- [Authors](#authors)
- [Table of Contents](#table-of-contents)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
  - [Quick Start](#quick-start)
- [Configuration](#configuration)
  - [Persistent Storage](#persistent-storage)
  - [Environment Variables](#environment-variables)
    - [General Settings](#general-settings)
    - [Logging Settings](#logging-settings)
    - [Docker Settings](#docker-settings)
    - [HTTP/HTTPS Settings](#httphttps-settings)
    - [LetsEncrypt Settings](#letsencrypt-settings)
    - [API / Dashboard Settings](#api--dashboard-settings)
    - [Certificate Dumper Settings](#certificate-dumper-settings)
  - [Networking](#networking)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
- [References](#references)

## Prerequisites

You must have access to create records on your DNS server to be able to fully use this image. While it will work locally, things like certificate issuing via LetsEncrypt will fail without proper resolving DNS.


## Installation

Automated builds of the image are available on [Docker Hub](https://hub.docker.com/tiredofit/traefik) and is the
recommended method of installation.


```bash
docker pull tiredofit/traefik:<tag>
```

The following image tags are available:

* `latest` - Traefik 2.2.x Branch w/Alpine Linux
* `1.7-latest` - Traefik 1.7.x Branch w/Alpine Linux
* `2.2-latest` - Traefik 2.2 w/Alpine Linux

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.


* Set various [environment variables](#environment-variables) to understand the capabilities of this image. A Sample `docker-compose.yml` is provided that will work right out of the box for most people without any fancy optimizations.

* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.

_This image in it's auto configured state allows for using less labels than usual. This is what I use in my produciton environments, and if I need to add more configuration options I do, but if you are simply using as an HTTP/HTTPS reverse proxy you can get by with the bare minimum on your proxied containers as such:

````bash
      - traefik.enable=true
      - traefik.http.routers.whoami.rule=Host(`whoami.example.com`) || Host(`whoami2.example.com`)
      - traefik.http.services.whoami.loadbalancer.server.port=80
````

## Configuration

### Persistent Storage

The following directories/files should be mapped for persistent storage in order to utilize the container effectively.

| Folder                   | Description                                                                                         |
| ------------------------ | --------------------------------------------------------------------------------------------------- |
| `/traefik/config`        | (Optional) - Traefik core configuration files. Auto Generates on Container startup                  |
| `/traefik/config/custom` | (Optional) - If using manual mode and wish to add dynamic File configuration, add it in here (.yml) |
| `/traefik/logs`          | (Optional) - Logfiles if you wish to store to files                                                 |
| `/traefik/certs`         | (Optional) - If you wish to utilize ACME/LetsEncrypt Certificates or SSL map this directory         |
| `/var/run/docker.sock`   | Easiest way to get going - Map the hosts docker socket to the container                             |

### Environment Variables

Along with the Environment Variables from the [Base image](https://hub.docker.com/r/tiredofit/alpine),  below is the complete list of available options that can be used to customize your installation.

There are a huge amount of configuration variables and it is recommended that you get comfortable for a few hours with the [Traefik Documentation](https://docs.traefik.io)

You will eventually based on your usage case switch over to `SETUP_TYPE=MANUAL` and edit your own `config.yml`. While I've tried to make this as easy to use as possible, once in production you'll find much better success with large implementations with this approach.

By Default this image is ready to run out of the box, without having to alter any of the settings with the exception of the `docker-compose.yml` hostname/domainname variables/labels.

#### General Settings
| Parameter              | Description                                                                                                                                | Default       |
| ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ | ------------- |
| `SETUP_TYPE`           | Default: `AUTO` to auto generate config.toml on bootup, otherwise let admin control configuration. Set to `MANUAL` to stop auto generating |
| `CONFIG_FILE`          | Configuration file to load                                                                                                                 | `config.toml` |
| `CHECK_NEW_VERSION`    | Check for new Traefik Release                                                                                                              | `FALSE`       |
| `SEND_ANONYMOUS_USAGE` | Send Anonymous Usage Stats                                                                                                                 | `FALSE`       |

#### Logging Settings
| Parameter                    | Description                                                     | Default                     |
| ---------------------------- | --------------------------------------------------------------- | --------------------------- |
| `ACCESS_LOG_FILE`            | File to store access log - Same directory as `TRAEFIK_LOG_PATH` | `access.log`                |
| `ACCESS_LOG_FORMAT`          | Format to store logs in `common` / `json`                       | `common`                    |
| `ACCESS_LOG_TYPE`            | Display logs via `CONSOLE` or write to `FILE`                   | `CONSOLE`                   |
| `TRAEFIK_CONFIG_FILE`        | Traefik config file                                             | `config.yml`                |
| `TRAEFIK_CONFIG_PATH`        | Path where configuration stored                                 | `/traefik/config/`          |
| `TRAEFIK_CONFIG_CUSTOM_PATH` | Where to store custom/dynamic files                             | `/traefik/config/custom/`   |
| `TRAEFIK_LOG_FILE`           | File to store Traefik Log                                       | `/traefik/logs/traefik.log` |
| `TRAEFIK_LOG_PATH`           | Path to store Traefik logs                                      | `/traefik/logs/`            |
| `TRAEFIK_LOG_FORMAT`         | Format to store logs in `common` / `json`                       | `common`                    |
| `TRAEFIK_LOG_TYPE`           | Display logs via `CONSOLE` or write to `FILE`                   | `CONSOLE`                   |
| `TRAEFIK_LOG_LEVEL`          | Log levels `DEBUG` `INFO` `WARN` `ERROR` `FATAL`                | `ERROR`                     |

#### Docker Settings
| Parameter                   | Description                                                 | Default                       |
| --------------------------- | ----------------------------------------------------------- | ----------------------------- |
| `ENABLE_DOCKER`             | Enable Docker Mode                                          | `TRUE`                        |
| `DOCKER_ENDPOINT`           | How to connect to Docker                                    | `unix:///var/run/docker.sock` |
| `DOCKER_CONSTANTS`          | Docker Constraints                                          | `""`                          |
| `DOCKER_DEFAULT_HOST_RULE`  | Docker Access rule - Default: Host(`{{ normalize .Name }}`) |                               |
| `DOCKER_DEFAULT_NETWORK`    | Default Network for Traefik to operate on                   | `proxy`                       |
| `ENABLE_DOCKER_SWARM_MODE`  | Enable Swarm Mode                                           | `FALSE`                       |
| `DOCKER_SWARM_MODE_REFRESH` | Swarm refresh in seconds                                    | `15`                          |
| `DOCKER_EXPOSE_CONTAINERS`  | Expose Containers by Default                                | `FALSE`                       |

#### HTTP/HTTPS Settings
| Parameter                        | Description                                                                                                          | Default                                                                                                                                                                                                                                   |
| -------------------------------- | -------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `ENABLE_HTTP`                    | Enable HTTP Support                                                                                                  | `TRUE`                                                                                                                                                                                                                                    |
| `HTTP_ENTRYPOINT`                | Name of HTTP Entrypoint                                                                                              | `web`                                                                                                                                                                                                                                     |
| `ENABLE_HTTP_FORWARDED_HEADERS`  | Enable HTTP Forwarded Headers                                                                                        | `FALSE`                                                                                                                                                                                                                                   |
| `HTTP_LISTEN_IP`                 | Address to bind for HTTP                                                                                             | `empty`                                                                                                                                                                                                                                   |
| `HTTP_LISTEN_PORT`               | Port to bind for HTTP                                                                                                | `80`                                                                                                                                                                                                                                      |
| `HTTP_TIMEOUT_ACCEPTGRACE`       | Accept Grace Timeout                                                                                                 | `0`                                                                                                                                                                                                                                       |
| `HTTP_TIMEOUT_GRACE`             | Grace Timeout                                                                                                        | `10`                                                                                                                                                                                                                                      |
| `HTTP_TIMEOUT_IDLE`              | Idle Timeout                                                                                                         | `180`                                                                                                                                                                                                                                     |
| `HTTP_TIMEOUT_READ`              | Read Timeout                                                                                                         | `0`                                                                                                                                                                                                                                       |
| `HTTP_TIMEOUT_WRITE`             | Write Timeout                                                                                                        | `0`                                                                                                                                                                                                                                       |
| `ENABLE_COMPRESSION_HTTP`        | Enable Gzip Compression                                                                                              | `TRUE`                                                                                                                                                                                                                                    |
| `ENABLE_HTTP_PROXY_PROTOCOL`     | Enable HTTP Proxy Protocol Support                                                                                   | `FALSE`                                                                                                                                                                                                                                   |
| `ENABLE_HTTPS`                   | Enable HTTPS Support                                                                                                 | `TRUE`                                                                                                                                                                                                                                    |
| `HTTPS_ENTRYPOINT`               | Name of HTTP Entrypoint                                                                                              | `websecure`                                                                                                                                                                                                                               |
| `ENABLE_HTTPS_FORWARDED_HEADERS` | Enable HTTPS Forwarded Headers                                                                                       | `FALSE`                                                                                                                                                                                                                                   |
| `HTTPS_LISTEN_IP`                | Address to bind for HTTP                                                                                             | `empty`                                                                                                                                                                                                                                   |
| `HTTPS_LISTEN_PORT`              | Port to bind for HTTPS                                                                                               | `443`                                                                                                                                                                                                                                     |
| `HTTPS_TIMEOUT_ACCEPTGRACE`      | Accept Grace Timeout                                                                                                 | `0`                                                                                                                                                                                                                                       |
| `HTTPS_TIMEOUT_GRACE`            | Grace Timeout                                                                                                        | `10`                                                                                                                                                                                                                                      |
| `HTTPS_TIMEOUT_IDLE`             | Idle Timeout                                                                                                         | `180`                                                                                                                                                                                                                                     |
| `HTTPS_TIMEOUT_READ`             | Read Timeout                                                                                                         | `0`                                                                                                                                                                                                                                       |
| `HTTPS_TIMEOUT_WRITE`            | Write Timeout                                                                                                        | `0`                                                                                                                                                                                                                                       |
| `ENABLE_COMPRESSION_HTTPS`       | Enable Gzip Compression                                                                                              | `TRUE`                                                                                                                                                                                                                                    |
| `ENABLE_HTTPS_UPGRADE`           | Automatically forward HTTP -> HTTPS                                                                                  | `TRUE`                                                                                                                                                                                                                                    |
| `ENABLE_HTTPS_SNI_STRICT`        | Enable Strict SNI Checking for Certificates                                                                          | `FALSE`                                                                                                                                                                                                                                   |
| `ENABLE_HTTPS_PROXY_PROTOCOL`    | Enable HTTP Proxy Protocol Support                                                                                   | `FALSE`                                                                                                                                                                                                                                   |
| `TRUSTED_IPS`                    | Use for Proxy Protocol Variables - Comma Seperated. Default - `127.0.0.1/32,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16` |
| `TLS_MINIMUM_VERSION`            | Set TLS Minimum Version for HTTPS                                                                                    | `VersionTLS12`                                                                                                                                                                                                                            |
| `TLS_CIPHERS`                    | Set Ciphers                                                                                                          | `TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305` |

#### LetsEncrypt Settings
| Parameter                         | Description                                                                              | Default      |
| --------------------------------- | ---------------------------------------------------------------------------------------- | ------------ |
| `ENABLE_LETSENCRYPT`              | Enable LetsEncrypt Certificate Generation                                                | `TRUE`       |
| `LETSENCRYPT_EMAIL`               | Email address to register with Letsencrypt                                               |
| `LETSENCRYPT_CHALLENGE`           | Use `HTTP`, `TLS`, or `DNS` Challenges                                                   | `HTTP`       |
| `LETSENCRYPT_KEYTYPE`             | Keytype to use `EC256` `EC384` `RSA2048` `RSA4096` `RSA8192`                             | `RSA4096`    |
| `LETSENCRYPT_SERVER`              | Use `PRODUCTION` or `STAGING` server                                                     | `PRODUCTION` |
| `LETSENCRYPT_STORAGE_FILE`        | What file to store ACME certificates in                                                  | `acme.json`  |
| `LETSENCRYPT_STORAGE_PATH`        | What path to store ACME certificates in: `/traefik/certs/`                               |
| `LETSENCRYPT_DNS_PROVIDER`        | See [Traefik Documentation](https://docs.traefik.io) for values if using `DNS` Challenge |
| `LETSENCRYPT_DNS_RESOLVER`        | Comma Seperated values values if using `DNS` Challenge e.g. `1.1.1.1:53,1.0.0.1:53`      |
| `LETSENCRYPT_DNS_CHALLENGE_DELAY` | Wait for seconds before challenging                                                      | `15`         |
| `LETSENCRYPT_DNS_DOMAIN1_MAIN`    | Single Value Domain Name for Wildcards e.g. `local1.com`                                 |
| `LETSENCRYPT_DNS_DOMAIN1_SANS`    | Comma Seperated Values of Alternative Domains eg `test1.local1.com,test2.local1.com`     |
| `LETSENCRYPT_DNS_DOMAIN2_MAIN`    | Similar to above, with additional number tacked on..                                     |
| `LETSENCRYPT_DNS_DOMAIN2_SANS`    | Similar to above with additional number tacked on..                                      |

**If using DNS Challenges, you will need to add additional Environment Variables for your DNS servers API/credentials** See Traefik Documentation.

#### API / Dashboard Settings

| Parameter                         | Description                                                  | Default   |
| --------------------------------- | ------------------------------------------------------------ | --------- |
| `ENABLE_API`                      | Enable Dashboard                                             | `TRUE`    |
| `ENABLE_PING`                     | Enable Ping test/Health Check                                | `TRUE`    |
| `ENABLE_DASHBOARD`                | Enable Dashboard                                             | `TRUE`    |
| `DASHBOARD_HOSTNAME`              | Hostname to respond for Dashboard e.g. `traefik.example.com` |
| `ENABLE_DASHBOARD_AUTHENTICATION` | Enable Dashboard Authentication                              | `TRUE`    |
| `DASHBOARD_ADMIN_USER`            | Username for access to Dashboard                             | `admin`   |
| `DASHBOARD_ADMIN_PASS`            | Password for access to Dashboard                             | `traefik` |
| `DASHBOARD_AUTHENTICATION`        | Only type is `BASIC` at this time                            |           |

#### Certificate Dumper Settings

| Parameter                         | Description                                                                                                                                                       | Default                            |
| --------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------- |
| `ENABLE_CERTIFICATE_DUMPER`       | Enable Dumping of Certificates from acme.json                                                                                                                     | `TRUE`                             |
| `CERTIFICATE_DUMPER_PATH`         | Where to put the dumped certificates                                                                                                                              | `${LETSENCRYPT_STORAGE_PATH}/dump` |
| `CERTIFICATE_DUMPER_POST_HOOK`    | *optional* Argument or external script to execute post dumping of certificates Where to put the dumped certificates - e.g. `chmod 644 ${CERTIFICATE_DUMPER_PATH}` |
| `CERTIFICATE_DUMP_SUBDIRECTORIES` | Create subdirectories of hosts                                                                                                                                    | `TRUE`                             |
| `CLEAN_DUMP_PATH`                 | Clean Dump path before redumping                                                                                                                                  | `FALSE`                            |

### Networking

The following ports are exposed.

| Port  | Description |
| ----- | ----------- |
| `80`  | HTTP        |
| `443` | HTTPS       |

## Maintenance
### Shell Access

For debugging and maintenance purposes you may want access the containers shell.

```bash
docker exec -it (whatever your container name is e.g. traefik) bash
```

## References

* https://traefik.io
