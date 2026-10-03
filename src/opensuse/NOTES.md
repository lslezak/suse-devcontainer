## Customization

Add the packages needed by your project to `DEVEL_PACKAGES` in
`.devcontainer/Dockerfile`.

## Notes

- `imageVariant`: `registry.opensuse.org/opensuse/leap:16.0` or
  `registry.opensuse.org/opensuse/tumbleweed` base image.
- `googleGemini`: `google.geminicodeassist` extension and
  `~/.gemini/trustedFolders.json`.
- `anthropicClaude`: `Anthropic.claude-code` extension, `~/.claude/settings.json`
  (no login prompt) and `google-cloud-cli` (`x86_64` and `aarch64` only),
  `gcloud-login.sh` runs when attaching to the container if not logged in yet.
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
