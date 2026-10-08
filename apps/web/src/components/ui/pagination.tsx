"use client";

import { ChevronLeft, ChevronRight, MoreHorizontal } from "lucide-react";
import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";

export type PaginationMeta = {
  page: number;
  totalPages: number;
  total?: number
};

type PaginationProps = {
  meta: PaginationMeta;
  onPageChange: (page: number) => void;
  variant?: "simple" | "numbered";
  className?: string;
  siblingCount?: number;
};

export function Pagination({
  meta,
  onPageChange,
  variant = "simple",
  className,
  siblingCount = 1,
}: PaginationProps) {
  const { page, totalPages } = meta;

  if (totalPages <= 1) return null;

  const goToPage = (nextPage: number) => {
    if (nextPage < 1 || nextPage > totalPages || nextPage === page) {
      return;
    }

    onPageChange(nextPage);
  };

  if (variant === "simple") {
    return (
      <nav
        aria-label="Pagination"
        className={cn(
          "mt-10 flex items-center justify-center gap-3",
          className
        )}
      >
        <Button
          variant="outline"
          size="sm"
          disabled={page <= 1}
          onClick={() => goToPage(page - 1)}
        >
          <ChevronLeft className="h-4 w-4" />
          Previous
        </Button>

        <span className="text-sm text-text-muted">
          Page {page} of {totalPages}
        </span>

        <Button
          variant="outline"
          size="sm"
          disabled={page >= totalPages}
          onClick={() => goToPage(page + 1)}
        >
          Next
          <ChevronRight className="h-4 w-4" />
        </Button>
      </nav>
    );
  }

  // Generate page numbers with ellipses for large page counts.
  const pages: (number | "...")[] = [];
  const left = Math.max(2, page - siblingCount);
  const right = Math.min(totalPages - 1, page + siblingCount);

  pages.push(1);

  if (left > 2) {
    pages.push("...");
  }

  for (let i = left; i <= right; i++) {
    pages.push(i);
  }

  if (right < totalPages - 1) {
    pages.push("...");
  }

  if (totalPages > 1) {
    pages.push(totalPages);
  }

  return (
    <nav
      aria-label="Pagination"
      className={cn(
        "mt-10 flex flex-wrap items-center justify-center gap-2",
        className
      )}
    >
      <Button
        variant="outline"
        size="sm"
        disabled={page <= 1}
        onClick={() => goToPage(page - 1)}
      >
        <ChevronLeft className="h-4 w-4" />
        Previous
      </Button>

      {pages.map((item, index) =>
        item === "..." ? (
          <span
            key={`ellipsis-${index}`}
            aria-hidden="true"
            className="flex h-9 w-9 items-center justify-center text-text-muted"
          >
            <MoreHorizontal className="h-4 w-4" />
          </span>
        ) : (
          <Button
            key={item}
            variant={item === page ? "primary" : "outline"}
            size="sm"
            aria-label={`Go to page ${item}`}
            aria-current={item === page ? "page" : undefined}
            onClick={() => goToPage(item)}
            className="min-w-9"
          >
            {item}
          </Button>
        )
      )}

      <Button
        variant="outline"
        size="sm"
        disabled={page >= totalPages}
        onClick={() => goToPage(page + 1)}
      >
        Next
        <ChevronRight className="h-4 w-4" />
      </Button>
    </nav>
  );
}
// import * as React from "react"
// import { cn } from "cn"

// import { Button } from "@/components/ui/button"
// import { ChevronLeftIcon, ChevronRightIcon, MoreHorizontalIcon } from "lucide-react"

// function Pagination({ className, ...props }: React.ComponentProps<"nav">) {
//   return (
//     <nav
//       role="navigation"
//       aria-label="pagination"
//       data-slot="pagination"
//       className={cn("mx-auto flex w-full justify-center", className)}
//       {...props}
//     />
//   )
// }

// function PaginationContent({
//   className,
//   ...props
// }: React.ComponentProps<"ul">) {
//   return (
//     <ul
//       data-slot="pagination-content"
//       className={cn("flex items-center gap-0.5", className)}
//       {...props}
//     />
//   )
// }

// function PaginationItem({ ...props }: React.ComponentProps<"li">) {
//   return <li data-slot="pagination-item" {...props} />
// }

// type PaginationLinkProps = {
//   isActive?: boolean
// } & Pick<React.ComponentProps<typeof Button>, "size"> &
//   React.ComponentProps<"a">

// function PaginationLink({
//   className,
//   isActive,
//   size = "icon",
//   ...props
// }: PaginationLinkProps) {
//   return (
//     <Button
//       variant={isActive ? "outline" : "ghost"}
//       size={size}
//       className={cn(className)}
//       asChild
//     >
//       <a
//         aria-current={isActive ? "page" : undefined}
//         data-slot="pagination-link"
//         data-active={isActive}
//         {...props}
//       />
//     </Button>
//   )
// }

// function PaginationPrevious({
//   className,
//   text = "Previous",
//   ...props
// }: React.ComponentProps<typeof PaginationLink> & { text?: string }) {
//   return (
//     <PaginationLink
//       aria-label="Go to previous page"
//       size="md"
//       className={cn("pl-1.5!", className)}
//       {...props}
//     >
//       <ChevronLeftIcon data-icon="inline-start" />
//       <span className="hidden sm:block">{text}</span>
//     </PaginationLink>
//   )
// }

// function PaginationNext({
//   className,
//   text = "Next",
//   ...props
// }: React.ComponentProps<typeof PaginationLink> & { text?: string }) {
//   return (
//     <PaginationLink
//       aria-label="Go to next page"
//       size="md"
//       className={cn("pr-1.5!", className)}
//       {...props}
//     >
//       <span className="hidden sm:block">{text}</span>
//       <ChevronRightIcon data-icon="inline-end" />
//     </PaginationLink>
//   )
// }

// function PaginationEllipsis({
//   className,
//   ...props
// }: React.ComponentProps<"span">) {
//   return (
//     <span
//       aria-hidden
//       data-slot="pagination-ellipsis"
//       className={cn(
//         "flex size-8 items-center justify-center [&_svg:not([class*='size-'])]:size-4",
//         className
//       )}
//       {...props}
//     >
//       <MoreHorizontalIcon
//       />
//       <span className="sr-only">More pages</span>
//     </span>
//   )
// }

// export {
//   Pagination,
//   PaginationContent,
//   PaginationEllipsis,
//   PaginationItem,
//   PaginationLink,
//   PaginationNext,
//   PaginationPrevious,
// }
