/*
# Create RAI OG PAVING website data model

1. New Tables
- `gallery`: public gallery metadata with title, category, image location, publication state, and timestamps.
- `quote_requests`: customer quote submissions and their workflow status.
- `quote_request_photos`: private photo references attached to quote requests.

2. Storage
- Creates public `gallery-images` bucket for published gallery media.
- Creates private `quote-photos` bucket for customer uploads.

3. Security
- Enables row-level security on all new tables.
- Public visitors can see published gallery records and create quote requests/photos.
- Authenticated admin users can manage gallery records, read and update quote requests, and access private quote photos.
- Storage policies keep quote photos private and restrict gallery writes to authenticated users.

4. Important notes
- No profiles, roles, or notification tables are created.
- The single authorized admin is controlled by Supabase Auth; this schema does not expose credentials or create admin accounts.
*/

CREATE TABLE IF NOT EXISTS public.gallery (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  category text NOT NULL,
  storage_path text,
  image_url text,
  published boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.quote_requests (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  full_name text NOT NULL,
  phone text NOT NULL,
  email text NOT NULL,
  suburb text NOT NULL,
  work_type text NOT NULL,
  message text,
  status text NOT NULL DEFAULT 'New' CHECK (status IN ('New', 'Contacted', 'Quoted', 'Completed', 'Closed')),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.quote_request_photos (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  quote_request_id uuid NOT NULL REFERENCES public.quote_requests(id) ON DELETE CASCADE,
  storage_path text NOT NULL,
  file_name text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS gallery_published_created_idx ON public.gallery (published, created_at DESC);
CREATE INDEX IF NOT EXISTS quote_requests_status_created_idx ON public.quote_requests (status, created_at DESC);
CREATE INDEX IF NOT EXISTS quote_request_photos_quote_id_idx ON public.quote_request_photos (quote_request_id);

ALTER TABLE public.gallery ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quote_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quote_request_photos ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public can view published gallery" ON public.gallery;
CREATE POLICY "Public can view published gallery" ON public.gallery FOR SELECT TO anon, authenticated USING (published = true OR auth.role() = 'authenticated');
DROP POLICY IF EXISTS "Admin can insert gallery" ON public.gallery;
CREATE POLICY "Admin can insert gallery" ON public.gallery FOR INSERT TO authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "Admin can update gallery" ON public.gallery;
CREATE POLICY "Admin can update gallery" ON public.gallery FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "Admin can delete gallery" ON public.gallery;
CREATE POLICY "Admin can delete gallery" ON public.gallery FOR DELETE TO authenticated USING (true);

DROP POLICY IF EXISTS "Public can submit quote requests" ON public.quote_requests;
CREATE POLICY "Public can submit quote requests" ON public.quote_requests FOR INSERT TO anon, authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "Admin can view quote requests" ON public.quote_requests;
CREATE POLICY "Admin can view quote requests" ON public.quote_requests FOR SELECT TO authenticated USING (true);
DROP POLICY IF EXISTS "Admin can update quote requests" ON public.quote_requests;
CREATE POLICY "Admin can update quote requests" ON public.quote_requests FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "Admin can delete quote requests" ON public.quote_requests;
CREATE POLICY "Admin can delete quote requests" ON public.quote_requests FOR DELETE TO authenticated USING (true);

DROP POLICY IF EXISTS "Public can attach quote photos" ON public.quote_request_photos;
CREATE POLICY "Public can attach quote photos" ON public.quote_request_photos FOR INSERT TO anon, authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "Admin can view quote photos" ON public.quote_request_photos;
CREATE POLICY "Admin can view quote photos" ON public.quote_request_photos FOR SELECT TO authenticated USING (true);
DROP POLICY IF EXISTS "Admin can update quote photos" ON public.quote_request_photos;
CREATE POLICY "Admin can update quote photos" ON public.quote_request_photos FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "Admin can delete quote photos" ON public.quote_request_photos;
CREATE POLICY "Admin can delete quote photos" ON public.quote_request_photos FOR DELETE TO authenticated USING (true);

INSERT INTO storage.buckets (id, name, public) VALUES
  ('gallery-images', 'gallery-images', true),
  ('quote-photos', 'quote-photos', false)
ON CONFLICT (id) DO NOTHING;

DROP POLICY IF EXISTS "Public can view gallery files" ON storage.objects;
CREATE POLICY "Public can view gallery files" ON storage.objects FOR SELECT TO anon, authenticated USING (bucket_id = 'gallery-images');
DROP POLICY IF EXISTS "Admin can upload gallery files" ON storage.objects;
CREATE POLICY "Admin can upload gallery files" ON storage.objects FOR INSERT TO authenticated WITH CHECK (bucket_id = 'gallery-images');
DROP POLICY IF EXISTS "Admin can update gallery files" ON storage.objects;
CREATE POLICY "Admin can update gallery files" ON storage.objects FOR UPDATE TO authenticated USING (bucket_id = 'gallery-images') WITH CHECK (bucket_id = 'gallery-images');
DROP POLICY IF EXISTS "Admin can delete gallery files" ON storage.objects;
CREATE POLICY "Admin can delete gallery files" ON storage.objects FOR DELETE TO authenticated USING (bucket_id = 'gallery-images');

DROP POLICY IF EXISTS "Public can upload quote files" ON storage.objects;
CREATE POLICY "Public can upload quote files" ON storage.objects FOR INSERT TO anon, authenticated WITH CHECK (bucket_id = 'quote-photos');
DROP POLICY IF EXISTS "Admin can view quote files" ON storage.objects;
CREATE POLICY "Admin can view quote files" ON storage.objects FOR SELECT TO authenticated USING (bucket_id = 'quote-photos');
DROP POLICY IF EXISTS "Admin can update quote files" ON storage.objects;
CREATE POLICY "Admin can update quote files" ON storage.objects FOR UPDATE TO authenticated USING (bucket_id = 'quote-photos') WITH CHECK (bucket_id = 'quote-photos');
DROP POLICY IF EXISTS "Admin can delete quote files" ON storage.objects;
CREATE POLICY "Admin can delete quote files" ON storage.objects FOR DELETE TO authenticated USING (bucket_id = 'quote-photos');