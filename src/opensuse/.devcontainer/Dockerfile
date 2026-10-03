# The openSUSE base image, "leap:16.0" or "tumbleweed"
# the tag is part of the template option value
# hadolint ignore=DL3006
FROM registry.opensuse.org/opensuse/${templateOption:imageVariant}

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

# AI code assisting related packages, the agents usually run Bash or Python code
# snippets, the AI specific packages are installed below or by the features
# referenced in the devcontainer.json file
ARG AI_PACKAGES="python3 python3-pip"

# Install the common packages, the layer is shared by all images built from
# this template
RUN zypper --non-interactive --gpg-auto-import-keys install --no-recommends \
    $BASE_PACKAGES $AI_PACKAGES \
    && zypper clean -a

# Google Cloud CLI for accessing Claude via Vertex AI (x86_64 and aarch64 only).
# Installed here and not in the "claude-true" feature, the Dockerfile layers are
# cached while the feature layers are rebuilt every time. When changing it
# update also the "claude-*" feature in the devcontainer.json file.
ARG ANTHROPIC_CLAUDE="${templateOption:anthropicClaude}"

# the standard repositories are disabled to have faster refresh
RUN if [ "$ANTHROPIC_CLAUDE" = "true" ]; then \
      zypper modifyrepo --all --disable \
      && zypper ar -f "https://packages.cloud.google.com/yum/repos/cloud-sdk-el10-$(uname -m)" google-cloud-rhel10 \
      && zypper --non-interactive --gpg-auto-import-keys install --no-recommends google-cloud-cli \
      && zypper clean -a \
      && zypper modifyrepo --all --enable; \
    fi

# packages needed for developing your project, add your own here
# (declared after the common layer, changing it does not invalidate that layer)
ARG DEVEL_PACKAGES=""

RUN if [ -n "$DEVEL_PACKAGES" ]; then \
      zypper --non-interactive --gpg-auto-import-keys install --no-recommends \
        $DEVEL_PACKAGES \
      && zypper clean -a; \
    fi

# Set up a non-root user (recommended for dev containers)
# the user name is not sensitive data
# hadolint ignore=DL3064
ARG USERNAME=vscode
RUN useradd -s /bin/bash --uid 1000 --gid users -m $USERNAME \
    && mkdir -p /etc/sudoers.d/ \
    && echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Set the default user
USER $USERNAME
