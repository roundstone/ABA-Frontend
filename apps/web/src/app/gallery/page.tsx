import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Badge } from "@/components/ui/badge"

export default function GalleryPage() {
  return (
    <div className="p-8 space-y-8">
      <h1 className="text-h1">UI Gallery</h1>
      
      <section className="space-y-4">
        <h2 className="text-h2">Buttons</h2>
        <div className="flex gap-4">
          <Button>Primary</Button>
          <Button variant="secondary">Secondary</Button>
          <Button variant="outline">Outline</Button>
          <Button variant="ghost">Ghost</Button>
          <Button variant="destructive">Destructive</Button>
        </div>
      </section>

      <section className="space-y-4">
        <h2 className="text-h2">Inputs</h2>
        <div className="max-w-sm space-y-4">
          <Input placeholder="Default input" />
          <Input placeholder="Disabled input" disabled />
        </div>
      </section>

      <section className="space-y-4">
        <h2 className="text-h2">Badges</h2>
        <div className="flex gap-4">
          <Badge>Default</Badge>
          <Badge variant="secondary">Secondary</Badge>
          <Badge variant="outline">Outline</Badge>
          <Badge variant="destructive">Destructive</Badge>
        </div>
      </section>
      
    </div>
  )
}
