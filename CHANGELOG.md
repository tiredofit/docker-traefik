## 2.10-2.16.0 2023-05-10 <dave at tiredofit dot ca>

   ### Changed
      - Alpine 3.18 base


## 2.10-2.15.0 2023-04-27 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.10.1
      - Add HTTP3 Support


## 2.10-2.14.0 2023-04-26 <dave at tiredofit dot ca>

   ### Added
      - Add support for _FILE environment variables


## 2.10-2.13.0 2023-04-24 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.10.0


## 2.9-2.13.0 2023-04-12 <dave at tiredofit dot ca>

   ### Changed
      - Set acme.json permissions as root and when change ownership after the fact to avoid a certificate loading error


## 2.9-2.12.0 2023-04-06 <dave at tiredofit dot ca>

   ### Changed
      - Fix metrics if statement


## 2.9-2.11.1 2023-04-06 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.9.10


## 2.9-2.11.0 2023-04-03 <dave at tiredofit dot ca>

   ### Reverted
      - Pull jq from image again


## 2.9-2.10.0 2023-03-31 <dave at tiredofit dot ca>

   ### Added
      - Add option for Metrics exporting via Prometheus

   ### Changed
      - Fix issue with TRAEFIK_USER not being respected on startup

   ### Reverted
      - Removal of old Zabbix monitoring templates and agent config leftover from Traefik 1.x


## 2.9-2.9 2023-03-30 <dave at tiredofit dot ca>

   ### Changed
      - Remove suffix from IMAGE_NAME making versions get weird.


## 2.9-2.8 2023-03-21 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.9.9


## 2.9-2.9-2.1 2023-02-15 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.9.8


## 2.9-2.0.4 2023-02-14 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.9.7


## 2.0.3 2023-01-10 <dave at tiredofit dot ca>

   ### Added
      - Add `DOCKER_HTTP_TIMEOUT` environment variable and default `600`


## 2.0.2 2023-01-05 <dave at tiredofit dot ca>

   ### Changed
      - Change Traefik certificate dumper permissions for dumps to 644
      - Build Traefik certificate dumper from source
      - Fix for posthook for Traefik certificate dumper


## 2.0.1 2023-01-04 <dave at tiredofit dot ca>

   ### Changed
      - Better indentations for code
      - Re-enable Dashboard
      - Change permissions on startup for Traefik Cert Dumper if running as someone other than root


## 2.0.0 2022-12-21 <dave at tiredofit dot ca>

This release contains breaking changes to environment variables and default path names and runtime settings

   ### Added
      - Rewrote entire image specifically configuration management with YAML generation as opposed to bash and echo statements
      - Ability to run as non-root. Try using TRAEFIK_USER=traefik. This may affect your ability to use Docker Sockets.
      - Reworked paths for config, data, certificates, and logs
      - Reworked Log Levels and Log environment variables


## 1.5.1 2022-12-07 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.9.6


## 1.5.0 2022-12-01 <dave at tiredofit dot ca>

   ### Changed
      - Rework Dockerfile

   ### Reverted
      - Remove Traefik Migration Tool


## 1.4.26 2022-11-23 <dave at tiredofit dot ca>

   ### Added
      - Alpine 3.17 base


## 1.4.25 2022-11-17 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.9.5


## 1.4.24 2022-11-14 <dave at tiredofit dot ca>

   ### Changed
      - SERVER_TRANSPORT_INSECURE_SKIP_VERIFY default TRUE


## 1.4.23 2022-11-09 <dave at tiredofit dot ca>

   ### Added
      - Add SERVER_TRANSPORT_INSECURE_SKIP_VERIFY feature


## 1.4.22 2022-10-27 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.9.4


## 1.4.21 2022-10-03 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.9.1


## 1.4.20 2022-09-30 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.8.8


## 1.4.19 2022-09-23 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.8.7


## 1.4.18 2022-09-13 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.8.5


## 1.4.17 2022-09-02 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.8.4


## 1.4.16 2022-08-12 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.8.3


## 1.4.15 2022-08-11 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.8.2


## 1.4.14 2022-07-11 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.8.1


## 1.4.13 2022-06-29 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.8.0


## 1.4.12 2022-06-29 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.7.3


## 1.4.11 2022-06-27 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.7.2


## 1.4.10 2022-06-13 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.7.1


## 1.4.9 2022-05-24 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.7.0


## 1.4.8 2022-05-24 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.6.7
      - Alpine 3.16 base


## 1.4.7 2022-05-06 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.6.6


## 1.4.6 2022-03-30 <dave at tiredofit dot ca>

   ### Added
      - Traefik Cert Dumper 2.8.1


## 1.4.5 2022-03-29 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.6.3


## 1.4.4 2022-03-24 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.6.2


## 1.4.3 2022-02-14 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.6.1


## 1.4.2 2022-02-09 <dave at tiredofit dot ca>

   ### Changed
      - Rework to support new base image


## 1.4.1 2022-02-09 <dave at tiredofit dot ca>

   ### Changed
      - Refresh base image


## 1.4.0 2022-01-24 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.6.0


## 1.3.11 2022-01-20 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.5.7


## 1.3.10 2021-12-22 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.5.6


## 1.3.9 2021-12-10 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.5.5


## 1.3.8 2021-12-07 <dave at tiredofit dot ca>

   ### Added
      - Add Zabbix auto agent registration for templates


## 1.3.7 2021-11-24 <dave at tiredofit dot ca>

   ### Added
      - Alpine 3.15 base


## 1.3.6 2021-11-08 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.5.4


## 1.3.5 2021-09-20 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.5.3


## 1.3.4 2021-09-04 <dave at tiredofit dot ca>

   ### Changed
      - Change the way logrotate is configured for better parsing capabilities


## 1.3.3 2021-09-02 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.5.2


## 1.3.2 2021-08-30 <dave at tiredofit dot ca>

   ### Added
      - Add fluent-bit log parsing capability

   ### Changed
      - Switch logs from common format to JSON


## 1.3.1 2021-08-20 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.5.1


## 1.3.0 2021-08-17 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.5.0


## 1.2.7 2021-08-16 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.4.14


## 1.2.6 2021-07-30 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.4.13


## 1.2.5 2021-07-26 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.4.12


## 1.2.4 2021-07-19 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.4.11


## 1.2.3 2021-07-13 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.4.10


## 1.2.2 2021-06-22 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.4.9
      - Alpine 3.14 base


## 1.2.1 2021-04-12 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.4.8


## 1.2.0 2021-01-25 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.4 Branch (Presently 2.4.0)

## 1.1.5 2021-01-25 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.3.7
      - Traefik Migration Tool 0.13.1
      - Traefik Certs Dumper 2.7.4
      - Arm64, ArmV6, ArmV7 build variants added


## 1.1.4 2021-01-05 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.3.6


## 1.1.3 2020-12-10 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.3.5


## 1.1.2 2020-12-03 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.3.4


## 1.1.1 2020-10-25 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.3.2


## 1.1.0 2020-10-04 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.3.1


## 1.0.18 2020-09-19 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.2.11


## 1.0.17 2020-08-30 <dave at tiredofit dot ca>

   ### Changed
      - Bugfix to 1.0.16


## 1.0.16 2020-08-29 <dave at tiredofit dot ca>

   ### Added
      - Add more features for Traefik Certificate Dumping


## 1.0.15 2020-08-19 <dave at tiredofit dot ca>

   ### Changed
      - Fix for SETUP_TYPE=MANUAL not actually skipping writing parts of configuration file


## 1.0.14 2020-07-30 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.2.8


## 1.0.13 2020-07-20 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.2.6


## 1.0.12 2020-07-15 <dave at tiredofit dot ca>

   ### Changed
      - Fix missing default variables


## 1.0.11 2020-07-09 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.2.3

   ### Changed
      - Code Cleanup


## 1.0.10 2020-06-20 <dave at tiredofit dot ca>

   ### Changed
      - Patchup to support reading both defaults and functions at runtime


## 1.0.9 2020-06-05 <dave at tiredofit dot ca>

   ### Changed
      - Move /etc/s6/services to /etc/services.available


## 1.0.8 2020-06-05 <dave at tiredofit dot ca>

   ### Added
      - Added CERTIFICATE_DUMP_POST_HOOK environment variable to execute scripts or commands post Certificate dump


## 1.0.7 2020-05-01 <dave at tiredofit dot ca>

   ### Added
      - Traefik 2.2.1


## 1.0.6 2020-04-23 <dave at tiredofit dot ca>

   ### Changed
      - Fix to allow various variables that allow multiple values to allow single values


## 1.0.5 2020-04-23 <dave at tiredofit dot ca>

   ### Added
      - Introduce TLS Curve Preferences


## 1.0.4 2020-04-23 <dave at tiredofit dot ca>

   ### Changed
      - Tweak TLS Configuration


## 1.0.3 2020-04-23 <dave at tiredofit dot ca>

   ### Changed
      - Tweak to make HTTP to HTTPS redirection function properly


## 1.0.2 2020-04-23 <dave at tiredofit dot ca>

   ### Changed
      - Cleanup HTTP and HTTPS Middlewares


## 1.0.1 2020-04-23 <dave at tiredofit dot ca>

   ### Changed
      - Patchup to Traefik Certificate Dumper exported path


## 1.0.0 2020-04-22 <dave at tiredofit dot ca>

   ### Added
      - Completely rewritten configuration generator
      - See README for more details
      - Traefik 2.2.0


## 0.15 2019-11-01 <dave at tiredofit dot ca>

* Add Traefik Migration Tool

## 0.14 2019-11-01 <dave at tiredofit dot ca>

* Traefik 2.0.4

## 0.13 2019-08-27 <dave at tiredofit dot ca>

* Traefik 2.0.0GA
* Still working on Dynamic Configuration

## 0.12 2019-08-27 <dave at tiredofit dot ca>

* Traefik 2.0rc1

## 0.11 2019-07-27 <dave at tiredofit dot ca>

* WIP on rewriting configuration builder
* Traefik 2.0beta1

## 0.10 2019-07-09 <dave at tiredofit dot ca>

* Change Logrotate functionality

## 0.9 2019-07-02 <dave at tiredofit dot ca>

* Alpine 3.10
* Traefik 2.0alpha8

## 0.8.4 2019-05-09 <dave at tiredofit dot ca>

* More Zabbix Metrics

## 0.8.3 2019-05-07 <dave at tiredofit dot ca>

* More Zabbix Metrics

## 0.8.2 2019-05-06 <dave at tiredofit dot ca>

* More Zabbix Metrics

## 0.8.1 2019-05-04 <dave at tiredofit dot ca>

* Zabbix Patchup

## 0.8 2019-05-04 <dave at tiredofit dot ca>

* Add Zabbix Monitoring Template and script

## 0.7 2019-05-02 <dave at tiredofit dot ca>

* Fix for Logrotate not creating new file

## 0.6 2019-04-30 <dave at tiredofit dot ca>

* Fix for DNS Resolvers when validating against Letsencrypt
* Change LETSENCRYPT_DYNAMIC_GENERATE to LETSENCRYPT_ONHOST_GENERATE (Default: True) and LETSENCRYPT_ONDEMAND_GENERATE (Default: False)
* Cleanup of code

## 0.5 2019-04-30 <dave at tiredofit dot ca>

* Fix Dashboard Authentication and Display

## 0.4 2019-04-30 <dave at tiredofit dot ca>

* Add logrotation

## 0.3 2019-04-30 <dave at tiredofit dot ca>

* Add LetsEncrypt Capabilities
* Add Compression
* Write Documentation

## 0.2 2019-04-28 <dave at tiredofit dot ca>

* Add Traefik Certs Dumper
* Add REST Capabilities
* Protect Dashboard with Authentication
* HTTP/HTTPS Proxy Protocol and Trusted IPs
* HTTPS Upgrade Support

## 0.1 2019-04-28 <dave at tiredofit dot ca>

* Initial Release
* Alpine 3.9
* Traefik 2.0 Alpha
