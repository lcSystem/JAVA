export default function UsersPage() {
  return (
    <div className="space-y-4">
      <h1 className="text-3xl font-bold text-gray-900">Usuarios</h1>
      <p className="text-gray-700">Listado de usuarios del sistema.</p>

      <div className="mt-6 overflow-x-auto">
        <table className="min-w-full bg-white rounded shadow divide-y divide-gray-200">
          <thead className="bg-gray-100">
            <tr>
              <th className="px-6 py-3 text-left text-gray-700">ID</th>
              <th className="px-6 py-3 text-left text-gray-700">Nombre</th>
              <th className="px-6 py-3 text-left text-gray-700">Email</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-200">
            <tr>
              <td className="px-6 py-4">1</td>
              <td className="px-6 py-4">Juan Pérez</td>
              <td className="px-6 py-4">juan@example.com</td>
            </tr>
            <tr>
              <td className="px-6 py-4">2</td>
              <td className="px-6 py-4">María López</td>
              <td className="px-6 py-4">maria@example.com</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  );
}
