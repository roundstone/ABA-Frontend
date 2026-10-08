export type PageStatus = 'Draft' | 'Published' | 'Archived';

export interface PageSection {
  id: string;
  pageId: string;
  name: string;
  content: string;
  order: number;
  status: PageStatus;
  version: number;
}

export interface Page {
  id: string;
  slug: string;
  title: string;
  sections: PageSection[];
}
