import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";

const inter = Inter({ subsets: ["latin"], variable: "--font-inter" });

export const metadata: Metadata = {
  title: { default: "TravelMiles AI", template: "%s | TravelMiles AI" },
  description:
    "Pesquise passagens aéreas, compare preços em dinheiro e milhas, e planeje viagens com inteligência artificial.",
  keywords: ["passagens aéreas", "milhas", "viagens", "comparador", "IA"],
  authors: [{ name: "TravelMiles AI" }],
  openGraph: {
    type: "website",
    locale: "pt_BR",
    url: process.env.NEXT_PUBLIC_APP_URL,
    title: "TravelMiles AI",
    description: "A plataforma mais inteligente para pesquisa de passagens e milhas.",
    siteName: "TravelMiles AI",
  },
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="pt-BR" suppressHydrationWarning>
      <body className={`${inter.variable} font-sans`}>{children}</body>
    </html>
  );
}
