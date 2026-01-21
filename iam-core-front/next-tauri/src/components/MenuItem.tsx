"use client";
import Link from "next/link";

interface MenuItemProps {
  name: string;
  path: string;
  active?: boolean;
}

export default function MenuItem({ name, path, active }: MenuItemProps) {
  return (
    <Link
      href={path}
      className={`
        block px-4 py-2 rounded-lg font-medium transition-colors duration-200
        ${active ? "bg-indigo-100 text-indigo-700" : "text-gray-700 hover:bg-gray-100"}
      `}
    >
      {name}
    </Link>
  );
}
