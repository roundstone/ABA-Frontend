export interface NetworkNodeData {
  id: string;
  name: string;
  code: string;
  active: boolean;
  sales: number; // in kobo
  downlineCount: number;
  level: number; // calculated depth relative to query root
  children?: NetworkNodeData[];
}
