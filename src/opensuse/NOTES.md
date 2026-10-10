## Customization

Add the packages needed by your project to `DEVEL_PACKAGES` in
`.devcontainer/Dockerfile`.

## Notes

- The AI configuration is copied to the home directory only when missing, edit
  `.devcontainer/features/*-true` to change the defaults.
- The packages for `anthropicClaude` are installed in the Dockerfile (the
  feature layers are not cached), to change the option later update both the
  `ARG` in `.devcontainer/Dockerfile` and the feature in
  `.devcontainer/devcontainer.json`.
- The home directory is a persistent volume, it survives container rebuilds.
- Tuned for Podman, for Docker remove `runArgs` (`--userns=keep-id`) from
  `.devcontainer/devcontainer.json`.

## Links

See more details in the [README.md](README.md) file.
