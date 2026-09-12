# Update business content and Services photos

## Scope
- Keep the existing layout, styling, animations, navigation, buttons, contact links, quote form, admin tools, routes, Supabase connection, and Our Work/Gallery section unchanged.
- Change the homepage business title to `Adelaide Paving | Patios, Pathways & Paver Restoration`.
- Use the supplied description verbatim in the opening and About sections, preserving its paragraph structure.
- Update only the homepage and social title/description metadata required for the new wording.

## Services section
- Keep the existing card layout, styling, spacing, animation, typography, and responsive behavior.
- Use the five supplied originals as static site assets in the Services section, not as Gallery records:
  1. `5.jpg` — Garden Pathways — Garden Pathway
  2. `4.jpg` — Driveway Relay & Tidy-ups — Driveway Paving
  3. `3.jpg` — New Patios & Courtyards — Patio & Entrance Pathway
  4. `2.jpg` — Paver Restoration — Paver Restoration
  5. `1.jpg` — Lifting & Re-levelling / Patch Repairs — Paver Installation
- Align the existing service cards with the supplied five-service list without adding unrelated services or copy.
- Preserve each image’s aspect ratio using the existing card treatment, without stretching or excessive cropping.

## Protected areas
- Do not change Gallery fetching, records, storage objects, categories, cards, visibility behavior, ordering, or lightbox behavior.
- Do not change `/admin`, the quote form, Call or WhatsApp links, or public navigation.
- Do not change the Supabase client, project connection, database schema, storage configuration, or RLS policies.

## Verification
- Confirm the exact title and supplied description render in the requested homepage sections.
- Confirm all five supplied photos are visible in their Services cards on desktop and mobile.
- Confirm the existing Gallery records and images remain intact and its lightbox still opens.
- Confirm Call, WhatsApp, quote controls, and `/admin` remain unchanged, with no public admin link.
- Validate the project after the focused content and asset changes.

## Technical details
- Store the uploaded service photos through the project’s static asset flow and reference them only from the existing Services data.
- Edit only the public page component and homepage metadata files needed for this request.
- Make no production database or Supabase Storage changes.
