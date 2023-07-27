FROM mcr.microsoft.com/devcontainers/base:jammy

ENV DEBIAN_FRONTEND noninteractive
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# disable installing recommended packages to save space
RUN echo "APT::Install-Recommends \"false\";" > /etc/apt/apt.conf

RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y \
  build-essential \
  libffi-dev \
  libjemalloc-dev \
  libpq-dev \
  libreadline-dev \
  libssl-dev \
  libxml2-dev \
  libxslt-dev \
  libyaml-dev \
  python2 \
  shared-mime-info \
  tmux \
  zlib1g-dev && \
  apt-get autoremove -y

# Install Overmind to run multiple processes at once.
RUN curl --fail --location --output /usr/bin/overmind.gz "https://github.com/DarthSim/overmind/releases/download/v2.4.0/overmind-v2.4.0-linux-$(dpkg --print-architecture).gz" && \
  curl --fail --location --output /tmp/overmind.gz.sha256sum "https://github.com/DarthSim/overmind/releases/download/v2.4.0/overmind-v2.4.0-linux-$(dpkg --print-architecture).gz.sha256sum" && \
  echo $(cat /tmp/overmind.gz.sha256sum) /usr/bin/overmind.gz | sha256sum --check --status && \
  gunzip /usr/bin/overmind.gz && \
  chmod +x /usr/bin/overmind

# Run as the target user
# Uses the username created by the VSCode devcontainer Ubuntu base image
USER vscode
ENV USER=vscode

COPY ../.ruby-version /tmp/.ruby-version

RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv
RUN git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
RUN ~/.rbenv/bin/rbenv install $(cat /tmp/.ruby-version)

ENV OVERMIND_SOCKET=/tmp/.overmind.sock

# https://github.com/devcontainers/templates/blob/4653d4cd09e27c57b3a03969e7d9cb8de313df19/src/ruby-rails-postgres/.devcontainer/Dockerfile#L6C1-L8C89
# Default value to allow debug server to serve content over GitHub Codespace's port forwarding service
# The value is a comma-separated list of allowed domains
ENV RAILS_DEVELOPMENT_HOSTS=".githubpreview.dev,.preview.app.github.dev,.app.github.dev"

# https://github.com/webpack/webpack/issues/14532#issuecomment-947012063
ENV NODE_OPTIONS="--openssl-legacy-provider"
