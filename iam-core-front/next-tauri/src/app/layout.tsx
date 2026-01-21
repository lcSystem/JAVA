  "use client";
import "./styles/globals.scss";
import Sidebar from "../components/Sidebar";
import Navbar from "../components/Navbar";
import Footer from "../components/Footer";

interface RootLayoutProps {
  children: React.ReactNode;
}

export default function RootLayout({ children }: RootLayoutProps) {
  return (
    <html lang="es">
      <body>
        <div className="dashboard-layout">
          <Sidebar />
          <div className="dashboard-layout__content">
            <Navbar />
            <main className="dashboard-layout__main">{children}</main>
             <Footer />
          </div>
        </div>
      </body>
    </html>
  );
}
