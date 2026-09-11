export const WORK_TYPES = [
  'Residential Paving',
  'Driveway Paving',
  'Concrete Paving',
  'Paver Installation',
  'Pathways & Walkways',
  'Repairs & Re-paving',
  'Other Paving Work',
] as const;

export const QUOTE_STATUSES = ['New', 'Contacted', 'Quoted', 'Completed', 'Closed'] as const;

export type WorkType = (typeof WORK_TYPES)[number];
export type QuoteStatus = (typeof QUOTE_STATUSES)[number];

export interface GalleryItem {
  id: string;
  title: string;
  category: string;
  storage_path: string | null;
  image_url: string | null;
  published: boolean;
  created_at: string;
  updated_at: string;
}

export interface QuoteRequest {
  id: string;
  full_name: string;
  phone: string;
  email: string;
  suburb: string;
  work_type: string;
  message: string | null;
  status: QuoteStatus;
  created_at: string;
  updated_at: string;
  quote_request_photos?: QuotePhoto[];
}

export interface QuotePhoto {
  id: string;
  quote_request_id: string;
  storage_path: string;
  file_name: string;
  created_at: string;
}
