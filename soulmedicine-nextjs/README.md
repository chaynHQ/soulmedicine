# Soul Medicine - Next.js Migration

This is the Next.js version of Soul Medicine, migrated from Vue.js and Ruby on Rails. A platform providing healing pathways and personalized content for mental health and recovery journeys.

## Architecture

- **Frontend**: Next.js 15 with TypeScript and Material-UI
- **Backend**: Next.js API routes
- **Database**: PostgreSQL with UUID primary keys
- **Authentication**: Firebase Auth
- **CMS**: Storyblok
- **Caching**: Redis
- **Deployment**: Vercel (recommended)

## Features Migrated

### Vue Components → React Components
- ✅ Authentication (sign_in.vue → SignIn.tsx)
- ✅ User Profile (profile.vue → Profile.tsx)
- ✅ Cookie Law Banner (cookie_law.vue → CookieBanner.tsx)
- ✅ Leave Site Emergency Exit (leave_site.vue → LeaveSite.tsx)

### Rails Backend → Next.js API Routes
- ✅ Authentication endpoints (/api/auth/*)
- 🔄 Course management (/api/courses/*)
- 🔄 Lesson management (/api/lessons/*)
- 🔄 Subscription management (/api/subscriptions/*)
- 🔄 User reactions (/api/reactions/*)
- 🔄 Voting system (/api/votes/*)
- 🔄 Profile management (/api/profile/*)

### Database Models
- ✅ Core database connection and querying
- ✅ User model structure
- 🔄 Subscription model with timezone handling
- 🔄 Course and lesson models (CMS integration)
- 🔄 Reaction and voting models
- 🔄 Progress tracking

## Getting Started

### Prerequisites
- Node.js 18+ 
- PostgreSQL database
- Redis instance
- Firebase project
- Storyblok account

### Installation

1. Clone the repository and navigate to the Next.js project:
```bash
cd soulmedicine-nextjs
npm install
```

2. Set up environment variables:
```bash
cp .env.example .env.local
# Edit .env.local with your configuration
```

3. Set up the database:
```bash
# Run the PostgreSQL migrations from the original Rails app
# or recreate the schema using the database structure
```

4. Start the development server:
```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) to see the application.

## Environment Variables

### Required Environment Variables

```env
# Database
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_USER=your_db_user
DATABASE_PASSWORD=your_db_password
DATABASE_NAME=soulmedicine

# Firebase (get from Firebase console)
NEXT_PUBLIC_FIREBASE_API_KEY=your_firebase_api_key
NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=your_project.firebaseapp.com
NEXT_PUBLIC_FIREBASE_PROJECT_ID=your_project_id
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_CLIENT_EMAIL=your_service_account_email
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n"

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=optional_password

# Storyblok CMS
STORYBLOK_API_TOKEN=your_storyblok_token
```

## Migration Status

### ✅ Completed
- Next.js project setup with TypeScript
- Material-UI theme and styling system
- Firebase authentication integration
- Database connection and models setup
- Basic React components for core features
- Project structure and configuration

### 🔄 In Progress
- API route implementations
- CMS integration with Storyblok
- Email subscription system
- Course and lesson management

### 📋 To Do
- Multi-language support (i18n)
- Email templates and delivery
- Background job processing
- Testing suite
- Deployment configuration
- Performance optimization

## Key Differences from Rails Version

1. **Client-side routing**: Uses Next.js App Router instead of Rails routes
2. **Authentication**: Firebase client SDK + server-side verification
3. **Styling**: Material-UI instead of Bootstrap + SCSS
4. **State management**: React hooks instead of Vue reactive data
5. **API design**: RESTful Next.js API routes instead of Rails controllers
6. **Background jobs**: Will need external solution (Vercel Cron, etc.) instead of Sidekiq

## Development Scripts

```bash
# Development server with Turbopack
npm run dev

# Production build
npm run build
npm run start

# Linting
npm run lint
```

## Deployment

This project is designed to deploy on Vercel, but can be deployed to any Node.js hosting platform.

### Vercel Deployment
1. Connect your GitHub repository to Vercel
2. Set environment variables in Vercel dashboard
3. Deploy automatically on push to main branch

### Database Setup
The application expects a PostgreSQL database with the same schema as the Rails version. You can either:
1. Import data from the existing Rails database
2. Run Rails migrations to create the schema
3. Use the provided SQL schema file (when available)

## Contributing

This is a migration project converting the Ruby on Rails + Vue.js Soul Medicine application to Next.js. The goal is to maintain feature parity while modernizing the tech stack.

Key principles:
- Maintain the same user experience
- Preserve all data and functionality  
- Improve performance and developer experience
- Keep the same database structure for easy migration
