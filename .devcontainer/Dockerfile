# Use the openSUSE Leap 16.0 base image
FROM registry.opensuse.org/opensuse/leap:16.0

# Alternatively you can use another base like openSUSE Tumbleweed
# FROM registry.opensuse.org/opensuse/tumbleweed:latest

# base packages
ARG BASE_PACKAGES="bash-completion \
  command-not-found \
  curl \
  diffutils \
  findutils \
  gawk \
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

# packages needed for developing container for *this* repository
ARG DEVEL_PACKAGES="\
    hadolint \
    python3-pipx"

# AI code assisting related packages
ARG AI_PACKAGES="google-cloud-cli python3 python3-pip"

RUN zypper ar -f https://packages.cloud.google.com/yum/repos/cloud-sdk-el10-x86_64 google-cloud-rhel10

# Install all packages at once
RUN zypper --non-interactive --gpg-auto-import-keys install --no-recommends \
    $BASE_PACKAGES $DEVEL_PACKAGES $AI_PACKAGES \
    && zypper clean -a

# Install check-jsonschema for validating the devcontainer.json files (json5 is
# needed for parsing JSONC files). Install it globally, the home directory is
# overlaid by a persistent volume at runtime.
RUN export PIPX_HOME=/opt/pipx PIPX_BIN_DIR=/usr/local/bin \
    && pipx install check-jsonschema \
    && pipx inject check-jsonschema json5

# Set up a non-root user (recommended for dev containers)
ARG USERNAME=vscode
RUN useradd -s /bin/bash --uid 1000 --gid users -m $USERNAME \
    && mkdir -p /etc/sudoers.d/ \
    && echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Set the default user
USER $USERNAME
