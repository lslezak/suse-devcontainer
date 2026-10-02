## Agama development environment

Development container for the [Agama](https://github.com/agama-project/agama)
installer. The `agamaVariant` option selects the development environment:

| Value        | Packages                                       | VS Code extensions                     | Avahi mount |
| ------------ | ---------------------------------------------- | -------------------------------------- | ----------- |
| `all-in-one` | all below                                      | all below                              | yes         |
| `base`       | `gettext-tools`                                | generic only                           | no          |
| `kiwi`       | `python3-kiwi`, `bats`                         | XML (with the Kiwi schema)             | no          |
| `ruby`       | Ruby development, `ruby-lsp` gem, `nss-mdns`   | Ruby LSP, endwise, YARD                | yes         |
| `rust`       | Rust and C/C++ development, `nss-mdns`         | rust-analyzer, TOML, Jsonnet, C++      | yes         |
| `web`        | `nodejs`, `npm`, `nss-mdns`                    | color picker, ESLint, npm IntelliSense | yes         |

The packages are installed in the `.devcontainer/Dockerfile` file, the VS Code
extensions, settings and mounts are defined by the `agama-<variant>` features in
the `.devcontainer/features` directory. To switch the variant later change both
the `AGAMA_VARIANT` argument in the `Dockerfile` and the `agama-<variant>`
feature in the `devcontainer.json` file.

The `/run/avahi-daemon` directory is bind mounted from the host to allow
resolving the `.local` host names (mDNS) via the host Avahi daemon. The whole
directory is mounted so the socket still works after restarting the Avahi
daemon on the host. Remove the mount from the `agama-<variant>` feature if
Avahi is not running on the host, the container fails to start otherwise.

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
feature directories (including the unused `agama-*` variants) after applying
the template.

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

### Tracking the configuration in a separate repository

You can still keep the excluded `.devcontainer` directory under version control
in its own Git repository, for example to share it between your machines.

1. Exclude the directory from the project repository:

   ```sh
   echo ".devcontainer/" >> .git/info/exclude
   ```

2. Create a new repository in the `.devcontainer` directory and commit the
   configuration:

   ```sh
   cd .devcontainer
   git init -b main
   git add .
   git commit -m "Initial devcontainer configuration"
   ```

3. Create an empty repository at GitHub (do not add a README, license or
   `.gitignore` file) and push the configuration there:

   ```sh
   git remote add origin git@github.com:<user>/<project>-devcontainer.git
   git push -u origin main
   ```

   Alternatively use the [GitHub CLI](https://cli.github.com/) which creates the
   repository, adds the remote and pushes in one step:

   ```sh
   gh repo create <project>-devcontainer --private --source . --push
   ```

To use the configuration in another checkout of the project clone it into the
`.devcontainer` directory and exclude it again (the exclude file is local and
not cloned):

```sh
git clone git@github.com:<user>/<project>.git
cd <project>
git clone git@github.com:<user>/<project>-devcontainer.git .devcontainer
echo ".devcontainer/" >> .git/info/exclude
```

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
