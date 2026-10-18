# The openSUSE base image, "leap:16.1" or "tumbleweed"
# hadolint ignore=DL3006
FROM registry.opensuse.org/opensuse/leap:16.1

# whether delete the libzypp cache after installing packages
# false - keep the caches, the image builds faster but it is slightly bigger
# true - the image is slightly smaller, but takes much more time to build
# (the value is exported so it is used also by the features)
ARG REPO_CLEANUP="false"
ENV REPO_CLEANUP=$REPO_CLEANUP

# base packages
ARG BASE_PACKAGES="bash-completion \
  command-not-found \
  curl \
  diffutils \
  findutils \
  gawk \
  gh \
  git \
  glibc-locale-base \
  gpg2 \
  grep \
  gzip \
  jq \
  make \
  openssh-clients \
  patch \
  procps \
  ripgrep \
  shadow \
  ShellCheck \
  shfmt \
  sudo \
  tar \
  wdiff \
  wget \
  which \
  xz \
  yq"

# Disable the openH.264 repo to have faster refresh
# hadolint ignore=SC1091
RUN . /etc/os-release \
    && if [ "$ID" = "opensuse-tumbleweed" ]; then \
      zypper modifyrepo --disable repo-openh264; \
    else \
      zypper modifyrepo --disable openSUSE:repo-openh264; \
    fi

# Install the common packages, the layer is shared by all images built from
# this template
RUN zypper --non-interactive --gpg-auto-import-keys install --no-recommends \
    $BASE_PACKAGES \
    && if [ "$REPO_CLEANUP" = "true" ]; then zypper clean -a; fi

# packages needed for developing the containers
ARG DEVEL_PACKAGES="\
    hadolint \
    python3-pipx"

RUN if [ -n "$DEVEL_PACKAGES" ]; then \
      zypper --non-interactive --gpg-auto-import-keys install --no-recommends \
        $DEVEL_PACKAGES \
      && if [ "$REPO_CLEANUP" = "true" ]; then zypper clean -a; fi; \
    fi

# Install check-jsonschema for validating the devcontainer.json files (json5 is
# needed for parsing JSONC files). Install it globally, the home directory is
# overlaid by a persistent volume at runtime.
RUN export PIPX_HOME=/opt/pipx PIPX_BIN_DIR=/usr/local/bin \
    && pipx install check-jsonschema \
    && pipx inject check-jsonschema json5

# Set up a non-root user (recommended for dev containers)
# hadolint ignore=DL3064
ARG USERNAME=vscode
RUN useradd -s /bin/bash --uid 1000 --gid users -m $USERNAME \
    && mkdir -p /etc/sudoers.d/ \
    && echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Set the default user
USER $USERNAME
