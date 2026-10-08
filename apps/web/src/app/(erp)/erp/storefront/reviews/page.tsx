import { PageHeader } from '@/components/patterns/PageHeader';
import { ModerationList } from '@/features/reviews';
import { RequirePermission } from '@/lib/auth/permissions';

export const metadata = {
  title: 'Review Moderation | Admin',
};

export default function ReviewModerationPage() {
  return (
    <RequirePermission I="reviews.moderate">
      <div className="space-y-6">
        <PageHeader 
          title="Review Moderation" 
          description="Manage customer product reviews"
        />
        <ModerationList />
      </div>
    </RequirePermission>
  );
}
