# Soul Medicine

## Currently in development

## Development

[![Build Status](https://travis-ci.org/chaynHQ/soulmedicine.svg?branch=development)](https://travis-ci.org/chaynHQ/soulmedicine)
[![Heroku Build](https://heroku-badge.herokuapp.com/?app=project-sm&style=flat)](https://project-sm.herokuapp.com/)
[![Open Source Love](https://badges.frapsoft.com/os/v2/open-source.png?v=103)](https://github.com/chaynHQ/soulmedicine)
[![MIT Licence](https://badges.frapsoft.com/os/mit/mit.png?v=103)](https://opensource.org/licenses/mit-license.php)

* Ruby version - `2.5.2`
* Rails version - `5.2`
* System dependencies
  * PostgreSQL
  * Rails 5.2
* Configuration
  * Run `cp .env.sample .env.development` to create the local env file
  * Populate the environment variables
  * Run `rails secret` to generate an APP_SECRET
* Database creation
  * Ensure that PG is running `pg_ctl start`
  * Run `rails db:setup`
<!-- TODO: Add more details
* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ... -->

![](docs/erd-diagram.png)
