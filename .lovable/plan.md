# Update business content and gallery photos

## Scope
- Keep the existing layout, styling, animations, navigation, buttons, contact links, quote form, admin tools, routes, and Supabase connection unchanged.
- Change the homepage business title and use the supplied description verbatim in the opening and About sections.
- Update matching homepage and social metadata to the new business title and supplied description, without adding unrelated SEO changes.

## Gallery replacement
- Prepare the five uploaded originals with these records:
  1. `5.jpg` — Garden Pathway — Garden Pathways
  2. `4.jpg` — Driveway Paving — Driveways
  3. `3.jpg` — Patio & Entrance Pathway — Patios & Courtyards
  4. `2.jpg` — Paver Restoration — Paver Restoration
  5. `1.jpg` — Paver Installation — Paver Restoration
- Do not hardcode the photos or store them outside the existing gallery system.
- Because live admin access is not available in this step, do not change production gallery rows or storage objects yet. The actual replacement remains pending an authenticated `/admin` session.

## Verification
- Confirm the homepage renders the exact new title and supplied wording in the selected sections.
- Confirm Call, WhatsApp, quote controls, and `/admin` behavior remain unchanged and `/admin` is absent from public navigation.
- Check desktop and mobile rendering without visual redesign.
- Validate the project after the content edits.
- Once admin access is provided, upload the five originals through the existing admin flow, replace the old gallery records without duplicates, and verify storage URLs, visible cards after refresh, and every lightbox item on desktop and mobile.

## Technical details
- Edit only the existing public page component and homepage metadata files needed for the requested wording.
- Do not modify the database schema, storage configuration, RLS policies, or Supabase client configuration.
