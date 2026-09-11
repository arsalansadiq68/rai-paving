import { createClient } from '@supabase/supabase-js';

// Original production Supabase backend for RAI OG PAVING
// (project ref: cnnezpkarmdzohechhlt — "arsalansadiq68's Project").
// These are publishable client-side credentials and are safe to ship in the
// browser bundle. They intentionally take precedence over the workspace
// integration env vars, which point at a different Supabase project.
const SUPABASE_URL = 'https://cnnezpkarmdzohechhlt.supabase.co';
const SUPABASE_ANON_KEY =
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNubmV6cGthcm1kem9oZWNoaGx0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODkxMjEzNzksImV4cCI6MjEwNDY5NzM3OX0.GVMZnUgFopk8Y7PUfD-cFY8sLQQcDJ4SpuQtjBt8W28';

export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY, {
  auth: {
    persistSession: typeof window !== 'undefined',
    autoRefreshToken: typeof window !== 'undefined',
  },
});
