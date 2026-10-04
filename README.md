# openSUSE Dev Container Templates

[![Release Templates & Generate Documentation](https://github.com/lslezak/suse-devcontainer/actions/workflows/release.yaml/badge.svg)](https://github.com/lslezak/suse-devcontainer/actions/workflows/release.yaml)
[![Test Templates](https://github.com/lslezak/suse-devcontainer/actions/workflows/test.yaml/badge.svg)](https://github.com/lslezak/suse-devcontainer/actions/workflows/test.yaml)
[![Validate Templates](https://github.com/lslezak/suse-devcontainer/actions/workflows/validate.yaml/badge.svg)](https://github.com/lslezak/suse-devcontainer/actions/workflows/validate.yaml)

[Dev Container Templates](https://containers.dev/implementors/templates/) based
on [openSUSE](https://www.opensuse.org/).

| Template                 | Description                                                                                 |
| ------------------------ | ------------------------------------------------------------------------------------------- |
| [opensuse](src/opensuse) | openSUSE Leap 16.0 or Tumbleweed with development tools, optional Gemini and Claude support |
| [agama](src/agama)       | [Agama](https://github.com/agama-project/agama) installer development (Rust, Ruby, web, Kiwi) |

## Advantages

Developing in a containerized sandbox provides many useful advantages:

- All needed development tools are automatically installed.
- Ensures all developers have the same environment.
- You can develop from different version or from a completely different
  distribution (or even from Windows using WSL containers).
- The sandbox is useful when running AI code assisting tools.
- If you mess up the development system you can just rebuild the container and
  start from scratch.
- Want to develop on openSUSE Tumbleweed instead of Leap? Just switch the base
  system image and rebuild the container!

## Usage

### Devcontainer CLI

Install the [devcontainer CLI](https://github.com/devcontainers/cli) from npm
(requires Node.js), the `devcontainer` command is installed to `~/.local/bin`:

```sh
sudo zypper install nodejs npm
npm install --global --prefix ~/.local @devcontainers/cli
```

Alternatively run it without installing via `npx @devcontainers/cli` or in VS
Code use the **Dev Containers: Install devcontainer CLI** command.

Apply a template in the current directory:

```sh
devcontainer templates apply --workspace-folder . \
  --template-id ghcr.io/lslezak/suse-devcontainer/opensuse \
  --template-args '{"imageVariant": "tumbleweed"}'
```

```sh
devcontainer templates apply --workspace-folder . \
  --template-id ghcr.io/lslezak/suse-devcontainer/agama \
  --template-args '{"imageVariant": "leap:16.0"}'
```

### Visual Studio Code

1. From the command palette (`F1` or `Ctrl+Shift+P`) select **Dev Containers:
   Add Dev Container Configuration Files**
2. Select **Add configuration to workspace** (the user data folder is not
   supported, the installation would fail there).
3. Then insert either the `ghcr.io/lslezak/suse-devcontainer/opensuse` or
   `ghcr.io/lslezak/suse-devcontainer/agama` name of the template depending
   which container you want to use.
4. Select the base product used for the new container, either openSUSE Leap 16.0
   or openSUSE Tumbleweed.
5. If you selected the Agama container then select which Agama components you
   want to develop. The full (all-in-one) container image is quite big, almost
   3GB. If you want to work only on a particular Agama part (like Web frontend)
   you can select only that part and save some disk space.
6. Select any additional features you want to install
   1. mDNS support (the Avahi service must be running on the host )
   2. Google Gemini support with SUSE specific configuration
   3. Anthropic Claude support with SUSE specific configuration
7. Then you can select some community features, but be careful, many of them
   support only few Linux distributions. Quite often they are written only for
   Ubuntu or Fedora, but not for openSUSE. (They usually install additional
   packages using `apt` or `dnf` and do not support `zypper`.)
8. Then the container files will be generated to the `.devcontainer` folder. You
   can inspect them or possibly modify to fit your needs.
9. After opening the folder in VSCode click **Open in Container** in the bottom
   right corner or manually select **Dev Containers: Rebuild and Open in
   Container** from the command palette.
10. Enjoy your openSUSE Dev Container and have a lot of fun! 😃

## Keeping the configuration out of the project

Exclude it locally and optionally track it in a separate repository:

```sh
echo ".devcontainer/" >> .git/info/exclude
cd .devcontainer
git init -b main && git add . && git commit -m "Dev container configuration"
gh repo create <project>-devcontainer --private --source . --push
```

To restore it in another checkout:

```sh
git clone git@github.com:<user>/<project>-devcontainer.git .devcontainer
echo ".devcontainer/" >> .git/info/exclude
```

## Development

- Template options are substituted for `${templateOption:<option>}` in the
  template files.
- Optional parts are local features selected by the option value, e.g.
  `./features/gemini-${templateOption:googleGemini}`.
- Each template has its own copy of the features, the shared Gemini and Claude
  features must be identical (checked by the
  [Validate](.github/workflows/validate.yaml) workflow).

Build and test a template (requires the
[devcontainer CLI](https://github.com/devcontainers/cli), `jq` and Podman or
`CONTAINER_ENGINE` set):

```sh
test/smoke-test.sh opensuse imageVariant=tumbleweed
```

## Releasing

1. Increase the `version` in `devcontainer-template.json`.
2. Run the [Release](.github/workflows/release.yaml) workflow, it publishes the
   templates to `ghcr.io/lslezak/suse-devcontainer/<template-id>` and opens
   a pull request with the generated documentation.
3. After the first release make the packages public in the GitHub settings.

## License

[MIT](LICENSE)
