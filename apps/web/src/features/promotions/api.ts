import { Promotion, PromotionPackage, PromotionAnalytics } from './types';
import { mockPromotions, mockPackages } from './mocks';

let promotionsDB = [...mockPromotions];
let packagesDB = [...mockPackages];

// Simulate network delay
const delay = (ms: number) => new Promise(resolve => setTimeout(resolve, ms));

export async function getPromotions(): Promise<{ data: Promotion[] }> {
  await delay(500);
  return { data: [...promotionsDB] };
}

export async function getPromotionPackages(): Promise<{ data: PromotionPackage[] }> {
  await delay(300);
  return { data: [...packagesDB] };
}

export async function createPromotionPackage(data: Omit<PromotionPackage, 'id' | 'status'>): Promise<{ data: PromotionPackage }> {
  await delay(500);
  const newPkg: PromotionPackage = {
    ...data,
    id: `pkg_${Math.random().toString(36).substr(2, 9)}`,
    status: 'Active'
  };
  packagesDB = [...packagesDB, newPkg];
  return { data: newPkg };
}

export async function updatePromotionPackageStatus(id: string, status: PromotionPackage['status']): Promise<{ data: PromotionPackage }> {
  await delay(400);
  const index = packagesDB.findIndex(p => p.id === id);
  if (index === -1) throw new Error('Package not found');
  
  const updated = { ...packagesDB[index], status };
  packagesDB = [
    ...packagesDB.slice(0, index),
    updated,
    ...packagesDB.slice(index + 1)
  ];
  return { data: updated };
}

export async function createPromotion(data: Omit<Promotion, 'id' | 'reference' | 'status' | 'impressions' | 'clicks' | 'addToCart' | 'attributedOrders' | 'spendInKobo'>): Promise<{ data: Promotion }> {
  await delay(800);
  
  const newPromotion: Promotion = {
    ...data,
    id: `prm_${Math.random().toString(36).substr(2, 9)}`,
    reference: `PRM-2026-${String(promotionsDB.length + 1).padStart(4, '0')}`,
    status: 'Scheduled',
    impressions: 0,
    clicks: 0,
    addToCart: 0,
    attributedOrders: 0,
    spendInKobo: data.amountPaidInKobo
  };
  
  promotionsDB = [newPromotion, ...promotionsDB];
  return { data: newPromotion };
}

export async function updatePromotionStatus(id: string, status: Promotion['status']): Promise<{ data: Promotion }> {
  await delay(500);
  
  const index = promotionsDB.findIndex(p => p.id === id);
  if (index === -1) throw new Error('Promotion not found');
  
  const updated = { ...promotionsDB[index], status };
  promotionsDB = [
    ...promotionsDB.slice(0, index),
    updated,
    ...promotionsDB.slice(index + 1)
  ];
  
  return { data: updated };
}

export async function getMerchantPromotionAnalytics(merchantId: string): Promise<{ data: PromotionAnalytics }> {
  await delay(600);
  
  const merchantPromos = promotionsDB.filter(p => p.merchantId === merchantId);
  
  const totalImpressions = merchantPromos.reduce((sum, p) => sum + p.impressions, 0);
  const totalClicks = merchantPromos.reduce((sum, p) => sum + p.clicks, 0);
  
  return {
    data: {
      totalImpressions,
      totalClicks,
      ctr: totalImpressions > 0 ? (totalClicks / totalImpressions) * 100 : 0,
      totalAddToCart: merchantPromos.reduce((sum, p) => sum + p.addToCart, 0),
      totalOrders: merchantPromos.reduce((sum, p) => sum + p.attributedOrders, 0),
      totalSpendInKobo: merchantPromos.reduce((sum, p) => sum + p.spendInKobo, 0)
    }
  };
}
