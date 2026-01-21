// src/app/dashboard/page.tsx
"use client"; // importante para hooks

import { FaDollarSign, FaUsers, FaBell } from "react-icons/fa";

export default function DashboardPage() {
  return (
    <div className="dashboard">
      <div className="widget">
        <div className="widget-header">
          <FaDollarSign className="icon" style={{ color: "#10b981" }} />
          <span className="title">Ventas</span>
        </div>
        <div className="widget-content">$12,345</div>
        <div className="widget-subtext">Últimas 24 horas</div>
      </div>

      <div className="widget">
        <div className="widget-header">
          <FaUsers className="icon" style={{ color: "#3b82f6" }} />
          <span className="title">Usuarios</span>
        </div>
        <div className="widget-content">120</div>
        <div className="widget-subtext">Usuarios activos</div>
      </div>

      <div className="widget">
        <div className="widget-header">
          <FaBell className="icon" style={{ color: "#ef4444" }} />
          <span className="title">Alertas</span>
        </div>
        <div className="widget-content">3</div>
        <div className="widget-subtext">Nuevas alertas</div>
      </div>
    </div>
  );
}
