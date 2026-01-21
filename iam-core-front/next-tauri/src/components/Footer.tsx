"use client";

import { FaFacebookF, FaTwitter, FaLinkedinIn } from "react-icons/fa";

export default function Footer() {
  return (
    <footer className="dashboard-footer">
      <div className="dashboard-footer__container">
        <div className="dashboard-footer__info">
          <span className="font-semibold">&copy; {new Date().getFullYear()} TT Enterprise</span>
        </div>

        <div className="dashboard-footer__links">
          <a href="#" className="footer-link">Ayuda</a>
          <a href="#" className="footer-link">Soporte</a>
          <a href="#" className="footer-link">Política</a>
        </div>

        <div className="dashboard-footer__socials">
          <a href="#" className="social-link"><FaFacebookF /></a>
          <a href="#" className="social-link"><FaTwitter /></a>
          <a href="#" className="social-link"><FaLinkedinIn /></a>
        </div>
      </div>
    </footer>
  );
}
