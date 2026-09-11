import { createFileRoute } from "@tanstack/react-router";
import { AdminApp } from "@/app/App";

export const Route = createFileRoute("/admin")({
  ssr: false,
  head: () => ({
    meta: [
      { title: "Admin | RAI OG PAVING" },
      { name: "description", content: "Manage the RAI OG PAVING gallery and quote requests." },
      { name: "robots", content: "noindex, nofollow" },
      { property: "og:title", content: "Admin | RAI OG PAVING" },
      {
        property: "og:description",
        content: "Manage the RAI OG PAVING gallery and quote requests.",
      },
      { property: "og:type", content: "website" },
      { name: "twitter:card", content: "summary" },
    ],
  }),
  component: AdminApp,
});
