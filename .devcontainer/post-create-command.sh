#!/bin/bash

set -e

# Create .env.local with defaults if it doesn't already exist.
if [ ! -f .env.local ]
then
  touch .env.local

  cat <<EOT >> .env.local
# Only necessary for devcontainers
REDIS_URL="redis://redis-sidekiq:6379"
REDIS_CACHE_URL="redis://redis-cache:6380"

STORYBLOK_TOKEN="..."

# Firebase Authentication
FIREBASE_PROJECT_ID="..."
FIREBASE_API_KEY="..."

# Rollbar (only if you want to test errors are being reported locally)
# SERVER_ROLLBAR_ACCESS_TOKEN="..." # Identified on rollbar as post_server_item
# CLIENT_ROLLBAR_ACCESS_TOKEN="..." # Identified on rollbar as post_client_item
# ROLLBAR_ENV=dev

GOOGLE_ANALYTICS_ID="..."

EOT
fi

gem update bundler
rbenv rehash

npm update -g npm
npm install -g yarn

./bin/setup
