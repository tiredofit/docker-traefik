# nfrastack/container-traefik

## About

This repository will build a container for [Traefik](https://www.traefik.io), a reverse proxy and ingress controller.

* Sane Defaults to have a working solution by just running the image
* Automatically generates configuration files on startup, or option to use your own
* Supports most traditional use cases w/Docker
* Choice of Logging (Console, File w/logrotation)

## Maintainer

* [Nfrastack](https://www.nfrastack.com)

## Table of Contents

* [About](#about)
* [Maintainer](#maintainer)
* [Table of Contents](#table-of-contents)
* [Installation](#installation)
  * [Prebuilt Images](#prebuilt-images)
  * [Quick Start](#quick-start)
  * [Persistent Storage](#persistent-storage)
* [Configuration](#configuration)
  * [Environment Variables](#environment-variables)
    * [Base Images used](#base-images-used)
    * [Core Configuration](#core-configuration)
    * [Logging Settings](#logging-settings)
    * [Docker Settings](#docker-settings)
    * [HTTP Settings](#http-settings)
    * [HTTPS Settings](#https-settings)
    * [HTTP3 Settings](#http3-settings)
    * [LetsEncrypt Settings](#letsencrypt-settings)
    * [TLS Settings](#tls-settings)
    * [Metrics](#metrics)
    * [API / Dashboard Settings](#api--dashboard-settings)
    * [Certificate Exporter Settings](#certificate-exporter-settings)
    * [Server Transports](#server-transports)
  * [Users and Groups](#users-and-groups)
  * [Networking](#networking)
* [Maintenance](#maintenance)
  * [Shell Access](#shell-access)
* [Support & Maintenance](#support--maintenance)
* [License](#license)
* [References](#references)

## Installation

### Prebuilt Images

Feature limited builds of the image are available on the [Github Container Registry](https://github.com/nfrastack/container-traefik/pkgs/container/container-traefik) and [Docker Hub](https://hub.docker.com/r/nfrastack/traefik).

To unlock advanced features, one must provide a code to be able to change specific environment variables from defaults. Support the development to gain access to a code.

To get access to the image use your container orchestrator to pull from the following locations:

```
ghcr.io/nfrastack/container-traefik:(image_tag)
docker.io/nfrastack/traefik:(image_tag)
```

Image tag syntax is:

`<image>:<branch>-<optional tag>`

Example:

`ghcr.io/nfrastack/container-traefik:latest` or

`ghcr.io/nfrastack/container-traefik:3.7-1.0`

* `branch` will be the repositories branch, typically matching with the version of Traefik eg `3.7`
* `latest` will be the most recent commit
* An optional `tag` may exist that matches the [CHANGELOG](CHANGELOG.md) - These are the safest

Have a look at the container registries and see what tags are available.

#### Multi-Architecture Support

Images are built for `amd64` by default, with optional support for `arm64` and other architectures.

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [compose.yml](examples/compose.yml) that can be modified for your use.

* Map [persistent storage](#persistent-storage) for access to configuration and data files for backup.
* Set various [environment variables](#environment-variables) to understand the capabilities of this image.

_This image in it's auto configured state allows for using less labels than usual. This is what I use in my produciton environments, and if I need to add more configuration options I do, but if you are simply using as an HTTP/HTTPS reverse proxy you can get by with the bare minimum on your proxied containers as such:

````bash
      - traefik.enable=true
      - traefik.http.routers.whoami.rule=Host(`whoami.example.com`) || Host(`whoami2.example.com`)
      - traefik.http.services.whoami.loadbalancer.server.port=80
````

### Persistent Storage

The following directories/files should be mapped for persistent storage in order to utilize the container effectively.

| Folder                 | Description                                                                                                |
| ---------------------- | ---------------------------------------------------------------------------------------------------------- |
| `/certs`               | (Optional) Use this area for storing TLS certificates to access providers or to serve content              |
| `/config`              | (Optional) - Traefik core configuration files. Auto Generates on Container startup                         |
| `/data/acme`           | (Optional) - If you wish to utilize ACME/LetsEncrypt Certificates or SSL map this directory                |
| `/data/config_custom`  | (Optional) - If using manual mode and wish to add dynamic File configuration, add it in here (.yml)        |
| `/logs`                | (Optional) - Logfiles if you wish to store to files                                                        |
| `/var/run/docker.sock` | Easiest way to get going - Map the hosts docker socket to the container. Alternatively, use a socket-proxy |

### Environment Variables

#### Base Images used

This image relies on a customized base image in order to work.
Be sure to view the following repositories to understand all the customizable options:

| Image                                                   | Description |
| ------------------------------------------------------- | ----------- |
| [OS Base](https://github.com/nfrastack/container-base/) | Base Image  |

Below is the complete list of available options that can be used to customize your installation.

* Variables showing an 'x' under the `Advanced` column can only be set if the containers advanced functionality is enabled.

#### Core Configuration

#### General Settings

| Parameter              | Description                                                  | Default                    | Advanced |
| ---------------------- | ------------------------------------------------------------ | -------------------------- | -------- |
| `SETUP_TYPE`           | `AUTO` to auto generate config on bootup, Otherwise `MANUAL` | `AUTO`                     |          |
| `CONFIG_FILE`          | Configuration file to load                                   | `traefik.yml`              |          |
| `CHECK_NEW_VERSION`    | Check for new Traefik Release                                | `FALSE`                    |          |
| `SEND_ANONYMOUS_USAGE` | Send Anonymous Usage Stats                                   | `FALSE`                    |          |
| `TRAEFIK_USER`         | Run traefik as user (options: `root` or `traefik`)           | `root`                     |          |
| `CONFIG_PATH`          | Where configuration files are kept                           | `/config`                  |          |
| `CONFIG_CUSTOM_PATH`   | Where to store custom/dynamic files                          | `${CONFIG_PATH}/custom/`   |          |
| `DATA_PATH`            | Root Volatile Data folder                                    | `/data/`                   |          |
| `TRUSTED_IPS`          | Use for Proxy Protocol Variables - Comma Seperated.          | `127.0.0.1/32,10.0.0.0/8,` |          |
|                        | `172.16.0.0/12,192.168.0.0/16`                               |                            |          |

#### Logging Settings

| Parameter              | Description                                             | Default       | Advanced |
| ---------------------- | ------------------------------------------------------- | ------------- | -------- |
| `ACCESS_LOG_FILE`      | File to store access log - Same directory as `LOG_PATH` | `access.log`  |          |
| `ACCESS_LOG_FORMAT`    | Format to store logs in `common` `genericCLF` / `json`  | `common`      |          |
| `ACCESS_LOG_INTERNALS` | Log access to dashboard, API api                        | `TRUE`        |          |
| `ACCESS_LOG_TYPE`      | Display logs via `CONSOLE` or write to `FILE`           | `CONSOLE`     |          |
| `LOG_PATH`             | Log Path                                                | `/logs`       |          |
| `LOG_FILE`             | Traefik Log File                                        | `traefik.log` |          |
| `LOG_FORMAT`           | Format to store logs in `common` / `json`               | `json`        |          |
| `LOG_TYPE`             | Display logs via `CONSOLE` or write to `FILE`           | `CONSOLE`     |          |
| `LOG_LEVEL`            | Log levels `DEBUG` `INFO` `WARN` `ERROR` `FATAL`        | `ERROR`       |          |

#### Docker Settings

| Parameter                     | Description                                      | Default                         | `_FILE` |
| ----------------------------- | ------------------------------------------------ | ------------------------------- | ------- |
| `ENABLE_DOCKER`               | Enable Docker Mode                               | `TRUE`                          |         |
| `DOCKER_ENDPOINT`             | How to connect to Docker                         | `unix:///var/run/docker.sock`   | x       |
| `DOCKER_USERNAME`             | Username for Docker HTTP endpoint authentication |                                 | x       |
| `DOCKER_PASSWORD`             | Password for Docker HTTP endpoint authentication |                                 | x       |
| `DOCKER_CONSTRAINTS`          | Docker Constraints                               | `""`                            |         |
| `DOCKER_DEFAULT_HOST_RULE`    | Docker Access rule                               | "Host(`{{ normalize .Name }}`)" |         |
| `DOCKER_DEFAULT_NETWORK`      | Default Network for Traefik to operate on        | `proxy`                         |         |
| `DOCKER_HTTP_TIMEOUT`         | Timeout in seconds for HTTP connections          | `600`                           |         |
| `DOCKER_ENABLE_SWARM_MODE`    | Enable Swarm Mode                                | `FALSE`                         |         |
| `DOCKER_EXPOSE_CONTAINERS`    | Expose Containers by Default                     | `FALSE`                         |         |
| `DOCKER_USE_BIND_PORT_IP`     | Use the IP address of the bind port for routing  | `FALSE`                         |         |
| `DOCKER_ALLOW_EMPTY_SERVICES` | Allow services with no exposed ports             | `FALSE`                         |         |
| `DOCKER_SWARM_MODE_REFRESH`   | Swarm mode Refresh in Seconds                    | `15`                            |         |

##### Docker TLS Settings

If you need to connect to an encrypted docker endpoint you can set the following TLS Settings:

| Parameter                       | Description                              | Default           | `_FILE` |
| ------------------------------- | ---------------------------------------- | ----------------- | ------- |
| `DOCKER_ENABLE_TLS`             | Enable TLS Support                       | `TRUE`            |         |
| `DOCKER_TLS_CA_FILE`            | CA Certificate                           | `"ca.crt`         |         |
| `DOCKER_TLS_CERTS_PATH`         | Path for Docker Certificates             | `"/certs/docker/` |         |
| `DOCKER_TLS_CERT_FILE`          | Docker TLS Certificate                   | `cert.crt`        |         |
| `DOCKER_TLS_INSECURESKIPVERIFY` | Skip verification of cerficiate validity | `true`            |         |
| `DOCKER_TLS_KEY_FILE`           | Docker TLS Private Key                   | `cert.key`        |         |

#### HTTP Settings

| Parameter                                      | Description                            | Default   | Advanced |
| ---------------------------------------------- | -------------------------------------- | --------- | -------- |
| `ENABLE_HTTP`                                  | Enable HTTP Support                    | `TRUE`    |          |
| `HTTP_ENABLE_FORWARDED_HEADERS`                | Enable HTTP Forwarded Headers          | `FALSE`   |          |
| `HTTP_ENDPOINT`                                | Name of HTTP Endpoint                  | `web`     |          |
| `HTTP_LISTEN_IP`                               | Address to bind for HTTP               | `0.0.0.0` |          |
| `HTTP_LISTEN_PORT`                             | Port to bind for HTTP                  | `80`      |          |
| `HTTP_TIMEOUT_ACCEPTGRACE`                     | Accept Grace Timeout                   | `0`       |          |
| `HTTP_TIMEOUT_GRACE`                           | Grace Timeout                          | `10`      |          |
| `HTTP_TIMEOUT_IDLE`                            | Idle Timeout                           | `180`     |          |
| `HTTP_TIMEOUT_READ`                            | Read Timeout                           | `0`       |          |
| `HTTP_TIMEOUT_WRITE`                           | Write Timeout                          | `0`       |          |
| `HTTP_ENABLE_COMPRESSION`                      | Enable HTTP Compression                | `TRUE`    |          |
| `HTTP_COMPRESSION_INCLUDE`                     | MimeTypes to include when compressing  |           |          |
| `HTTP_COMPRESSION_EXCLUDE`                     | MimeTypes to exclude when compressing  |           |          |
| `HTTP_COMPRESSION_MINIMUM_RESPONSE_BODY_BYTES` | Minimum byte size in order to compress | `1024`    |          |
| `HTTP_ENABLE_PROXY_PROTOCOL`                   | Enable HTTP Proxy Protocol Support     | `FALSE`   |          |
| `HTTP_ENCODED_CHARACTERS_ALLOW_SLASH`          | Allow encoded slash (`%2F`)            | `FALSE`   |          |
| `HTTP_ENCODED_CHARACTERS_ALLOW_BACKSLASH`      | Allow encoded backslash (`%5C`)        | `FALSE`   |          |
| `HTTP_ENCODED_CHARACTERS_ALLOW_NULL_CHARACTER` | Allow encoded null character (`%00`)   | `FALSE`   |          |
| `HTTP_ENCODED_CHARACTERS_ALLOW_SEMICOLON`      | Allow encoded semicolon (`%3B`)        | `FALSE`   |          |
| `HTTP_ENCODED_CHARACTERS_ALLOW_PERCENT`        | Allow encoded percent (`%25`)          | `FALSE`   |          |
| `HTTP_ENCODED_CHARACTERS_ALLOW_QUESTION_MARK`  | Allow encoded question mark (`%3F`)    | `FALSE`   |          |
| `HTTP_ENCODED_CHARACTERS_ALLOW_HASH`           | Allow encoded hash (`%23`)             | `FALSE`   |          |

#### HTTPS Settings

| Parameter                                       | Description                                 | Default     | Advanced |
| ----------------------------------------------- | ------------------------------------------- | ----------- | -------- |
| `ENABLE_HTTPS`                                  | Enable HTTPS Support                        | `TRUE`      |          |
| `HTTPS_ENTRYPOINT`                              | Name of HTTP Entrypoint                     | `websecure` |          |
| `HTTPS_ENABLE_FORWARDED_HEADERS`                | Enable HTTPS Forwarded Headers              | `FALSE`     |          |
| `HTTPS_LISTEN_IP`                               | Address to bind for HTTP                    | `0.0.0.0`   |          |
| `HTTPS_LISTEN_PORT`                             | Port to bind for HTTPS                      | `443`       |          |
| `HTTPS_TIMEOUT_ACCEPTGRACE`                     | Accept Grace Timeout                        | `0`         |          |
| `HTTPS_TIMEOUT_GRACE`                           | Grace Timeout                               | `10`        |          |
| `HTTPS_TIMEOUT_IDLE`                            | Idle Timeout                                | `180`       |          |
| `HTTPS_TIMEOUT_READ`                            | Read Timeout                                | `0`         |          |
| `HTTPS_TIMEOUT_WRITE`                           | Write Timeout                               | `0`         |          |
| `HTTPS_ENABLE_COMPRESSION`                      | Enable HTTPS Compression                    | `TRUE`      |          |
| `HTTPS_COMPRESSION_INCLUDE`                     | MimeTypes to include when compressing       |             |          |
| `HTTPS_COMPRESSION_EXCLUDE`                     | MimeTypes to exclude when compressing       |             |          |
| `HTTPS_COMPRESSION_MINIMUM_RESPONSE_BODY_BYTES` | Minimum byte size in order to compress      | `1024`      |          |
| `HTTPS_ENABLE_UPGRADE`                          | Automatically forward HTTP -> HTTPS         | `TRUE`      |          |
| `HTTPS_ENABLE_SNI_STRICT`                       | Enable Strict SNI Checking for Certificates | `FALSE`     |          |
| `HTTPS_ENABLE_PROXY_PROTOCOL`                   | Enable HTTP Proxy Protocol Support          | `FALSE`     |          |
| `HTTPS_ENCODED_CHARACTERS_ALLOW_SLASH`          | Allow encoded slash (`%2F`)                 | `FALSE`     |          |
| `HTTPS_ENCODED_CHARACTERS_ALLOW_BACKSLASH`      | Allow encoded backslash (`%5C`)             | `FALSE`     |          |
| `HTTPS_ENCODED_CHARACTERS_ALLOW_NULL_CHARACTER` | Allow encoded null character (`%00`)        | `FALSE`     |          |
| `HTTPS_ENCODED_CHARACTERS_ALLOW_SEMICOLON`      | Allow encoded semicolon (`%3B`)             | `FALSE`     |          |
| `HTTPS_ENCODED_CHARACTERS_ALLOW_PERCENT`        | Allow encoded percent (`%25`)               | `FALSE`     |          |
| `HTTPS_ENCODED_CHARACTERS_ALLOW_QUESTION_MARK`  | Allow encoded question mark (`%3F`)         | `FALSE`     |          |
| `HTTPS_ENCODED_CHARACTERS_ALLOW_HASH`           | Allow encoded hash (`%23`)                  | `FALSE`     |          |
|                                                 |
#### HTTP3 Settings

| Parameter           | Description                | Default | Advanced |
| ------------------- | -------------------------- | ------- | -------- |
| `ENABLE_HTTP3`      | Enable HTTP3 support       | `FALSE` |          |
| `HTTP3_LISTEN_PORT` | UDP port to bind for HTTP3 | `443`   |          |

#### LetsEncrypt Settings

| Parameter                                  | Description                                                                               | Default              | `_FILE` |
| ------------------------------------------ | ----------------------------------------------------------------------------------------- | -------------------- | ------- |
| `ENABLE_ACME`                              | Enable ACME Certificate Generation                                                        | `FALSE`              |         |
| `ACME_STORAGE_FILE`                        | What file to store ACME certificates in                                                   | `acme.json`          |         |
| `ACME_STORAGE_PATH`                        | What path to store ACME certificates in                                                   | `${DATA_PATH}/acme/` |         |
| `ACME_EMAIL`                               | Email address to register with ACME Provider                                              |                      | x       |
| `ACME_CHALLENGE`                           | Use `HTTP`, `TLS`, or `DNS` Challenges                                                    | `HTTP`               |         |
| `ACME_PROVIDER`                            | Helper to prepopulate ACME_SERVER environment `letsencrypt` `letsencrypt-staging` `other` | `LETSENCRYPT`        |         |
| `ACME_SERVER`                              | If using something other than ACME_PROVIDER values enter the server endpoint here         | `PRODUCTION`         |         |
| `ACME_RESOLVER_NAME`                       | Name of the ACME resolver                                                                 | `letsencrypt`        |         |
| `ACME_KEYTYPE`                             | Keytype to use `EC256` `EC384` `RSA2048` `RSA4096` `RSA8192`                              | `RSA4096`            |         |
| `ACME_CERTIFICATES_DURATION`               | Duration (in hours) for ACME certificates                                                 | `2160`               |         |
| `ACME_CLIENT_TIMEOUT`                      | Timeout for ACME client requests                                                          | `2m`                 |         |
| `ACME_CLIENT_RESPONSE_HEADER_TIMEOUT`      | Timeout for ACME client response headers                                                  | `30s`                |         |
| `ACME_DNS_PROPAGATION_DELAY_BEFORE_CHECKS` | Delay before DNS propagation checks                                                       | `0s`                 |         |
| `ACME_DNS_PROPAGATION_DISABLE_ANS_CHECKS`  | Disable authoritative name server checks for DNS propagation                              | `FALSE`              |         |
| `ACME_DNS_PROPAGATION_DISABLE_CHECKS`      | Disable DNS propagation checks                                                            | `FALSE`              |         |
| `ACME_DNS_PROPAGATION_REQUIRE_ALL_RNS`     | Require all recursive name servers for DNS propagation                                    | `FALSE`              |         |
| `ACME_ONDEMAND_GENERATE`                   | Enable on-demand certificate generation                                                   | `FALSE`              |         |
| `ACME_ONHOST_GENERATE`                     | Enable on-host certificate generation                                                     | `TRUE`               |         |
| `ACME_DNS_PROVIDER`                        | See [Traefik Documentation](https://docs.traefik.io) for values if using `DNS` Challenge  |                      |         |
| `ACME_DNS_RESOLVER`                        | Comma Separated values if using `DNS` Challenge e.g. `1.1.1.1:53,1.0.0.1:53`              |                      |         |
| `ACME_TLS_PROFILE`                         | Set TLS Profile `compatible` `modern` `custom` - See TLS Settings Below                   | `modern`             |         |
| `ACME_WILDCARD_DOMAINS`                    | Create wildcard domains in this comma separated values e.g. `example.com,domain.tld`      |                      | x       |

**If using DNS Challenges, you will need to add additional Environment Variables for your DNS servers API/credentials** See Traefik Documentation.

#### TLS Settings

| Parameter                 | Description                                                                              | Default     | Advanced |
| ------------------------- | ---------------------------------------------------------------------------------------- | ----------- | -------- |
| `TLS_ENABLE_TAILSCALE`    | Enable TailScale Support                                                                 | `FALSE`     |          |
| `TAILSCALE_RESOLVER_NAME` | Tailscale Internal Resolver name                                                         | `tailscale` |          |
| `TLS_XX_CERT_FILE`        | Certificate File for a Domain (substitute XX for integer)                                |             |          |
| `TLS_XX_KEY_FILE`         | Certificate File for a Domain (substitute XX for integer)                                |             |          |
| `TLS_CERT_PATH`           | Scan this folder for .crt and key files and populate TLS configuration with their values |             |          |
| `RELOAD_ON_CERT_CHANGE`   | Reload Traefik when certificate or key files changes                                     | `TRUE`      |          |

This image comes with 3 TLS profiles and can be adjusted to your liking. The profiles are generated based on the [Mozilla SSL Configuration Generator](https://ssl-config.mozilla.org/#server=traefik&version=3.5&config=intermediate&hsts=false&guideline=5.7):

##### TLS Profile: Compatible (`compatible`)

* TLS Cipher: `TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305`
* TLS Curve Preferences
* Enforce Strict SNI Checking: `TRUE`
* Minimum TLS Version to accept: `VersionTLS1.2`

##### TLS Profile: Modern (With Quantum Proof Curve) (`modern`)

* TLS Curve Preferences: `X25519MLKEM768,X25519,CurveP256,CurveP384`
* Enforce Strict SNI Checking: `TRUE`
* Minimum TLS Version to accept: `VersionTLS1.3`

##### TLS Profile: Custom (`custom`)

* TLS Cipher: Set `TLS_PROFILE_CUSTOM_CIPHERS` with comma seperated values
* TLS Curve Preferences: Set `TLS_PROFILE_CUSTOM_CURVE PREFERENCES` with comma seperated values
* Enforce Strict SNI Checking: Set `TLS_PROFILE_CUSTOM_ENABLE_SNI_STRICT` to `TRUE` or `FALSE`
* Minimum TLS Version to accept: Set `TLS_PROFILE_CUSTOM_MINIMUM_VERSION` with value `VersionTLSXX`

#### Metrics

| Parameter             | Description               | Default      | Advanced |
| --------------------- | ------------------------- | ------------ | -------- |
| `ENABLE_METRICS`      | Enable Metrics            | `FALSE`      |          |
| `METRICS_TYPE`        | Metrics Type `prometheus` | `prometheus` |          |
| `METRICS_LISTEN_IP`   | Listen IP                 | `0.0.0.0`    |          |
| `METRICS_LISTEN_PORT` | Metrics Listen Port       | `8082`       |          |
| `METRICS_ENTRYPOINT`  | Metrics Entrypoint        | `metrics`    |          |

#### API / Dashboard Settings

| Parameter                                   | Description                                                  | Default     | `_FILE` |
| ------------------------------------------- | ------------------------------------------------------------ | ----------- | ------- |
| `ENABLE_API`                                | Enable Dashboard                                             | `FALSE`     |         |
| `API_BASE_PATH`                             | API Base Path - Will not work without authentication         | `/`         |         |
| `ENABLE_DASHBOARD`                          | Enable Dashboard                                             | `FALSE`     |         |
| `DASHBOARD_HOSTNAME`                        | Hostname to respond for Dashboard e.g. `traefik.example.com` |             | x       |
| `DASHBOARD_AUTHENTICATION`                  | `NONE` or `BASIC`                                            | `BASIC`     |         |
| `DASHBOARD_AUTHENTICATION_BASIC_ADMIN_USER` | Username for access to Dashboard                             | `admin`     | x       |
| `DASHBOARD_AUTHENTICATION_BASIC_ADMIN_PASS` | Password for access to Dashboard                             | `nfrastack` | x       |
| `ENABLE_PING`                               | Enable Ping test/Health Check                                | `FALSE`     |         |

#### Certificate Exporter Settings

| Parameter                             | Description                                                   | Default                       | Advanced |
| ------------------------------------- | ------------------------------------------------------------- | ----------------------------- | -------- |
| `ENABLE_CERTIFICATE_EXPORTER`         | Enable exporting of certificates from ACME storejson          | `TRUE`                        |          |
| `CERTIFICATE_EXPORTER_PATH`           | Where to put the exported certificates                        | `${ACME_STORAGE_PATH}/export` |          |
| `CERTIFICATE_EXPORTER_POST_HOOK`      | *optional* Argument or external script to execute post export |                               |          |
|                                       | of certificates Where to put the exported certificates        |                               |          |
|                                       | eg `chmod 644 ${CERTIFICATE_EXPORTER_PATH}`                   |                               |          |
| `CERTIFICATE_EXPORTER_SUBDIRECTORIES` | Create subdirectories of hosts                                | `TRUE`                        |          |
| `CERTIFICATE_EXPORTER_CLEAN_PATH`     | Clean Dump path before reexporting                            | `FALSE`                       |          |

#### Server Transports

| Parameter                               | Description                                           | Default | Advanced |
| --------------------------------------- | ----------------------------------------------------- | ------- | -------- |
| `SERVER_TRANSPORT_INSECURE_SKIP_VERIFY` | Disable Certificate verification on Server Transports | `FALSE` |          |

## Users and Groups

| Type  | Name      | ID   |
| ----- | --------- | ---- |
| User  | `traefik` | 8080 |
| Group | `traefik` | 8080 |

### Networking

| Port  | Protocol | Description |
| ----- | -------- | ----------- |
| `80`  | `tcp`    | HTTP        |
| `443` | `tcp`    | HTTPS       |
| `443` | `udp`    | HTTP3       |

* * *

## Maintenance

### Shell Access

For debugging and maintenance, `bash` and `sh` are available in the container.

## Support & Maintenance

* For community help, tips, and community discussions, visit the [Discussions board](/discussions).
* For personalized support or a support agreement, see [Nfrastack Support](https://nfrastack.com/).
* To report bugs, submit a [Bug Report](issues/new). Usage questions will be closed as not-a-bug.
* Feature requests are welcome, but not guaranteed. For prioritized development, consider a support agreement.
* Updates are best-effort, with priority given to active production use and support agreements.

## References

* <https://traefik.io>

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
