# Rai-og-paving

Import this existing Bolt project as an existing production project.

IMPORTANT:

Do NOT rebuild the application from scratch.

Do NOT create a new Supabase project.

Preserve the existing Supabase backend and existing data.

Preserve the existing database schema, tables, storage buckets, authentication flow, gallery functionality, quote-request functionality, quote-request photo uploads, admin functionality, styling, images, logo, responsive design, and existing routes.

Preserve the existing environment variable structure:
VITE_SUPABASE_URL
VITE_SUPABASE_ANON_KEY

Before making changes, inspect the existing project and understand how the frontend communicates with Supabase.

The existing Supabase schema includes:

gallery

quote_requests

quote_request_photos

The existing storage buckets include:

gallery-images

quote-photos

Do NOT create duplicate tables or duplicate storage buckets if they already exist.

Do NOT reset, replace, or migrate the existing production database unless explicitly required and confirmed first.

First get the imported project running exactly as it currently works.

Then verify:

Public website

Admin login

Admin gallery management

Gallery image uploads

Quote request submission

Quote-request photo uploads

Quote request management/status updates

Supabase storage access

Mobile responsiveness

Production build

IMPORTANT SECURITY AUDIT:
The existing RLS policies appear to grant admin operations to any authenticated Supabase user. Review the existing authorization model and recommend/fix this so administrative operations are restricted to the intended admin account/role, without breaking the existing application.

Do not change the database architecture unnecessarily.

After the initial import, report:

what was imported successfully

what Supabase connection is being used

which existing tables/buckets were detected

whether any functionality is broken

any security issues found

any changes you recommend before deployment

Do not make unrelated design changes during the import.

This project was built with [Lovable](https://lovable.dev).

**Live app**: https://rai-paving.lovable.app

## Build with Lovable

Continue developing this project in the [Lovable editor](https://lovable.dev/projects/ed345022-c031-41be-beb8-91b03301c9dc).

- **Ship faster**: describe what you want to build and Lovable handles the code.
- **Stay in sync**: every change made in Lovable is committed straight to this repository.
- **Full ownership**: this code is yours. Push to `main` on GitHub and your changes sync back into Lovable, ready for your next prompt.

## Development

Prefer working locally? You need Node.js and npm — [install with nvm](https://github.com/nvm-sh/nvm#installing-and-updating).

```sh
git clone <this-repository-url>
cd <repository-name>
npm i
npm run dev
```
