# Soul Medicine

**Currently in active development**

## Dev

### Prerequisites

- **Ruby 2.5.3**
- **NodeJS 8+**
- **Yarn 1.10+**
- **PostgreSQL 10.5**
  - You can use Docker Compose to run one locally: `docker-compose up -d`.
  - Alternatively, you can run your own, and override env vars in a `.env.local` file (see `.env` for the variables to override).

### Initial Setup

Once you have the prerequisites above, and have the codebase cloned, you can run:

```bash
bin/setup
```

… to get everything set up.

Then you're ready to use the usual `rails` commands (like `rails serve`) to run / work with the app.
