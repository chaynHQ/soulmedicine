ARG RUBY_VERSION

FROM mcr.microsoft.com/devcontainers/ruby:${RUBY_VERSION}

ARG NODE_VERSION
RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"

RUN apt-get update && \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get upgrade -y && \
  apt-get install -y --no-install-recommends \
  libpq-dev \
  python2 \
  shared-mime-info \
  tmux && \
  apt-get autoremove -y

# Install Overmind to run multiple processes at once.
RUN curl --fail --location --output /usr/bin/overmind.gz "https://github.com/DarthSim/overmind/releases/download/v2.4.0/overmind-v2.4.0-linux-$(dpkg --print-architecture).gz" && \
  curl --fail --location --output /tmp/overmind.gz.sha256sum "https://github.com/DarthSim/overmind/releases/download/v2.4.0/overmind-v2.4.0-linux-$(dpkg --print-architecture).gz.sha256sum" && \
  echo $(cat /tmp/overmind.gz.sha256sum) /usr/bin/overmind.gz | sha256sum --check --status && \
  gunzip /usr/bin/overmind.gz && \
  chmod +x /usr/bin/overmind

RUN su vscode -c "gem install bundler:2.4.18"
RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g yarn" 2>&1

ENV OVERMIND_SOCKET=/tmp/.overmind.sock

# https://github.com/devcontainers/templates/blob/4653d4cd09e27c57b3a03969e7d9cb8de313df19/src/ruby-rails-postgres/.devcontainer/Dockerfile#L6C1-L8C89
# Default value to allow debug server to serve content over GitHub Codespace's port forwarding service
# The value is a comma-separated list of allowed domains
ENV RAILS_DEVELOPMENT_HOSTS=".githubpreview.dev,.preview.app.github.dev,.app.github.dev"
