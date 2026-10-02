import React, { useState } from 'react';
import { Search, Filter, X } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Badge } from '@/components/ui/badge';
import { 
  Select, 
  SelectContent, 
  SelectItem, 
  SelectTrigger, 
  SelectValue 
} from '@/components/ui/select';
import { FilterDrawer } from './FilterDrawer';

export interface FilterOption {
  label: string;
  value: string;
}

export interface FilterDefinition {
  key: string;
  label: string;
  type: 'select' | 'boolean' | 'date'; // Supporting select for now based on spec
  options?: FilterOption[];
}

export interface FilterBarProps {
  searchPlaceholder?: string;
  searchValue?: string;
  onSearchChange?: (val: string) => void;
  
  filters?: FilterDefinition[];
  activeFilters?: Record<string, any>;
  onFilterChange?: (key: string, value: any) => void;
  onClearFilters?: () => void;
  
  children?: React.ReactNode;
}

export function FilterBar({
  searchPlaceholder = 'Search...',
  searchValue = '',
  onSearchChange,
  filters = [],
  activeFilters = {},
  onFilterChange,
  onClearFilters,
  children
}: FilterBarProps) {
  const [drawerOpen, setDrawerOpen] = useState(false);
  
  const inlineFilters = filters.slice(0, 4);
  const activeCount = Object.keys(activeFilters).filter(k => activeFilters[k] !== undefined && activeFilters[k] !== '').length;

  const handleFilterChange = (key: string, value: string) => {
    if (onFilterChange) {
      onFilterChange(key, value === 'all' ? undefined : value);
    }
  };

  const clearFilter = (key: string) => {
    if (onFilterChange) {
      onFilterChange(key, undefined);
    }
  };

  return (
    <div className="flex flex-col gap-3 w-full">
      <div className="flex items-center justify-between gap-3 flex-wrap sm:flex-nowrap">
        {/* Search */}
        <div className="relative flex-1 min-w-[200px] max-w-sm">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-text-muted" />
          <Input 
            value={searchValue}
            onChange={(e) => onSearchChange?.(e.target.value)}
            placeholder={searchPlaceholder}
            className="pl-9 h-9 w-full bg-surface text-sm"
          />
        </div>
        
        {/* Inline Filters */}
        <div className="hidden lg:flex items-center gap-3">
          {inlineFilters.map(filter => (
            <div key={filter.key} className="w-[160px]">
              <Select 
                value={activeFilters[filter.key] || 'all'}
                onValueChange={(val) => handleFilterChange(filter.key, val)}
              >
                <SelectTrigger className="w-full h-9 bg-surface text-sm border-border">
                  <SelectValue placeholder={filter.label} />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">{filter.label} (All)</SelectItem>
                  {filter.options?.map(opt => (
                    <SelectItem key={opt.value} value={opt.value}>{opt.label}</SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
          ))}
        </div>

        {/* More Filters & Actions */}
        <div className="flex items-center gap-2 shrink-0">
          {filters.length > 0 && (
            <Button 
              variant="outline" 
              size="sm" 
              className="h-9 relative"
              onClick={() => setDrawerOpen(true)}
            >
              <Filter className="w-4 h-4 mr-2" />
              <span className="hidden sm:inline">Filters</span>
              {activeCount > 0 && (
                <Badge variant="default" className="ml-2 px-1.5 h-5 min-w-5 flex items-center justify-center rounded-full text-[10px]">
                  {activeCount}
                </Badge>
              )}
            </Button>
          )}
          
          {children}
        </div>
      </div>
      
      {/* Active Filter Chips */}
      {activeCount > 0 && (
        <div className="flex items-center gap-2 flex-wrap">
          <span className="text-xs text-text-muted mr-1">Active filters:</span>
          {Object.entries(activeFilters).map(([key, value]) => {
            if (!value) return null;
            const filterDef = filters.find(f => f.key === key);
            if (!filterDef) return null;
            
            const optionDef = filterDef.options?.find(o => o.value === value);
            const displayValue = optionDef ? optionDef.label : String(value);
            
            return (
              <Badge key={key} variant="secondary" className="px-2 py-1 h-7 flex items-center gap-1 bg-surface-2 hover:bg-surface-2 text-xs font-normal border border-border">
                <span className="text-text-muted font-medium mr-1">{filterDef.label}:</span>
                {displayValue}
                <button 
                  onClick={() => clearFilter(key)}
                  className="ml-1 text-text-muted hover:text-text rounded-full focus:outline-none"
                >
                  <X className="w-3 h-3" />
                </button>
              </Badge>
            );
          })}
          
          <button 
            onClick={onClearFilters}
            className="text-xs text-brand-600 hover:text-brand-700 font-medium ml-2"
          >
            Clear all
          </button>
        </div>
      )}

      {/* Drawer */}
      <FilterDrawer 
        open={drawerOpen}
        onOpenChange={setDrawerOpen}
        filters={filters}
        activeFilters={activeFilters}
        onFilterChange={onFilterChange}
        onClearFilters={onClearFilters}
      />
    </div>
  );
}
