export default function SectionHeading({ 
  subtitle, 
  title, 
  innerClass = 'title-inner2' 
}: { 
  subtitle?: string; 
  title: string; 
  innerClass?: string;
}) {
  return (
    <div className="title2">
      {subtitle && <h4>{subtitle}</h4>}
      <h2 className={innerClass}>{title}</h2>
    </div>
  );
}
