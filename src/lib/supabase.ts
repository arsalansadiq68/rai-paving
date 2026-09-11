import { createClient } from '@supabase/supabase-js';

// Existing production Supabase project (unchanged from the imported app).
// Both values are publishable client-side credentials.
const FALLBACK_URL = 'https://cnnezpkarmdzohechhlt.supabase.co';
const FALLBACK_ANON_KEY =
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNubmV6cGthcm1kem9oZWNoaGx0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODkxMjEzNzksImV4cCI6MjEwNDY5NzM3OX0.GVMZnUgFopk8Y7PUfD-cFY8sLQQcDJ4SpuQtjBt8W28';

const supabaseUrl = (import.meta.env['VITE_SUPABASE_URL'] as string | undefined) ?? FALLBACK_URL;
const supabaseAnonKey =
  (import.meta.env['VITE_SUPABASE_ANON_KEY'] as string | undefined) ?? FALLBACK_ANON_KEY;

export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
  auth: {
    persistSession: typeof window !== 'undefined',
    autoRefreshToken: typeof window !== 'undefined',
  },
});
