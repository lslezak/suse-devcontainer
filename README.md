# openSUSE Dev Container Templates

[![Release Templates & Generate Documentation](https://github.com/lslezak/suse-devcontainer/actions/workflows/release.yaml/badge.svg)](https://github.com/lslezak/suse-devcontainer/actions/workflows/release.yaml)
[![Test Templates](https://github.com/lslezak/suse-devcontainer/actions/workflows/test.yaml/badge.svg)](https://github.com/lslezak/suse-devcontainer/actions/workflows/test.yaml)
[![Validate Templates](https://github.com/lslezak/suse-devcontainer/actions/workflows/validate.yaml/badge.svg)](https://github.com/lslezak/suse-devcontainer/actions/workflows/validate.yaml)

This repository contains [Dev Container Templates](https://containers.dev/implementors/templates/)
based on [openSUSE](https://www.opensuse.org/) Linux distro. The containers are suitable for
development and programming in openSUSE.

| Template                 | Description                                                                     |
| ------------------------ | ------------------------------------------------------------------------------- |
| [opensuse](src/opensuse) | openSUSE Leap or Tumbleweed image with generic development tools                |
| [agama](src/agama)       | openSUSE + [Agama][Agama] installer development tools (Rust, Ruby, React, Kiwi) |

[Agama]: https://github.com/agama-project/agama

For both it is possible to enable optional Gemini and Claude support with SUSE employee
authentication configuration.

## Advantages

Developing in a containerized sandbox provides many useful advantages:

- All needed development tools are automatically installed.
- Ensures all developers have the same environment.
- You can develop from different version or from a completely different
  distribution (or even from Windows using WSL containers).
- The sandbox is useful when running AI code assisting tools.
- If you mess up the development system you can just rebuild the container and
  start from scratch.
- Want to develop on openSUSE Tumbleweed instead of Leap? Just switch the base
  system image and rebuild the container!

## Usage

The dev container can be either used in [Visual Studio Code](https://code.visualstudio.com/) /
[VSCodium](https://vscodium.com/) or with the Devcontainer CLI.

### Podman

The containers here are configured for running in
[Podman](https://docs.podman.io/en/latest/) instead of the default
[Docker](https://docs.docker.com/).

#### Installation and Configuration

1. Install Podman with `sudo zypper install podman`
2. Tell VSCode to use `podman` instead of the default `docker`. Navigate to
   *Settings* (`Ctrl+,`) -> *Extensions* -> *Dev Containers*.
3. Set the *Docker Path* value to "podman" and the *Docker Compose Path* to
   "podman-compose".
4. The settings can be also changed from the command line by editing the VSCode
   user `settings.json` file with `jq`:

   ```shell
   f=~/.config/Code/User/settings.json
   mkdir -p "$(dirname "$f")"
   [ -f "$f" ] || echo '{}' > "$f"
   jq '. + {"dev.containers.dockerPath": "podman",
            "dev.containers.dockerComposePath": "podman-compose"}' "$f" \
     > "$f.tmp" && mv "$f.tmp" "$f"
   ```

   Notes: If your `settings.json` contains comments, `jq` cannot parse it,
   edit the file manually in that case. For VSCodium use the
   `~/.config/VSCodium/User/settings.json` path.

### Visual Studio Code

1. From the command palette (`F1` or `Ctrl+Shift+P`) select **Dev Containers:
   Add Dev Container Configuration Files**
2. Select **Add configuration to workspace** (the user data folder is not
   supported, the installation would fail there).
3. Then insert either the `ghcr.io/lslezak/suse-devcontainer/opensuse` or
   `ghcr.io/lslezak/suse-devcontainer/agama` name of the template depending
   which container you want to use.
4. Select the base product used for the new container, either openSUSE Leap
   or openSUSE Tumbleweed.
5. Then you can select some community features, but be careful, many of them
   support only few Linux distributions. Quite often they are written only for
   Ubuntu or Fedora and do not support openSUSE. (They usually install
   additional packages using `apt` or `dnf` without `zypper` support.)
   It's recommended to just skip this without selecting any additional features.
6. Then the container files will be generated to the `.devcontainer` folder. You
   can inspect them or possibly modify to fit your needs. See the [Customization
   section](#customization) below.
7. If you selected the Agama container then select which Agama components you
   want to develop. The full container image is quite big, almost 3GB. If you
   want to work only on a particular Agama part (like the Web frontend only) you
   can select only the dev container feature for that part and save some disk
   space.
8. After opening the folder in VSCode click **Open in Container** in the bottom
   right corner or manually select **Dev Containers: Rebuild and Open in
   Container** from the command palette.
9. Enjoy your openSUSE Dev Container and have a lot of fun! 😃

### Devcontainer CLI

Install the [devcontainer CLI](https://github.com/devcontainers/cli) from npm
(requires Node.js), the `devcontainer` command is installed to `~/.local/bin`:

```sh
sudo zypper install npm-default
npm install --global --prefix ~/.local @devcontainers/cli
```

Alternatively run it without installing via `npx @devcontainers/cli`.

Apply a template in the current directory:

```sh
devcontainer templates apply --workspace-folder . \
  --template-id ghcr.io/lslezak/suse-devcontainer/opensuse \
  --template-args '{"imageVariant": "tumbleweed"}'
```

```sh
devcontainer templates apply --workspace-folder . \
  --template-id ghcr.io/lslezak/suse-devcontainer/agama \
  --template-args '{"imageVariant": "leap:16.1"}'
```

Start the dev container (the CLI uses `docker` by default, use the `--docker-path` and
`--docker-compose-path` options to run it with Podman):

```sh
devcontainer up --workspace-folder . --docker-path podman
```

Run a command in the running dev container, e.g. open a shell:

```sh
devcontainer exec --workspace-folder . --docker-path podman 
```

To rebuild the image from scratch (e.g. after changing the `Containerfile`) add the
`--build-no-cache --remove-existing-container` options to the `devcontainer up` command.

Stop the dev container (the CLI has no command for it, use Podman directly):

```sh
podman stop $(podman ps -q --filter label=devcontainer.local_folder="$PWD")
```

## Devcontainer parts

The devcontainer contains several parts in the `.devcontainer` directory:

- `Containerfile` - the main container image definition, defines what is inside
- `devcontainer.json` - defines how to run the container, which VSCode extensions should be
  installed, installs [devcontainer features](https://containers.dev/implementors/features/) (small
  shareable parts of the container configuration)
- `features/*` - implement a small shareable self-contained container feature, the `install.sh` is
  run during image build (basically extends the `Containerfile`), the `devcontainer-feature.json` file
  extends the base `devcontainer.json` file.

## Customization

For basic customization you can change these values:

- Enable/disable the features in the `devcontainer.json` file
- Change the list of installed VSCode extensions
- [Configure hooks](https://containers.dev/implementors/json_reference/#lifecycle-scripts)
- Install additional packages in `Containerfile` (see the `EXTRA_PACKAGES` argument)

## Keeping the configuration out of the project

There are two options for tracking the configuration outside of the project.

First exclude it from the local repository:

```sh
echo "/.devcontainer/" >> .git/info/exclude
```

### Separate repositories

Track each dev container in a separate repository:

```sh
cd .devcontainer
git init -b main && git add . && git commit -m "Dev container configuration"
gh repo create <project>-devcontainer --private --source . --push
```

To restore it in another checkout:

```sh
git clone git@github.com:<user>/<project>-devcontainer.git .devcontainer
echo "/.devcontainer/" >> .git/info/exclude
```

### Multiple dev containers in a single repository

Instead of one repository per project you can keep the configuration of all projects in a single git
repository. Mimic the URL of each project in the directory structure:

```text
devcontainers/
├── github.com/
│   ├── openSUSE/
│   │   └── agama/
│   │       └── .devcontainer/
│   │           ├── Containerfile
│   │           ├── devcontainer.json
│   │           └── features/
│   └── <user>/
│       └── <project>/
│           └── .devcontainer/
└── gitlab.com/
    └── ...
```

Create the repository and add the configuration of the first project:

```sh
mkdir -p ~/devcontainers/github.com/openSUSE/agama
cd ~/devcontainers

# initialize only when there no git repository yet
git init -b main

# move the definition from the project checkout to the new location
mv /path/to/agama/.devcontainer github.com/openSUSE/agama/
git add . && git commit -m "Add the Agama dev container"
```

Set the `dev.containers.repositoryConfigurationPaths` setting to the root of the configuration
repository, then VSCode finds the configuration by the URL of the cloned repository without any
change in the project checkout.

Use *Settings* (`Ctrl+,`) -> *Extensions* -> *Dev Containers* -> *Repository Configuration Paths* ->
*Add Item*, then select the root directory where the devcontainers are stored (i.e. the directory
which contains the `github.com` subdirectory).

To restore everything on another machine just clone the configuration
repository:

```sh
git clone git@github.com:<user>/devcontainers.git ~/devcontainers
```

And configure the `repositoryConfigurationPaths` option as described above.

## Maintaining dev containers

Dev containers can use a lot of disk space, especially the big images like Agama. Use the **Dev
Containers: Clean Up Dev Containers...** and **Dev Containers: Clean Up Dev Volumes...** commands
from the VSCode command palette to delete unused containers and volumes.

Or you can use the following commands to maintain dev containers manually. All of them use `podman`,
for Docker just replace the `podman` command with `docker`.

### Listing running containers

```sh
# running containers
podman ps

# all containers including the stopped ones
podman ps --all

# only the dev containers (started by VSCode or the devcontainer CLI)
podman ps --all --filter label=devcontainer.local_folder

# the same with the project folder of each container (the label value is not
# available in the Go template of older Podman versions, use JSON and jq)
podman ps --all --filter label=devcontainer.local_folder --format json |
  jq -r '.[] | [.Id[0:12], .Names[0], .State, .Labels["devcontainer.local_folder"]] | @tsv'
```

### Listing dev container images

The images built by VSCode and the devcontainer CLI are named `vsc-<folder>-<hash>`
(possibly with a `-uid` suffix):

```sh
podman images --filter reference='vsc-*'

# all images with their sizes
podman images

# disk usage summary of images, containers and volumes
podman system df
```

### Deleting dev containers, images and volumes

A container must be removed before its image can be removed. Find the container and the image of the
project (the `vsc-<folder>-` prefix is the name of the project folder):

```sh
# stop and remove the dev container of the current folder
podman rm --force $(podman ps --all --quiet \
  --filter label=devcontainer.local_folder="$PWD")

# remove the images of the project
podman rmi $(podman images --quiet --filter reference='vsc-<folder>-*')
```

To remove *all* dev container images (after removing their containers):

```sh
podman rmi $(podman images --quiet --filter reference='vsc-*')
```

Dev containers can also use named volumes (the repositories cloned in a container volume, volumes
defined in `devcontainer.json` or in a compose file). List and remove them:

```sh
podman volume ls

# remove a volume, fails if it is still used by a container
podman volume rm <volume-name>

# remove all volumes not used by any container (this DELETES their data!)
podman volume prune
```

### Listing old unused dev containers and images

Podman does not track when an image was last used, so "unused for a month" in the following examples
has to be approximated.

Stopped dev containers which exited more than 30 days ago:

```sh
podman ps --all --filter label=devcontainer.local_folder --format json |
  jq -r '.[] | select(.State != "running" and .ExitedAt < now - 30*86400)
         | [.Id[0:12], .Names[0], (.ExitedAt | todate), .Labels["devcontainer.local_folder"]]
         | @tsv'
```

Dev container images created more than 30 days ago (the creation time is used, not the last usage
time, so an old image can still be in use by a running container, `podman rmi` refuses to remove
such image):

```sh
podman images --filter reference='vsc-*' --filter until=720h
```

To remove them (the removal of the images used by a container fails, remove the old containers
listed above first):

```sh
podman container prune --filter until=720h
podman image prune --all --filter until=720h
```

Note: `podman container prune` removes all stopped containers created more than 720 hours (30 days)
ago, not only the dev containers. And `podman image prune --all` removes all unused images, not only
the dev container ones.

### Freeing disk space

Rebuilding the images leaves dangling (untagged) image layers behind. To remove them, for all
images, not only for the dev containers:

```sh
# remove only the dangling images
podman image prune

# remove also the unused images (not used by any container) and the build cache
podman image prune --all
podman builder prune --all

# remove all unused data: stopped containers, unused images, networks and
# the build cache (add --volumes to remove also the unused volumes)
podman system prune
```

## Updating containers

In theory you could run `zypper patch` or `zypper up` in the containers, but the containers are
usually rebuilt from scratch instead of updating. The problem is that the space taken by the updated
packages is not freed because they are still stored in an old snapshot.

After rebuilding the container you should cleanup the dangling images (see above) to really free the
space.

## Development

- Template options are substituted for `${templateOption:<option>}` in the
  template files.
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
