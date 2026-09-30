import React from 'react';
import { formatMoney } from '@/lib/format';

export interface AmountTextProps extends React.HTMLAttributes<HTMLSpanElement> {
  amountInKobo: number;
  useParenthesesForNegative?: boolean;
}

/**
 * AmountText displays money using tabular numerals.
 * Negative amounts are shown in red.
 * Optionally uses parentheses for negative amounts (common in finance).
 */
export function AmountText({
  amountInKobo,
  useParenthesesForNegative = false,
  className = '',
  ...props
}: AmountTextProps) {
  const isNegative = amountInKobo < 0;
  
  let formatted = formatMoney(Math.abs(amountInKobo));
  
  if (isNegative) {
    if (useParenthesesForNegative) {
      formatted = `(${formatted})`;
    } else {
      formatted = `-${formatted}`;
    }
  }

  // Combine classes. text-error is red in our globals.css, font-variant-numeric: tabular-nums is applied if needed, but let's apply a utility class.
  const colorClass = isNegative ? 'text-error' : '';
  const classes = `tabular-nums ${colorClass} ${className}`.trim();

  return (
    <span className={classes} {...props}>
      {formatted}
    </span>
  );
}
