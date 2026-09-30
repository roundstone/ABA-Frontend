import Link from 'next/link';

interface BreadcrumbItem {
  label: string;
  url?: string;
}

interface BreadcrumbProps {
  title: string;
  items: BreadcrumbItem[];
}

export default function Breadcrumb({ title, items }: BreadcrumbProps) {
  return (
    <div className="breadcrumb-section">
      <div className="container">
        <h2>{title}</h2>
        <nav className="theme-breadcrumb">
          <ol className="breadcrumb">
            {items.map((item, index) => (
              <li key={index} className="breadcrumb-item">
                {item.url ? (
                  <Link href={item.url}>{item.label}</Link>
                ) : (
                  <span>{item.label}</span>
                )}
              </li>
            ))}
          </ol>
        </nav>
      </div>
    </div>
  );
}
