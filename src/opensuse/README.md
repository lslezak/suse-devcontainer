
# openSUSE (opensuse)

Development container based on openSUSE Leap or openSUSE Tumbleweed with common development tools and a non-root user.

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| imageVariant | openSUSE base system: | string | leap:16.0 |
| googleGemini | Google Gemini: install the Gemini Code Assist extension and the ~/.gemini/trustedFolders.json file | boolean | true |
| anthropicClaude | Anthropic Claude: install the Claude Code extension, the Google Cloud CLI and the ~/.claude/settings.json file | boolean | true |

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

Both options are enabled by default. They are implemented by the local features
in the `.devcontainer/features` directory, the option value selects either the
`*-true` feature or the no-op `*-false` feature. You can delete the unused
feature directories after applying the template.

The configuration files are copied to the home directory only when they do not
exist yet, your changes in the persistent home volume are not overwritten. Edit
the files in the `.devcontainer/features/*-true` directories to change the
defaults.

## Visual Studio Code

When adding the template in VS Code (_Dev Containers: Add Dev Container
Configuration Files..._ or _Dev Containers: Open Folder in Container..._) select
the **Add configuration to workspace** option. The **Add configuration to user
data folder** option is not supported, the local features must be located in
the `.devcontainer` directory in the workspace, otherwise the build fails with
this error:

```text
Local file path parse error. Resolved path must be a child of the .devcontainer/ folder.
```

If you do not want to commit the configuration to the project add the
`.devcontainer` directory to the local `.git/info/exclude` file.

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


---

_Note: This file was auto-generated from the [devcontainer-template.json](https://github.com/lslezak/suse-devcontainer/blob/main/src/opensuse/devcontainer-template.json).  Add additional notes to a `NOTES.md`._
