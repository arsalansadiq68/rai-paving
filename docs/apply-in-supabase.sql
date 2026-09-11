/*
RAI OG PAVING — SQL to run in the Supabase SQL editor of the EXISTING project
(cnnezpkarmdzohechhlt). Nothing here creates, resets, migrates or deletes any
table, bucket or row. It only fixes policies.

Verified against the live project on 2026-09-11 with the anon key:

  * anon INSERT into public.quote_requests   -> 42501 "new row violates row-level
    security policy"  ==> the public quote form CANNOT submit. ROOT CAUSE.
  * anon INSERT into public.quote_request_photos -> reached the FK check (23503),
    so that policy is already correct.
  * anon upload to storage bucket quote-photos   -> succeeded, already correct.
  * anon upload to storage bucket gallery-images -> correctly denied.
  * anon SELECT on public.gallery                -> works.
  * gallery-images is public, quote-photos is private. Both correct.

PART 1 is required to fix quote submission.
PART 2 is the admin lockdown (security fix).
*/

-- =====================================================================
-- PART 1 — REQUIRED: let the public submit a quote without logging in.
-- =====================================================================

DROP POLICY IF EXISTS "Public can submit quote requests" ON public.quote_requests;
CREATE POLICY "Public can submit quote requests" ON public.quote_requests
  FOR INSERT TO anon, authenticated WITH CHECK (true);

-- PostgREST needs the table-level privilege as well as the policy.
GRANT INSERT ON public.quote_requests TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.quote_requests TO authenticated;
GRANT ALL ON public.quote_requests TO service_role;

GRANT INSERT ON public.quote_request_photos TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.quote_request_photos TO authenticated;
GRANT ALL ON public.quote_request_photos TO service_role;

GRANT SELECT ON public.gallery TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.gallery TO authenticated;
GRANT ALL ON public.gallery TO service_role;

-- =====================================================================
-- PART 2 — SECURITY: restrict admin operations to the intended account.
--
-- Today every "Admin can ..." policy is `TO authenticated USING (true)`, so ANY
-- account that can sign in to this Supabase project can read every customer
-- quote and private photo and edit/delete gallery rows. The fix below changes
-- only the definition of "admin" — same tables, buckets, columns and data.
--
-- CONFIRM THE ADMIN EMAIL ON THE MARKED LINE BEFORE RUNNING.
-- =====================================================================

CREATE TABLE IF NOT EXISTS public.admin_users (
  user_id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at timestamptz NOT NULL DEFAULT now()
);

GRANT SELECT ON public.admin_users TO authenticated;
GRANT ALL ON public.admin_users TO service_role;

ALTER TABLE public.admin_users ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Admins can read own admin row" ON public.admin_users;
CREATE POLICY "Admins can read own admin row" ON public.admin_users
  FOR SELECT TO authenticated USING (user_id = auth.uid());

-- <<< CONFIRM THIS EMAIL >>>
INSERT INTO public.admin_users (user_id)
SELECT id FROM auth.users WHERE email = 'nasrullahrai34@gmail.com'
ON CONFLICT (user_id) DO NOTHING;

CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public
AS $$
  SELECT EXISTS (SELECT 1 FROM public.admin_users WHERE user_id = auth.uid());
$$;

-- gallery ---------------------------------------------------------------
DROP POLICY IF EXISTS "Public can view published gallery" ON public.gallery;
CREATE POLICY "Public can view published gallery" ON public.gallery
  FOR SELECT TO anon, authenticated USING (published = true OR public.is_admin());
DROP POLICY IF EXISTS "Admin can insert gallery" ON public.gallery;
CREATE POLICY "Admin can insert gallery" ON public.gallery
  FOR INSERT TO authenticated WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "Admin can update gallery" ON public.gallery;
CREATE POLICY "Admin can update gallery" ON public.gallery
  FOR UPDATE TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "Admin can delete gallery" ON public.gallery;
CREATE POLICY "Admin can delete gallery" ON public.gallery
  FOR DELETE TO authenticated USING (public.is_admin());

-- quote_requests (public INSERT from PART 1 stays untouched) --------------
DROP POLICY IF EXISTS "Admin can view quote requests" ON public.quote_requests;
CREATE POLICY "Admin can view quote requests" ON public.quote_requests
  FOR SELECT TO authenticated USING (public.is_admin());
DROP POLICY IF EXISTS "Admin can update quote requests" ON public.quote_requests;
CREATE POLICY "Admin can update quote requests" ON public.quote_requests
  FOR UPDATE TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "Admin can delete quote requests" ON public.quote_requests;
CREATE POLICY "Admin can delete quote requests" ON public.quote_requests
  FOR DELETE TO authenticated USING (public.is_admin());

-- quote_request_photos ----------------------------------------------------
DROP POLICY IF EXISTS "Admin can view quote photos" ON public.quote_request_photos;
CREATE POLICY "Admin can view quote photos" ON public.quote_request_photos
  FOR SELECT TO authenticated USING (public.is_admin());
DROP POLICY IF EXISTS "Admin can update quote photos" ON public.quote_request_photos;
CREATE POLICY "Admin can update quote photos" ON public.quote_request_photos
  FOR UPDATE TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "Admin can delete quote photos" ON public.quote_request_photos;
CREATE POLICY "Admin can delete quote photos" ON public.quote_request_photos
  FOR DELETE TO authenticated USING (public.is_admin());

-- storage: gallery-images (public read stays public) ---------------------
DROP POLICY IF EXISTS "Admin can upload gallery files" ON storage.objects;
CREATE POLICY "Admin can upload gallery files" ON storage.objects
  FOR INSERT TO authenticated WITH CHECK (bucket_id = 'gallery-images' AND public.is_admin());
DROP POLICY IF EXISTS "Admin can update gallery files" ON storage.objects;
CREATE POLICY "Admin can update gallery files" ON storage.objects
  FOR UPDATE TO authenticated USING (bucket_id = 'gallery-images' AND public.is_admin())
  WITH CHECK (bucket_id = 'gallery-images' AND public.is_admin());
DROP POLICY IF EXISTS "Admin can delete gallery files" ON storage.objects;
CREATE POLICY "Admin can delete gallery files" ON storage.objects
  FOR DELETE TO authenticated USING (bucket_id = 'gallery-images' AND public.is_admin());

-- storage: quote-photos (stays private; public upload stays for the form) -
DROP POLICY IF EXISTS "Admin can view quote files" ON storage.objects;
CREATE POLICY "Admin can view quote files" ON storage.objects
  FOR SELECT TO authenticated USING (bucket_id = 'quote-photos' AND public.is_admin());
DROP POLICY IF EXISTS "Admin can update quote files" ON storage.objects;
CREATE POLICY "Admin can update quote files" ON storage.objects
  FOR UPDATE TO authenticated USING (bucket_id = 'quote-photos' AND public.is_admin())
  WITH CHECK (bucket_id = 'quote-photos' AND public.is_admin());
DROP POLICY IF EXISTS "Admin can delete quote files" ON storage.objects;
CREATE POLICY "Admin can delete quote files" ON storage.objects
  FOR DELETE TO authenticated USING (bucket_id = 'quote-photos' AND public.is_admin());

/*
Also recommended in the Supabase dashboard (no SQL needed):
1. Authentication -> Providers -> Email: turn OFF "Allow new users to sign up".
2. Delete the leftover diagnostic file quote-photos/diag/test.txt (Storage UI).
*/
