"use client";

export default function Navbar() {
  return (
    <header className="flex justify-between items-center p-4 bg-white shadow-md border-b border-gray-200">
      <h2 className="text-xl font-bold text-gray-800">Panel de Control</h2>
      <div className="flex items-center gap-4">
        <button className="px-4 py-2 bg-indigo-600 text-white rounded-lg font-medium hover:bg-indigo-700 transition-colors duration-200">
          Cerrar sesión
        </button>
      </div>
    </header>
  );
}
