## Customization

Add the packages needed by your project to `DEVEL_PACKAGES` in
`.devcontainer/Containerfile`.

## Notes

- The AI configuration is copied to the home directory only when missing, edit
  `.devcontainer/features/*` to change the defaults.
- The home directory is a persistent volume, it survives container rebuilds.
- Tuned for Podman, for Docker remove `runArgs` (`--userns=keep-id`) from
  `.devcontainer/devcontainer.json`.

## Links

See more details in the [README.md](README.md) file.
