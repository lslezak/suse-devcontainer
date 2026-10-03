# The openSUSE base image, "leap:16.0" or "tumbleweed"
# the tag is part of the template option value
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

# AI code assisting related packages, the agents usually run Bash or Python code
# snippets, the AI specific packages are installed by the features referenced
# in the devcontainer.json file
ARG AI_PACKAGES="python3 python3-pip"

# translations support
ARG GETTEXT_PACKAGES="gettext-tools"

# mDNS hostname resolution via the host Avahi daemon
ARG MDNS_PACKAGES="nss-mdns"

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

# Install all packages at once, the package lists are split intentionally
# hadolint ignore=SC2086
RUN case "$AGAMA_VARIANT" in \
      all-in-one) VARIANT_PACKAGES="$GETTEXT_PACKAGES $MDNS_PACKAGES $NODE_PACKAGES $RUBY_PACKAGES $RUST_PACKAGES $KIWI_PACKAGES" ;; \
      base) VARIANT_PACKAGES="$GETTEXT_PACKAGES" ;; \
      kiwi) VARIANT_PACKAGES="$KIWI_PACKAGES" ;; \
      ruby) VARIANT_PACKAGES="$GETTEXT_PACKAGES $MDNS_PACKAGES $RUBY_PACKAGES" ;; \
      rust) VARIANT_PACKAGES="$GETTEXT_PACKAGES $MDNS_PACKAGES $RUST_PACKAGES" ;; \
      web) VARIANT_PACKAGES="$GETTEXT_PACKAGES $MDNS_PACKAGES $NODE_PACKAGES" ;; \
      *) echo "Unknown Agama variant: $AGAMA_VARIANT" >&2; exit 1 ;; \
    esac \
    && zypper --non-interactive --gpg-auto-import-keys install --no-recommends --allow-downgrade \
      $BASE_PACKAGES $AI_PACKAGES $VARIANT_PACKAGES \
    && zypper clean -a

# additional packages, add your own here
# (declared after the common layer, changing it does not invalidate that layer)
ARG DEVEL_PACKAGES=""

RUN if [ -n "$DEVEL_PACKAGES" ]; then \
      zypper --non-interactive --gpg-auto-import-keys install --no-recommends --allow-downgrade \
        $DEVEL_PACKAGES \
      && zypper clean -a; \
    fi

# Ruby language server
RUN if [ "$AGAMA_VARIANT" = "ruby" ] || [ "$AGAMA_VARIANT" = "all-in-one" ]; then \
      gem install --no-format-exec ruby-lsp; \
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
