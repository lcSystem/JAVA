// src/components/Widget.tsx
export default function Widget({
  title,
  icon,
  children,
}: {
  title: string;
  icon?: React.ReactNode;
  children?: React.ReactNode;
}) {
  return (
    <div className="bg-white p-5 rounded-xl shadow-md hover:shadow-lg transition-all">
      <div className="flex items-center mb-3">
        {icon && <div className="mr-3">{icon}</div>}
        <h3 className="text-lg font-semibold">{title}</h3>
      </div>
      <div>{children}</div>
    </div>
  );
}
