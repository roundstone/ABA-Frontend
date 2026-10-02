// "use client";

// import React, { useState } from "react";
// import {
//   Table,
//   TableBody,
//   TableCell,
//   TableHead,
//   TableHeader,
//   TableRow,
// } from "@/components/ui/table";
// import { Input } from "@/components/ui/input";
// import {
//   Select,
//   SelectContent,
//   SelectItem,
//   SelectTrigger,
//   SelectValue,
// } from "@/components/ui/select";
// import { Trash2, Plus, AlertTriangle, CheckCircle } from "lucide-react";

// // --- 1. TYPES (Enhanced with Discount & Images) ---

// interface LineItem {
//   id: string;
//   name: string;
//   sku?: string;
//   quantity: number;
//   unitPrice: number;
//   unitOfMeasure?: string;
//   lineTotal: number;
//   imageUrl?: string;
//   // --- NEW FIELDS ---
//   isDiscountApplied: boolean;
//   discountType: "percentage" | "fixed";
//   discountAmount: number;
//   effectivePrice: number;
// }

// interface PricingBreakdown {
//   subtotal: number;
//   totalDiscount: number;
//   tax: number;
//   grandTotal: number;
//   items: LineItem[];
// }

// interface LineItemsEditorProps {
//   items: LineItem[];
//   onUpdate: (items: LineItem[], pricing: PricingBreakdown) => void;
// }

// // --- 2. HELPER: PRICING LOGIC (Enhanced) ---

// const calculatePricing = (items: LineItem[]): PricingBreakdown => {
//   let subtotal = 0;
//   let totalDiscount = 0;

//   const calculatedItems = items.map((item) => {
//     // Default values if not set
//     if (item.quantity === undefined) item.quantity = 1;
//     if (item.unitPrice === undefined) item.unitPrice = 0;

//     const baseLineTotal = item.quantity * item.unitPrice;
//     let discount = 0;

//     if (item.isDiscountApplied && item.discountAmount > 0) {
//       if (item.discountType === "percentage") {
//         discount = baseLineTotal * (item.discountAmount / 100);
//       } else {
//         discount = item.discountAmount * item.quantity; // Fixed amount per item
//       }
//     }

//     const lineTotal = baseLineTotal - discount;
//     subtotal += lineTotal;

//     return {
//       ...item,
//       lineTotal,
//       effectivePrice: item.unitPrice - (item.isDiscountApplied ? (item.discountType === "percentage" ? (item.unitPrice * item.discountAmount / 100) : item.discountAmount) : 0),
//     };
//   });

//   totalDiscount = items.reduce(
//     (sum, item) => sum + (item.isDiscountApplied ? (item.discountType === "percentage" ? item.quantity * item.unitPrice * (item.discountAmount / 100) : item.discountAmount * item.quantity) : 0),
//     0
//   );

//   // Assuming 5% tax for demo
//   const tax = subtotal * 0.05;
//   const grandTotal = subtotal + tax;

//   return { subtotal, totalDiscount, tax, grandTotal, items: calculatedItems };
// };

// // --- 3. MAIN EDITOR COMPONENT (Optimized) ---

// export function LineItemsEditor({ items, onUpdate }: LineItemsEditorProps) {
//   const [localItems, setLocalItems] = useState<LineItem[]>([]);

//   // Sync external prop changes to internal state
//   React.useEffect(() => {
//     setLocalItems(items);
//   }, [items]);

//   const updateItem = (id: string, updates: Partial<LineItem>) => {
//     const updated = localItems.map((i) =>
//       i.id === id ? { ...i, ...updates } : i
//     );
//     setLocalItems(updated);
//     const pricing = calculatePricing(updated);
//     onUpdate(updated, pricing);
//   };

//   const toggleDiscount = (id: string, isApplied: boolean) => {
//     updateItem(id, {
//       isDiscountApplied: isApplied,
//       discountType: "percentage", // Reset type on toggle
//       discountAmount: 0, // Reset amount on toggle
//     });
//   };

//   const addItem = () => {
//     const newItem: LineItem = {
//       id: Date.now().toString(),
//       name: "",
//       quantity: 1,
//       unitPrice: 0,
//       lineTotal: 0,
//       isDiscountApplied: false,
//       discountType: "percentage",
//       discountAmount: 0,
//     };
//     const newList = [...localItems, newItem];
//     setLocalItems(newList);
//     const pricing = calculatePricing(newList);
//     onUpdate(newList, pricing);
//   };

//   const removeItem = (id: string) => {
//     const filtered = localItems.filter((i) => i.id !== id);
//     setLocalItems(filtered);
//     const pricing = calculatePricing(filtered);
//     onUpdate(filtered, pricing);
//   };

//   const { subtotal, totalDiscount, tax, grandTotal } = calculatePricing(localItems);

//   return (
//     <div className="w-full">
//       {/* Items Table */}
//       <div className="border rounded-lg overflow-hidden bg-surface">
//         <Table>
//           <TableHeader className="bg-surface-2">
//             <TableRow>
//               <TableHead className="w-[250px]">Product</TableHead>
//               <TableHead>Price</TableHead>
//               <TableHead>Qty</TableHead>
//               <TableHead className="w-[150px]">Discount</TableHead>
//               <TableHead className="text-right">Total</TableHead>
//               <TableHead className="w-12"></TableHead>
//             </TableRow>
//           </TableHeader>
//           <TableBody>
//             {localItems.length === 0 && (
//               <TableRow>
//                 <TableCell colSpan={6} className="text-center py-8 text-muted-foreground">
//                   No items added.
//                 </TableCell>
//               </TableRow>
//             )}
//             {localItems.map((item) => {
//               const isDiscountApplied = item.isDiscountApplied;
//               const effectivePrice = item.unitPrice - (isDiscountApplied
//                 ? (item.discountType === "percentage"
//                   ? (item.unitPrice * item.discountAmount) / 100
//                   : item.discountAmount)
//                 : 0);

//               return (
//                 <TableRow key={item.id} className="group">
//                   {/* Product Column */}
//                   <TableCell className="py-4">
//                     <div className="flex items-start gap-3">
//                       {item.imageUrl ? (
//                         <img
//                           src={item.imageUrl}
//                           alt={item.name}
//                           className="w-14 h-14 rounded-md object-cover border border-border"
//                         />
//                       ) : (
//                         <div className="w-14 h-14 rounded-md bg-surface-2 flex items-center justify-center text-xs text-muted-foreground">
//                           No Image
//                         </div>
//                       )}
//                       <div className="flex-1 flex flex-col gap-1">
//                         <Input
//                           placeholder="Product name"
//                           value={item.name}
//                           onChange={(e) => updateItem(item.id, { name: e.target.value })}
//                           className="font-medium h-9 text-sm border-border"
//                         />
//                         <div className="flex gap-2">
//                           <Input
//                             placeholder="SKU"
//                             value={item.sku || ""}
//                             onChange={(e) => updateItem(item.id, { sku: e.target.value })}
//                             className="h-7 text-xs border-border bg-transparent placeholder:text-muted-foreground/50 w-24"
//                           />
//                           <Input
//                             placeholder="UOM"
//                             value={item.unitOfMeasure || ""}
//                             onChange={(e) => updateItem(item.id, { unitOfMeasure: e.target.value })}
//                             className="h-7 text-xs border-border bg-transparent placeholder:text-muted-foreground/
