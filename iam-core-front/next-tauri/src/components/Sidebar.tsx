"use client";
import { useState } from "react";
import { usePathname } from "next/navigation";
import { FaTachometerAlt, FaUsers, FaUserShield, FaBars } from "react-icons/fa";

const menuItems = [
  { name: "Dashboard", path: "/dashboard", icon: <FaTachometerAlt /> },
  { name: "Usuarios", path: "/dashboard/users", icon: <FaUsers /> },
  { name: "Roles", path: "/dashboard/roles", icon: <FaUserShield /> },
];

export default function Sidebar() {
  const pathname = usePathname();
  const [collapsed, setCollapsed] = useState(false);

  return (
    <aside className={`sidebar ${collapsed ? "collapsed" : ""}`}>
      <div className="sidebar__top">
        <h1 className="sidebar__logo">{collapsed ? "TT" : "TT Enterprise"}</h1>
        <button className="sidebar__toggle" onClick={() => setCollapsed(!collapsed)}>
          <FaBars />
        </button>
      </div>
      <nav className="sidebar__menu">
        {menuItems.map((item) => (
          <a
            key={item.name}
            href={item.path}
            className={`sidebar__item ${pathname === item.path ? "active" : ""}`}
          >
            <span className="icon">{item.icon}</span>
            {!collapsed && <span className="label">{item.name}</span>}
          </a>
        ))}
      </nav>
    </aside>
  );
}
