
# openSUSE (opensuse)

Development container based on openSUSE Leap or openSUSE Tumbleweed with common development tools and a non-root user.

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| imageVariant | openSUSE base system: | string | leap:16.0 |

## Base system

The `imageVariant` option selects the base image:

| Value       | Image                                         |
| ----------- | --------------------------------------------- |
| `leap:16.0` | `registry.opensuse.org/opensuse/leap:16.0`    |
| `tumbleweed`| `registry.opensuse.org/opensuse/tumbleweed`   |

## Customization

- Add packages needed by your project to the `DEVEL_PACKAGES` argument in the
  `.devcontainer/Dockerfile` file.
- The `vscode` user home directory is stored in a persistent volume, the shell
  history, caches and configuration survive container rebuilds.

## Podman vs. Docker

The configuration is tuned for [Podman](https://podman.io/). When using
Docker remove the `runArgs` section from the `.devcontainer/devcontainer.json`
file, the `--userns=keep-id` option is not supported by Docker.

## Google Cloud CLI

The `google-cloud-cli` package is installed from the Google repository, which
provides packages only for the `x86_64` and `aarch64` architectures. Remove it
together with the repository from the `Dockerfile` if you do not need it.


---

_Note: This file was auto-generated from the [devcontainer-template.json](https://github.com/lslezak/suse-devcontainer-template/blob/main/src/opensuse/devcontainer-template.json).  Add additional notes to a `NOTES.md`._
