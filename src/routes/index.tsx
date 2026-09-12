import { createFileRoute } from "@tanstack/react-router";
import { PublicSite } from "@/app/App";

const jsonLd = JSON.stringify({
  "@context": "https://schema.org",
  "@type": "LocalBusiness",
  name: "Adelaide Paving | Patios, Pathways & Paver Restoration",
  description: "We create neat new paving and restore tired, uneven pavers across Adelaide.\n\nWhat we do:\n\nNew Patios & Courtyards, Garden Pathways, Driveway Relay & Tidy-ups, Lifting & Re-levelling, Patch Repairs.\n\nFast, same-week service with a clean finish and competitive pricing.\n\nCall today for a free quote.",
  address: {
    "@type": "PostalAddress",
    addressLocality: "Adelaide",
    addressRegion: "SA",
    addressCountry: "AU",
  },
  telephone: "+61423575131",
  email: "nasrullahrai34@gmail.com",
});

const title = "Adelaide Paving | Patios, Pathways & Paver Restoration";
const description =
  "We create neat new paving and restore tired, uneven pavers across Adelaide.\n\nWhat we do:\n\nNew Patios & Courtyards, Garden Pathways, Driveway Relay & Tidy-ups, Lifting & Re-levelling, Patch Repairs.\n\nFast, same-week service with a clean finish and competitive pricing.\n\nCall today for a free quote.";

export const Route = createFileRoute("/")({
  head: () => ({
    meta: [
      { title },
      { name: "description", content: description },
      {
        name: "keywords",
        content:
          "Paving Services Adelaide, Adelaide Paving, Driveway Paving Adelaide, Residential Paving Adelaide, Concrete Paving Adelaide, Paver Installation Adelaide, Paving Contractors Adelaide, Paving Repairs Adelaide",
      },
      { property: "og:title", content: title },
      { property: "og:description", content: description },
      { property: "og:type", content: "website" },
      { name: "twitter:card", content: "summary_large_image" },
    ],
    scripts: [{ type: "application/ld+json", children: jsonLd }],
  }),
  component: PublicSite,
});
