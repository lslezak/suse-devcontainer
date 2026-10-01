## Base system

The `imageVariant` option selects the base image:

| Value       | Image                                         |
| ----------- | --------------------------------------------- |
| `leap:16.0` | `registry.opensuse.org/opensuse/leap:16.0`    |
| `tumbleweed`| `registry.opensuse.org/opensuse/tumbleweed`   |

## AI code assistants

| Option            | Installs                                                                                                                        |
| ----------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| `googleGemini`    | `google.geminicodeassist` VS Code extension, `~/.gemini/trustedFolders.json`, sets `CODER_AGENT_ALLOWED_ROOT=/workspaces`       |
| `anthropicClaude` | `Anthropic.claude-code` VS Code extension, `google-cloud-cli`, `~/.claude/settings.json`, disables the Claude Code login prompt |

Both options are enabled by default. They are implemented by the
[features](https://github.com/lslezak/suse-devcontainer-template/tree/main/features)
published at `ghcr.io/lslezak/suse-devcontainer-template/features`, the option
value selects either the `*-true` feature or the no-op `*-false` feature.

The configuration files are copied to the home directory only when they do not
exist yet, your changes in the persistent home volume are not overwritten.

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

The `google-cloud-cli` package (installed with the `anthropicClaude` option) is
installed from the Google repository, which provides packages only for the
`x86_64` and `aarch64` architectures.
