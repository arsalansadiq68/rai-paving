/*
RECOMMENDED SECURITY FIX — NOT APPLIED.

Run this in the Supabase SQL editor of the existing production project
(cnnezpkarmdzohechhlt) only after you approve it.

Problem: every existing "Admin can ..." policy is `TO authenticated USING (true)`.
Any account that can sign in to this Supabase project (including one created via
public sign-up, if email sign-ups are open) can read all quote requests and
customer contact details, read the private quote-photos bucket, and edit or
delete gallery rows and gallery images.

Fix: same tables, same buckets, same columns, same data. Only the definition of
"admin" is tightened, via an allowlist table plus a SECURITY DEFINER helper.
Nothing is reset, moved or deleted.

BEFORE RUNNING: confirm the admin login email below is correct.
*/

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

-- Seed the existing admin account.
INSERT INTO public.admin_users (user_id)
SELECT id FROM auth.users WHERE email = 'nasrullahrai34@gmail.com'
ON CONFLICT (user_id) DO NOTHING;

CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
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

-- quote_requests --------------------------------------------------------
-- Public INSERT policy intentionally left unchanged: the quote form needs it.
DROP POLICY IF EXISTS "Admin can view quote requests" ON public.quote_requests;
CREATE POLICY "Admin can view quote requests" ON public.quote_requests
  FOR SELECT TO authenticated USING (public.is_admin());
DROP POLICY IF EXISTS "Admin can update quote requests" ON public.quote_requests;
CREATE POLICY "Admin can update quote requests" ON public.quote_requests
  FOR UPDATE TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "Admin can delete quote requests" ON public.quote_requests;
CREATE POLICY "Admin can delete quote requests" ON public.quote_requests
  FOR DELETE TO authenticated USING (public.is_admin());

-- quote_request_photos --------------------------------------------------
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
   The site never needs public sign-up; only the admin logs in.
2. Confirm the admin account has a strong password / MFA.
*/
