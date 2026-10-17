# The openSUSE base image, "leap:16.1", "leap:16.0" or "tumbleweed"
# hadolint ignore=DL3006
FROM registry.opensuse.org/opensuse/${templateOption:imageVariant}

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
# Sync the Tumbleweed image content first with "zypper dup"
# hadolint ignore=SC1091
RUN . /etc/os-release \
    && if [ "$ID" = "opensuse-tumbleweed" ]; then \
      zypper modifyrepo --disable repo-openh264; \
      zypper --non-interactive dup --allow-downgrade; \
      if [ "$REPO_CLEANUP" = "true" ]; then zypper clean -a; fi
    else \
      zypper modifyrepo --disable openSUSE:repo-openh264; \
    fi

# Install the common packages, the Agama specific packages are installed by the
# agama-* feature in the devcontainer.json file
RUN zypper --non-interactive --gpg-auto-import-keys install --no-recommends --allow-downgrade \
      $BASE_PACKAGES \
    && if [ "$REPO_CLEANUP" = "true" ]; then zypper clean -a; fi

# additional packages, add your own here
# (declared after the common layer, changing it does not invalidate that layer)
ARG EXTRA_PACKAGES=""

RUN if [ -n "$DEVEL_PACKAGES" ]; then \
      zypper --non-interactive --gpg-auto-import-keys install --no-recommends --allow-downgrade \
        $EXTRA_PACKAGES \
      && if [ "$REPO_CLEANUP" = "true" ]; then zypper clean -a; fi; \
    fi

# Set up a non-root user (recommended for dev containers)
# hadolint ignore=DL3064
ARG USERNAME=vscode
RUN useradd -s /bin/bash --uid 1000 --gid users -m $USERNAME \
    && mkdir -p /etc/sudoers.d/ \
    && echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Set the default user
USER $USERNAME
