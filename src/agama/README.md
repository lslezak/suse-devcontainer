
# Agama (agama)

Development container for the Agama installer based on openSUSE Leap or openSUSE Tumbleweed.

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| imageVariant | openSUSE base system: | string | leap:16.1 |
| agamaVariant | Agama development environment: | string | all-in-one |
| mdns | Resolve the *.local host names (mDNS) via the host Avahi daemon | boolean | false |
| googleGemini | Install the Gemini Code Assist support (with SUSE configuration) | boolean | true |
| anthropicClaude | Install the Anthropic Claude support (with SUSE configuration) | boolean | true |

## Agama variants

The `agamaVariant` option selects the [Agama](https://github.com/agama-project/agama)
development environment:

| Value        | Packages                         | VS Code extensions                     |
| ------------ | -------------------------------- | -------------------------------------- |
| `all-in-one` | all below                        | all below                              |
| `base`       | `gettext-tools`                  | generic only                           |
| `kiwi`       | `python3-kiwi`, `bats`           | XML (with the Kiwi schema)             |
| `ruby`       | Ruby development, `ruby-lsp` gem | Ruby LSP, endwise, YARD                |
| `rust`       | Rust and C/C++ development       | rust-analyzer, TOML, Jsonnet, C++      |
| `web`        | `nodejs`, `npm`                  | color picker, ESLint, npm IntelliSense |

- To switch the variant later change both `AGAMA_VARIANT` in
  `.devcontainer/Dockerfile` and the `agama-<variant>` feature in
  `.devcontainer/devcontainer.json`.

## Notes

- `imageVariant`: `registry.opensuse.org/opensuse/leap:16.0` or
  `registry.opensuse.org/opensuse/tumbleweed` base image.
- `mdns`: `nss-mdns` and the host `/run/avahi-daemon` mount for resolving the
  `.local` host names, Avahi must run on the host, the container fails to start
  otherwise.
- `googleGemini`: `google.geminicodeassist` extension and
  `~/.gemini/trustedFolders.json`.
- `anthropicClaude`: `Anthropic.claude-code` extension, `~/.claude/settings.json`
  (no login prompt) and `google-cloud-cli` (`x86_64` and `aarch64` only),
  run `gcloud-login.sh` to log in (a hint is printed when attaching).
- The AI configuration is copied to the home directory only when missing, edit
  `.devcontainer/features/*-true` to change the defaults.
- The packages for `mdns` or `anthropicClaude` are installed in the Dockerfile
  (the feature layers are not cached), to change the option later update both
  the `ARG` in `.devcontainer/Dockerfile` and the feature in
  `.devcontainer/devcontainer.json`.
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
