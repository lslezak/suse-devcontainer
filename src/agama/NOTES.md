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

- To switch the variant later change the `agama-<variant>` feature in
  `.devcontainer/devcontainer.json`, the packages are installed by the feature.

## Notes

- The AI configuration is copied to the home directory only when missing, edit
  `.devcontainer/features/*-true` to change the defaults.
- The home directory is a persistent volume, it survives container rebuilds.
- Tuned for Podman, for Docker remove `runArgs` (`--userns=keep-id`) from
  `.devcontainer/devcontainer.json`.

## Links

See more details in the [README.md](README.md) file.
