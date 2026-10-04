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

See the template documentation for the options. In VS Code select **Add
configuration to workspace**, the user data folder is not supported. Then insert
either the `ghcr.io/lslezak/suse-devcontainer/opensuse` or
`ghcr.io/lslezak/suse-devcontainer/agama` value depending which container you
want to use.

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
