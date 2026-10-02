
# openSUSE (opensuse)

Development container based on openSUSE Leap or openSUSE Tumbleweed with common development tools and a non-root user.

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| imageVariant | openSUSE base system: | string | leap:16.0 |
| googleGemini | Install the Gemini Code Assist support (with SUSE configuration) | boolean | true |
| anthropicClaude | Install the Anthropic Claude support (with SUSE configuration) | boolean | true |

## Customization

Add the packages needed by your project to `DEVEL_PACKAGES` in
`.devcontainer/Dockerfile`.

## Notes

- `imageVariant`: `registry.opensuse.org/opensuse/leap:16.0` or
  `registry.opensuse.org/opensuse/tumbleweed` base image.
- `googleGemini`: `google.geminicodeassist` extension and
  `~/.gemini/trustedFolders.json`.
- `anthropicClaude`: `Anthropic.claude-code` extension, `~/.claude/settings.json`
  (no login prompt) and `google-cloud-cli` (`x86_64` and `aarch64` only).
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

_Note: This file was auto-generated from the [devcontainer-template.json](https://github.com/lslezak/suse-devcontainer/blob/main/src/opensuse/devcontainer-template.json).  Add additional notes to a `NOTES.md`._
