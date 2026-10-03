
# Agama (agama)

Development container for the Agama installer based on openSUSE Leap or openSUSE Tumbleweed.

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| imageVariant | openSUSE base system: | string | leap:16.0 |
| agamaVariant | Agama development environment: | string | all-in-one |
| googleGemini | Install the Gemini Code Assist support (with SUSE configuration) | boolean | true |
| anthropicClaude | Install the Anthropic Claude support (with SUSE configuration) | boolean | true |

## Agama variants

The `agamaVariant` option selects the [Agama](https://github.com/agama-project/agama)
development environment:

| Value        | Packages                                     | VS Code extensions                     | Avahi mount |
| ------------ | -------------------------------------------- | -------------------------------------- | ----------- |
| `all-in-one` | all below                                    | all below                              | yes         |
| `base`       | `gettext-tools`                              | generic only                           | no          |
| `kiwi`       | `python3-kiwi`, `bats`                       | XML (with the Kiwi schema)             | no          |
| `ruby`       | Ruby development, `ruby-lsp` gem, `nss-mdns` | Ruby LSP, endwise, YARD                | yes         |
| `rust`       | Rust and C/C++ development, `nss-mdns`       | rust-analyzer, TOML, Jsonnet, C++      | yes         |
| `web`        | `nodejs`, `npm`, `nss-mdns`                  | color picker, ESLint, npm IntelliSense | yes         |

- To switch the variant later change both `AGAMA_VARIANT` in
  `.devcontainer/Dockerfile` and the `agama-<variant>` feature in
  `.devcontainer/devcontainer.json`.
- The host `/run/avahi-daemon` is mounted for resolving `.local` names (mDNS).
  Remove the mount from the `agama-<variant>` feature if Avahi does not run on
  the host, the container fails to start otherwise.

## Notes

- `imageVariant`: `registry.opensuse.org/opensuse/leap:16.0` or
  `registry.opensuse.org/opensuse/tumbleweed` base image.
- `googleGemini`: `google.geminicodeassist` extension and
  `~/.gemini/trustedFolders.json`.
- `anthropicClaude`: `Anthropic.claude-code` extension, `~/.claude/settings.json`
  (no login prompt) and `google-cloud-cli` (`x86_64` and `aarch64` only),
  `gcloud-login.sh` runs on container creation when not logged in yet.
- The AI configuration is copied to the home directory only when missing, edit
  `.devcontainer/features/*-true` to change the defaults.
- The home directory is a persistent volume, it survives container rebuilds.
- Tuned for Podman, for Docker remove `runArgs` (`--userns=keep-id`) from
  `.devcontainer/devcontainer.json`.

## Visual Studio Code

Select **Add configuration to workspace**, with the user data folder the build
fails with _Local file path parse error_ (the local features must be in the
workspace).

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


---

_Note: This file was auto-generated from the [devcontainer-template.json](https://github.com/lslezak/suse-devcontainer/blob/main/src/agama/devcontainer-template.json).  Add additional notes to a `NOTES.md`._
