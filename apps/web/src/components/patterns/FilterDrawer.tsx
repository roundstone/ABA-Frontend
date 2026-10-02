import React from 'react';
import { RotateCcw, SlidersHorizontal, X } from 'lucide-react';
import {
  Sheet,
  SheetContent,
  SheetHeader,
  SheetTitle,
  SheetDescription,
  SheetFooter,
} from '@/components/ui/sheet';
import { Button } from '@/components/ui/button';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { cn } from '@/lib/utils';
import { FilterDefinition } from './FilterBar';

interface FilterDrawerProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  filters: FilterDefinition[];
  activeFilters: Record<string, any>;
  onFilterChange?: (key: string, value: any) => void;
  onClearFilters?: () => void;
  /** Optional: shows "View 24 results" on the primary button */
  resultCount?: number;
}

const isActive = (value: unknown) =>
  value !== undefined && value !== null && value !== '' && value !== 'all';

export function FilterDrawer({
  open,
  onOpenChange,
  filters,
  activeFilters,
  onFilterChange,
  onClearFilters,
  resultCount,
}: FilterDrawerProps) {
  const handleFilterChange = (key: string, value: string | null) => {
    onFilterChange?.(key, !value || value === 'all' ? undefined : value);
  };

  const getOptionLabel = (filter: FilterDefinition, value: string) =>
    filter.options?.find((o) => o.value === value)?.label ?? value;

  const applied = filters.filter((f) => isActive(activeFilters[f.key]));
  const activeCount = applied.length;

  return (
    <Sheet open={open} onOpenChange={onOpenChange}>
      <SheetContent
        side="right"
        className="w-full gap-0 p-0 sm:max-w-[480px]"
      >
        {/* Header */}
        <SheetHeader className="gap-1 border-b border-border px-6 py-5 pr-14">
          <div className="flex items-center gap-3">
            <span className="flex h-9 w-9 items-center justify-center rounded-lg bg-primary/10 text-primary">
              <SlidersHorizontal className="h-4 w-4" />
            </span>
            <div className="flex flex-col">
              <SheetTitle className="flex items-center gap-2 text-lg font-semibold tracking-tight">
                Filters
                {activeCount > 0 && (
                  <span className="inline-flex h-5 min-w-5 items-center justify-center rounded-full bg-primary px-1.5 text-xs font-medium text-primary-foreground tabular-nums">
                    {activeCount}
                  </span>
                )}
              </SheetTitle>
              <SheetDescription>
                Narrow down your results.
              </SheetDescription>
            </div>
          </div>
        </SheetHeader>

        {/* Body */}
        <div className="flex-1 overflow-y-auto">
          {/* Applied chips */}
          {activeCount > 0 && (
            <div className="border-b border-border bg-muted/40 px-6 py-4">
              <div className="mb-2.5 flex items-center justify-between">
                <p className="text-xs font-medium text-muted-foreground">
                  Applied filters
                </p>
              </div>
              <div className="flex flex-wrap gap-2">
                {applied.map((f) => (
                  <button
                    key={f.key}
                    type="button"
                    onClick={() => handleFilterChange(f.key, null)}
                    aria-label={`Remove ${f.label} filter`}
                    className="group inline-flex items-center gap-1.5 rounded-full border border-primary/20 bg-background py-1 pr-1.5 pl-3 text-xs shadow-xs transition-colors hover:border-destructive/40 hover:bg-destructive/5 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary"
                  >
                    <span className="text-muted-foreground">{f.label}:</span>
                    <span className="font-medium text-foreground">
                      {getOptionLabel(f, String(activeFilters[f.key]))}
                    </span>
                    <span className="flex h-4 w-4 items-center justify-center rounded-full bg-muted text-muted-foreground transition-colors group-hover:bg-destructive/15 group-hover:text-destructive">
                      <X className="h-3 w-3" />
                    </span>
                  </button>
                ))}
              </div>
            </div>
          )}

          {/* Filter fields */}
          <div className="space-y-3 px-6 py-5">
            {filters.map((filter) => {
              const value = activeFilters[filter.key];
              const active = isActive(value);

              return (
                <div
                  key={filter.key}
                  className={cn(
                    'relative rounded-xl border bg-background p-4 transition-colors',
                    active
                      ? 'border-primary/40 bg-primary/[0.03]'
                      : 'border-border hover:border-foreground/20'
                  )}
                >
                  {active && (
                    <span className="absolute top-4 bottom-4 left-0 w-0.5 rounded-r-full bg-primary" />
                  )}

                  <div className="mb-2.5 flex items-center justify-between">
                    <label className="text-sm font-medium text-foreground">
                      {filter.label}
                    </label>
                    {active && (
                      <button
                        type="button"
                        onClick={() => handleFilterChange(filter.key, null)}
                        className="text-xs font-medium text-muted-foreground underline-offset-4 transition-colors hover:text-foreground hover:underline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary"
                      >
                        Reset
                      </button>
                    )}
                  </div>

                  <Select
                    value={active ? value : 'all'}
                    onValueChange={(val) => handleFilterChange(filter.key, val)}
                  >
                    <SelectTrigger
                      className={cn(
                        'h-11 w-full rounded-lg',
                        active && 'font-medium'
                      )}
                    >
                      <SelectValue placeholder={`Select ${filter.label}`} />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="all">Any {filter.label}</SelectItem>
                      {filter.options?.map((opt) => (
                        <SelectItem key={opt.value} value={opt.value}>
                          {opt.label}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>
              );
            })}
          </div>
        </div>

        {/* Footer */}
        <SheetFooter className="mt-auto flex-row items-center gap-3 border-t border-border bg-background/95 px-6 py-4 backdrop-blur supports-backdrop-filter:bg-background/80">
          <Button
            variant="outline"
            disabled={activeCount === 0}
            onClick={() => onClearFilters?.()}
            className="h-11 gap-2"
          >
            <RotateCcw className="h-4 w-4" />
            Clear all
          </Button>
          <Button
            onClick={() => onOpenChange(false)}
            className="h-11 flex-1 font-medium"
          >
            {typeof resultCount === 'number'
              ? `Show ${resultCount.toLocaleString()} result${resultCount === 1 ? '' : 's'}`
              : 'Show results'}
          </Button>
        </SheetFooter>
      </SheetContent>
    </Sheet>
  );
}