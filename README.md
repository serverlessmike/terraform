[![forthebadge](https://forthebadge.com/images/badges/made-with-crayons.svg)](https://forthebadge.com)

# cloudops-terraform

This repo contains the code that establishes [CloudOps Infrastructure](docs/infra.md), plus code created by the [DXC Migration Project](docs/dxc.md) to establish our enterprise cloud platforms.

Please don't put anything else into this repo, it's not to be used to PoCs or general testing - it's too important!

## Repo Structure
- [.github](.github) Git configuration
- [ci](ci) The Makefile and configuration files for the Concourse pipelines
- [scripts](scripts) Useful bash shell scripts
- [providers/aws](providers/aws)
  - [dev](providers/aws/dev) Development
  - [staging](providers/aws/staging) Testing
  - [prod](providers/aws/prod) Production
- [modules](modules) The terraform modules used to establish AWS resources
- [docs](docs) Documentation in markdown format


