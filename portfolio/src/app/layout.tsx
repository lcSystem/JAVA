import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Luigis | Java Backend Developer — Portfolio",
  description: "Interactive professional desktop simulation showcasing 3+ years of enterprise Java development, microservices architecture, OAuth2/JWT security, and clean architecture.",
  keywords: "Java, Spring Boot, Microservices, OAuth2, JWT, Clean Architecture, Developer, Portfolio",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body style={{ margin: 0, padding: 0 }}>
        {children}
      </body>
    </html>
  );
}
