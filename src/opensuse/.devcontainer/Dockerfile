# The openSUSE base image, "leap:16.0" or "tumbleweed"
FROM registry.opensuse.org/opensuse/${templateOption:imageVariant}

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

# packages needed for developing your project, add your own here
ARG DEVEL_PACKAGES=""

# AI code assisting related packages
ARG AI_PACKAGES="google-cloud-cli python3 python3-pip"

# Google Cloud CLI repository (provides x86_64 and aarch64 packages)
RUN zypper ar -f "https://packages.cloud.google.com/yum/repos/cloud-sdk-el10-$(uname -m)" google-cloud-rhel10

# Install all packages at once
RUN zypper --non-interactive --gpg-auto-import-keys install --no-recommends \
    $BASE_PACKAGES $DEVEL_PACKAGES $AI_PACKAGES \
    && zypper clean -a

# Set up a non-root user (recommended for dev containers)
ARG USERNAME=vscode
RUN useradd -s /bin/bash --uid 1000 --gid users -m $USERNAME \
    && mkdir -p /etc/sudoers.d/ \
    && echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Set the default user
USER $USERNAME
