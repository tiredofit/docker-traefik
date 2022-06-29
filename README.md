# github.com/tiredofit/docker-traefik

[![GitHub release](https://img.shields.io/github/v/tag/tiredofit/docker-traefik?style=flat-square)](https://github.com/tiredofit/docker-traefik/releases/latest)
[![Build Status](https://img.shields.io/github/workflow/status/tiredofit/docker-traefik/build?style=flat-square)](https://github.com/tiredofit/docker-traefik/actions?query=workflow%3Abuild)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/traefik.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/traefik/)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/traefik.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/traefik/)
[![Become a sponsor](https://img.shields.io/badge/sponsor-tiredofit-181717.svg?logo=github&style=flat-square)](https://github.com/sponsors/tiredofit)
[![Paypal Donate](https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square)](https://www.paypal.me/tiredofit)

* * *
## About

This will build an image for [Traefik](https://traefik.io/) a modernized proxy built in GO built for containerized service deployment.

* Sane Defaults to have a working solution by just running the image
* Automatically generates configuration files on startup, or option to use your own
* Supports most traditional use cases w/Docker
* Choice of Logging (Console, File w/logrotation)

*This is an incredibly complex piece of software that will tries to get you up and running with sane defaults, you will need to switch eventually over to manually configuring the configuration file when depending on your usage case*

## Maintainer

- [Dave Conroy](https://github.com/tiredofit)

## Table of Contents

- [About](#about)
- [Maintainer](#maintainer)
- [Table of Contents](#table-of-contents)
- [Prerequisites and Assumptions](#prerequisites-and-assumptions)
- [Installation](#installation)
  - [Build from Source](#build-from-source)
  - [Prebuilt Images](#prebuilt-images)
    - [Multi Architecture](#multi-archictecture)
- [Configuration](#configuration)
  - [Quick Start](#quick-start)
  - [Persistent Storage](#persistent-storage)
  - [Environment Variables](#environment-variables)
    - [Base Images used](#base-images-used)
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
- [Contributions](#contributions)
- [Support](#support)
  - [Usage](#usage)
  - [Bugfixes](#bugfixes)
  - [Feature Requests](#feature-requests)
  - [Updates](#updates)
- [License](#license)
- [References](#references)

## Prerequisites and Assumptions

* Assumes you have access to create records on your DNS server to be able to fully use this image. While it will work locally, features such as certificate issuance via  LetsEncrypt will fail without proper resolving DNS.



## Installation

### Build from Source
Clone this repository and build the image with `docker build -t (imagename) .`

### Prebuilt Images
Builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/traefik) and is the recommended method of installation.

```bash
docker pull tiredofit/traefik:(imagetag)
```

The following image tags are available along with their tagged release based on what's written in the [Changelog](CHANGELOG.md):


| Traefik Version | OS Base | Tag           |
| --------------- | ------- | ------------- |
| latest          | Alpine  | `:latest`     |
| 2.8.x           | Alpine  | `:2.8-latest` |
| 2.7.x           | Alpine  | `:2.7-latest` |
| 2.6.x           | Alpine  | `:2.6-latest` |
| 2.5.x           | Alpine  | `:2.5-latest` |
| 2.4.x           | Alpine  | `:2.4-latest` |
| 2.3.x           | Alpine  | `:2.3-latest` |
| 2.2.x           | Alpine  | `:2.2-latest` |
| 1.7.x           | Alpine  | `:1.7-latest` |

#### Multi Architecture
Images are built primarily for `amd64` architecture, and may also include builds for `arm/v7`, `arm64` and others. These variants are all unsupported. Consider [sponsoring](https://github.com/sponsors/tiredofit) my work so that I can work with various hardware. To see if this image supports multiple architecures, type `docker manifest (image):(tag)`

## Configuration

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this image.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.

_This image in it's auto configured state allows for using less labels than usual. This is what I use in my produciton environments, and if I need to add more configuration options I do, but if you are simply using as an HTTP/HTTPS reverse proxy you can get by with the bare minimum on your proxied containers as such:

````bash
      - traefik.enable=true
      - traefik.http.routers.whoami.rule=Host(`whoami.example.com`) || Host(`whoami2.example.com`)
      - traefik.http.services.whoami.loadbalancer.server.port=80
````

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

#### Base Images used

This image relies on an [Alpine Linux](https://hub.docker.com/r/tiredofit/alpine) or [Debian Linux](https://hub.docker.com/r/tiredofit/debian) base image that relies on an [init system](https://github.com/just-containers/s6-overlay) for added capabilities. Outgoing SMTP capabilities are handlded via `msmtp`. Individual container performance monitoring is performed by [zabbix-agent](https://zabbix.org). Additional tools include: `bash`,`curl`,`less`,`logrotate`, `nano`,`vim`.
Be sure to view the following repositories to understand all the customizable options:

| Image                                                  | Description                            |
| ------------------------------------------------------ | -------------------------------------- |
| [OS Base](https://github.com/tiredofit/docker-alpine/) | Customized Image based on Alpine Linux |

There are a huge amount of configuration variables and it is recommended that you get comfortable for a few hours with the [Traefik Documentation](https://docs.traefik.io)

You will eventually based on your usage case switch over to `SETUP_TYPE=MANUAL` and edit your own `config.yml`. While I've tried to make this as easy to use as possible, once in production you'll find much better success with large implementations with this approach.

By Default this image is ready to run out of the box, without having to alter any of the settings with the exception of the `docker-compose.yml` hostname/domainname variables/labels.

#### General Settings
| Parameter              | Description                                                                                    | Default       |
| ---------------------- | ---------------------------------------------------------------------------------------------- | ------------- |
| `SETUP_TYPE`           | `AUTO` to auto generate config on bootup, Otherwise `MANUAL` lets admin control configuration. | `AUTO`        |
| `CONFIG_FILE`          | Configuration file to load                                                                     | `config.toml` |
| `CHECK_NEW_VERSION`    | Check for new Traefik Release                                                                  | `FALSE`       |
| `SEND_ANONYMOUS_USAGE` | Send Anonymous Usage Stats                                                                     | `FALSE`       |

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
Inside the image are tools to perform modification on how the image runs.

### Shell Access
For debugging and maintenance purposes you may want access the containers shell.

```bash
docker exec -it (whatever your container name is e.g. traefik) bash
```
* * *
## Contributions
Welcomed. Please fork the repository and submit a [pull request](../../pulls) for any bug fixes, features or additions you propose to be included in the image. If it does not impact my intended usage case, it will be merged into the tree, tagged as a release and credit to the contributor in the [CHANGELOG](CHANGELOG).

## Support

These images were built to serve a specific need in a production environment and gradually have had more functionality added based on requests from the community.
### Usage
- The [Discussions board](../../discussions) is a great place for working with the community on tips and tricks of using this image.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) personalized support.
### Bugfixes
- Please, submit a [Bug Report](issues/new) if something isn't working as expected. I'll do my best to issue a fix in short order.

### Feature Requests
- Feel free to submit a feature request, however there is no guarantee that it will be added, or at what timeline.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) regarding development of features.

### Updates
- Best effort to track upstream changes, More priority if I am actively using the image in a production environment.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) for up to date releases.

## License
MIT. See [LICENSE](LICENSE) for more details.

## References

* https://traefik.io
