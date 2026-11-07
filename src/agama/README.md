
# Agama (agama)

Development container for the Agama installer based on openSUSE Leap or openSUSE Tumbleweed.

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| imageVariant | openSUSE base system: | string | leap:16.1 |

## Customization

- Select which parts of the Agama you want to develop. Comment out the not
  wanted features in `devcontainer.json` file.
- Add the packages needed by your project to `EXTRA_PACKAGES` in
  `.devcontainer/Containerfile`.

## Notes

- The AI configuration is copied to the home directory only when missing, edit
  `.devcontainer/features/*` to change the defaults.
- The home directory is a persistent volume, it survives container rebuilds.
- Tuned for Podman, for Docker remove `runArgs` (`--userns=keep-id`) from
  `.devcontainer/devcontainer.json`.

## Links

See more details in the [README.md](README.md) file.


---

_Note: This file was auto-generated from the [devcontainer-template.json](https://github.com/lslezak/suse-devcontainer/blob/main/src/agama/devcontainer-template.json).  Add additional notes to a `NOTES.md`._
