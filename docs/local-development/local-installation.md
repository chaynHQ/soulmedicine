# Installing dependencies on your own machine

## Prerequisites

- Ruby - see `.ruby-version` for the version required
- NodeJS - see `package.json` for the version required
  - with Yarn 1.10+
- shared-mime-info a dependency of [mimemagic](https://github.com/mimemagicrb/mimemagic) ```brew install shared-mime-info```

## Dependent services

[Docker Compose](https://docs.docker.com/compose/overview/) is the recommended way to run all _dependent_ services locally, like the PostgreSQL db and Redis instances. Environment variables in `.env` have been set up to communicate with these services.

After installing Docker Compose (e.g. using [Docker for Mac](https://docs.docker.com/docker-for-mac/install/)) you can…

Start all services in the background:

```shell
docker-compose up -d
```

Shut down all these services:

```shell
docker-compose down
```

## Initial Setup

Once you have the prerequisites above, the codebase cloned and the dependent services running locally…

Set up **local** env vars in a new `.env.local` file – see the section at the bottom of the `.env` file for the variables you may need to set.

You will need to ensure your local database has the role "sm" set up with permissions to create databases.

Then run the following to set everything up:

```bash
bin/setup
```

## Running the app locally

Start up the Rails server with:

```shell
bin/rails server
```

This serves the app, including all frontend assets (bundled using [Webpack](https://webpack.js.org/)).

You can **also** run `bin/webpack-dev-server` in a separate terminal shell if you want live reloading (in your browser) of CSS and JavaScript changes (note: only changes made within the `app/webpack` folder will cause live reloads).

(optionally) Start up the background processor with:

```shell
bundle exec sidekiq -c 1
```
