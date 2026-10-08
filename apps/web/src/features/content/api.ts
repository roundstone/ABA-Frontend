import { Page, PageSection, PageStatus } from './types';
import { mockPages } from './mocks';

const delay = (ms: number) => new Promise(res => setTimeout(res, ms));

const MOCK_PAGES = [...mockPages];

export const getPages = async (): Promise<{ data: Page[] }> => {
  await delay(500);
  return { data: MOCK_PAGES };
};

export const getPageById = async (id: string): Promise<Page> => {
  await delay(500);
  const page = MOCK_PAGES.find(p => p.id === id);
  if (!page) throw new Error('Page not found');
  return page;
};

export const getPageBySlug = async (slug: string): Promise<Page> => {
  await delay(500);
  const page = MOCK_PAGES.find(p => p.slug === slug);
  if (!page) throw new Error('Page not found');
  return page;
};

export const updatePageSection = async (pageId: string, sectionId: string, data: { content: string }): Promise<PageSection> => {
  await delay(800);
  const page = MOCK_PAGES.find(p => p.id === pageId);
  if (!page) throw new Error('Page not found');
  
  const section = page.sections.find(s => s.id === sectionId);
  if (!section) throw new Error('Section not found');

  section.content = data.content;
  section.version += 1;
  return section;
};

export const updateSectionStatus = async (pageId: string, sectionId: string, status: PageStatus): Promise<PageSection> => {
  await delay(800);
  const page = MOCK_PAGES.find(p => p.id === pageId);
  if (!page) throw new Error('Page not found');
  
  const section = page.sections.find(s => s.id === sectionId);
  if (!section) throw new Error('Section not found');

  section.status = status;
  return section;
};
