# openSUSE Dev Container Templates

[Dev Container Templates](https://containers.dev/implementors/templates/) based
on [openSUSE](https://www.opensuse.org/).

| Template                 | Description                                                                                        |
| ------------------------ | -------------------------------------------------------------------------------------------------- |
| [opensuse](src/opensuse) | openSUSE Leap 16.0 or Tumbleweed with common development tools, optional Gemini and Claude support |

## Usage

The templates are published to the GitHub Container Registry. Apply a template
to your project with the [devcontainer CLI](https://github.com/devcontainers/cli):

```sh
# openSUSE Leap 16.0 (default)
devcontainer templates apply --workspace-folder . \
  --template-id ghcr.io/lslezak/suse-devcontainer-template/opensuse

# openSUSE Tumbleweed
devcontainer templates apply --workspace-folder . \
  --template-id ghcr.io/lslezak/suse-devcontainer-template/opensuse \
  --template-args '{"imageVariant": "tumbleweed"}'

# without the AI code assistants
devcontainer templates apply --workspace-folder . \
  --template-id ghcr.io/lslezak/suse-devcontainer-template/opensuse \
  --template-args '{"googleGemini": "false", "anthropicClaude": "false"}'
```

Then open the project in VS Code and run the _Dev Containers: Reopen in
Container_ command.

## Repository structure

```text
├── src
│   └── opensuse
│       ├── devcontainer-template.json   # template metadata and options
│       ├── NOTES.md                     # additional documentation
│       └── .devcontainer                # files copied to the user project
│           ├── devcontainer.json
│           └── Dockerfile
├── features                             # features used by the templates
│   ├── claude-false                     # (optional AI code assistants)
│   ├── claude-true
│   ├── gemini-false
│   └── gemini-true
└── test
    ├── smoke-test.sh                    # builds and tests a template
    ├── opensuse
    │   └── test.sh                      # tests running inside the container
    └── test-utils
        └── test-utils.sh
```

Template options are referenced as `${templateOption:<option>}` in the template
files, the value is substituted when the template is applied.

The templates reference the features published to
`ghcr.io/lslezak/suse-devcontainer-template/features/<feature-id>`. Local
features (`./features/...`) cannot be used in templates, VS Code requires them
to be located in the `.devcontainer` directory in the workspace, which does not
work when the configuration is stored in the VS Code user data folder.

## Testing

Build a template and run its tests in the container (requires the
[devcontainer CLI](https://github.com/devcontainers/cli), `jq` and Podman):

```sh
test/smoke-test.sh opensuse imageVariant=tumbleweed
```

Set the `CONTAINER_ENGINE` environment variable to use a different container
engine. The test uses the features from the `features` directory instead of the
published ones, set the `USE_PUBLISHED_FEATURES=1` environment variable to test
the published features.

## Releasing

1. Increase the `version` in the changed `devcontainer-template.json` and
   `devcontainer-feature.json` files. When increasing the major version of a
   feature update the references in the templates.
2. Run the [Release](.github/workflows/release.yaml) workflow manually from the
   GitHub Actions page. It publishes the features to
   `ghcr.io/lslezak/suse-devcontainer-template/features/<feature-id>`, the
   templates to `ghcr.io/lslezak/suse-devcontainer-template/<template-id>` and
   creates a pull request with the updated documentation.
3. Make the published packages public in the GitHub package settings (only
   after the first release).

To make the templates discoverable in VS Code and other tools add the
repository to the
[community index](https://containers.dev/collections) (see
[publishing](https://containers.dev/implementors/templates-distribution/#adding-templates-to-the-index)).

## License

[MIT](LICENSE)
