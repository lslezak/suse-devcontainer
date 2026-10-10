# The openSUSE base image, "leap:16.1" or "tumbleweed"
# hadolint ignore=DL3006
FROM registry.opensuse.org/opensuse/${templateOption:imageVariant}

# The Agama development environment: "all-in-one", "base", "kiwi", "ruby",
# "rust" or "web". When changing it update also the "agama-*" feature in the
# devcontainer.json file.
ARG AGAMA_VARIANT="${templateOption:agamaVariant}"

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

# Install Google Cloud CLI for accessing Claude via Vertex AI
ARG AI_PACKAGES="python3 python3-pip"

# translations support
ARG GETTEXT_PACKAGES="gettext-tools"

# web frontend
ARG NODE_PACKAGES="\
  nodejs \
  npm"

# Rust backend
ARG RUST_PACKAGES="\
  cargo \
  cargo-audit \
  clang-devel \
  gcc \
  gcc-c++ \
  jsonnet \
  libpwquality-tools \
  libsuseconnect \
  libzypp-devel \
  lshw \
  NetworkManager \
  openssl-devel \
  pam-devel \
  python-langtable-data \
  rust \
  rust-bindgen \
  timezone \
  xkeyboard-config-lang"

# Ruby service
ARG RUBY_PACKAGES="\
  augeas-devel \
  ruby-devel"

# Live ISO
ARG KIWI_PACKAGES="\
  bats \
  python3-kiwi"

# Disable the openH.264 repo to have faster refresh
# hadolint ignore=SC1091
RUN . /etc/os-release \
    && if [ "$ID" = "opensuse-tumbleweed" ]; then \
      zypper modifyrepo --disable repo-openh264; \
    else \
      zypper modifyrepo --disable openSUSE:repo-openh264; \
    fi

# Install all packages at once
# hadolint ignore=SC2086
RUN case "$AGAMA_VARIANT" in \
      all-in-one) VARIANT_PACKAGES="$GETTEXT_PACKAGES $NODE_PACKAGES $RUBY_PACKAGES $RUST_PACKAGES $KIWI_PACKAGES" ;; \
      base) VARIANT_PACKAGES="$GETTEXT_PACKAGES" ;; \
      kiwi) VARIANT_PACKAGES="$KIWI_PACKAGES" ;; \
      ruby) VARIANT_PACKAGES="$GETTEXT_PACKAGES $RUBY_PACKAGES" ;; \
      rust) VARIANT_PACKAGES="$GETTEXT_PACKAGES $RUST_PACKAGES" ;; \
      web) VARIANT_PACKAGES="$GETTEXT_PACKAGES $NODE_PACKAGES" ;; \
      *) echo "Unknown Agama variant: $AGAMA_VARIANT" >&2; exit 1 ;; \
    esac \
    && zypper --non-interactive --gpg-auto-import-keys install --no-recommends --allow-downgrade \
      $BASE_PACKAGES $AI_PACKAGES $VARIANT_PACKAGES \
    && zypper clean -a

# Ruby language server
RUN if [ "$AGAMA_VARIANT" = "ruby" ] || [ "$AGAMA_VARIANT" = "all-in-one" ]; then \
      gem install --no-format-exec ruby-lsp; \
    fi

# mDNS host name resolution via the host Avahi daemon
ARG MDNS="${templateOption:mdns}"

RUN if [ "$MDNS" = "true" ]; then \
      zypper --non-interactive --gpg-auto-import-keys install --no-recommends nss-mdns \
      && zypper clean -a; \
    fi

# Install Google Cloud CLI for accessing Claude via Vertex AI
ARG ANTHROPIC_CLAUDE="${templateOption:anthropicClaude}"

# Temporarily disable the distribution repos to have faster refresh
# hadolint ignore=SC1091,SC2086
RUN if [ "$ANTHROPIC_CLAUDE" = "true" ]; then \
      . /etc/os-release \
      && if [ "$ID" = "opensuse-tumbleweed" ]; then \
        REPOS="repo-oss repo-update"; \
      else \
        REPOS="openSUSE:repo-oss"; \
      fi \
      && zypper modifyrepo --disable $REPOS \
      && zypper ar -f "https://packages.cloud.google.com/yum/repos/cloud-sdk-el10-$(uname -m)" google-cloud-rhel10 \
      && zypper --non-interactive --gpg-auto-import-keys install --no-recommends google-cloud-cli \
      && zypper clean -a \
      && zypper modifyrepo --enable $REPOS; \
    fi

# additional packages, add your own here
# (declared after the common layer, changing it does not invalidate that layer)
ARG DEVEL_PACKAGES=""

RUN if [ -n "$DEVEL_PACKAGES" ]; then \
      zypper --non-interactive --gpg-auto-import-keys install --no-recommends --allow-downgrade \
        $DEVEL_PACKAGES \
      && zypper clean -a; \
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
