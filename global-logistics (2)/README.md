# Global Logistics Website

A complete, production-ready logistics tracking website built for Vercel deployment.

## Features

- **Authentication**: Email/password signup and login via Supabase Auth
- **Role-based Access**: User and Admin roles with protected routes
- **Live Tracking**: Real-time package tracking with animated Leaflet maps
- **Admin Dashboard**: Create, edit, delete tracking codes and manage users
- **AI Chat Assistant**: Groq-powered logistics chatbot via Vercel serverless function
- **Responsive Design**: Mobile-first with Tailwind CSS
- **Multiple Pages**: Home, About, Contact, Tracking, Admin, Returns, Policy

## Project Structure (Vercel-Ready)

```
global-logistics/
├── api/
│   ├── chat.js           # Vercel serverless: Groq API proxy
│   └── config.js         # Vercel serverless: Supabase config
├── index.html            # Home page
├── about.html            # About page
├── contact.html          # Contact page
├── login.html            # Login page
├── signup.html           # Sign up page
├── tracking.html         # Live tracking page
├── admin.html            # Admin dashboard
├── returns.html          # Returns policy
├── policy.html           # Terms & privacy
├── main.js               # Shared JavaScript
├── .env                  # Environment variables (local dev)
├── package.json
├── schema.sql            # Supabase database schema
├── server.js             # Express server (local dev only)
├── vercel.json           # Vercel routing config
└── README.md
```

## Vercel Dashboard Settings

| Setting | Value |
|---|---|
| **Framework Preset** | `Other` |
| **Build Command** | *(leave empty)* |
| **Output Directory** | *(leave empty)* |
| **Install Command** | `npm install` |

## Environment Variables (Vercel)

Go to **Vercel Dashboard → Project Settings → Environment Variables** and add:

| Name | Value |
|---|---|
| `SUPABASE_URL` | `https://your-project.supabase.co` |
| `SUPABASE_ANON_KEY` | `your-anon-key` |
| `GROQ_API_KEY` | `your-groq-api-key` |

## Setup Instructions

### 1. Supabase Setup

1. Create a new project at [supabase.com](https://supabase.com)
2. Go to the SQL Editor and run the contents of `schema.sql`
3. Note your Project URL and Anon Key from Settings > API

### 2. Groq API Setup

1. Sign up at [groq.com](https://groq.com) and get a free API key
2. The free tier includes access to `llama3-8b-8192`

### 3. Deploy to Vercel

```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
vercel
```

Or connect your GitHub repo to Vercel for auto-deploys.

### 4. Local Development

```bash
# Using the Express server (includes config injection)
npm install express dotenv
npm start

# Or using Vercel CLI
vercel dev
```


## Technologies

- **Frontend**: HTML5, Tailwind CSS (CDN), Font Awesome, Leaflet.js
- **Backend**: Vercel Serverless Functions (Node.js)
- **Database**: Supabase (PostgreSQL + Auth + RLS)
- **AI**: Groq API (llama3-8b-8192)
