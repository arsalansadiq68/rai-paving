import { createFileRoute } from "@tanstack/react-router";
import { PublicSite } from "@/app/App";

const jsonLd = JSON.stringify({
  "@context": "https://schema.org",
  "@type": "LocalBusiness",
  name: "RAI OG PAVING",
  description: "Professional paving services across Adelaide and surrounding suburbs.",
  address: {
    "@type": "PostalAddress",
    addressLocality: "Adelaide",
    addressRegion: "SA",
    addressCountry: "AU",
  },
  telephone: "+61423575131",
  email: "nasrullahrai34@gmail.com",
});

const title = "RAI OG PAVING | Professional Paving Services in Adelaide";
const description =
  "Professional paving services across Adelaide. Residential paving, driveways, concrete paving, paver installation, pathways and paving repairs.";

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
