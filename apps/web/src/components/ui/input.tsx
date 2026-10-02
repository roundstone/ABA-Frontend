'use client';

import * as React from "react"
import { cn } from "@/lib/utils"
import { AlertCircle, Eye, EyeOff } from "lucide-react"

export interface InputProps extends Omit<React.InputHTMLAttributes<HTMLInputElement>, 'prefix'> {
  label?: string;
  helperText?: string;
  error?: string;
  prefix?: React.ReactNode;
  suffix?: React.ReactNode;
  type?: 'text' | 'email' | 'password' | 'number' | 'currency' | 'phone' | 'textarea' | string;
}

const Input = React.forwardRef<HTMLInputElement, InputProps>(
  ({ className, type = "text", label, helperText, error, prefix, suffix, ...props }, ref) => {
    const [showPassword, setShowPassword] = React.useState(false);
    const id = React.useId();
    const errorId = `${id}-error`;
    const helperId = `${id}-helper`;

    // Handle custom types
    let inputType = type;
    let computedPrefix = prefix;
    let computedSuffix = suffix;

    if (type === 'password') {
      inputType = showPassword ? 'text' : 'password';
      computedSuffix = (
        <button
          type="button"
          onClick={() => setShowPassword(!showPassword)}
          className="text-muted-foreground hover:text-foreground focus:outline-none focus:ring-1 rounded"
          aria-label={showPassword ? "Hide password" : "Show password"}
        >
          {showPassword ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
        </button>
      );
    } else if (type === 'currency') {
      inputType = 'text'; // Simplified for this demo
      computedPrefix = <span className="text-muted-foreground">₦</span>;
    } else if (type === 'phone') {
      inputType = 'tel';
      computedPrefix = <span className="text-muted-foreground">+234</span>;
    }

    const isTextarea = type === 'textarea';

    const renderInput = () => {
      const inputClass = cn(
        "flex w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50",
        computedPrefix && "pl-8",
        (computedSuffix || error) && "pr-8",
        error && "border-destructive focus-visible:ring-destructive",
        isTextarea ? "min-h-[80px]" : "h-10",
        className
      );

      if (isTextarea) {
        return (
          <textarea
            className={inputClass}
            aria-invalid={!!error}
            aria-describedby={
              error ? errorId : helperText ? helperId : undefined
            }
            {...(props as any)}
          />
        );
      }

      return (
        <div className="relative flex items-center">
          {computedPrefix && (
            <div className="absolute left-3 flex items-center pointer-events-none">
              {computedPrefix}
            </div>
          )}
          <input
            type={inputType}
            className={inputClass}
            ref={ref}
            aria-invalid={!!error}
            aria-describedby={
              error ? errorId : helperText ? helperId : undefined
            }
            {...props}
          />
          {error && !computedSuffix && (
            <div className="absolute right-3 flex items-center pointer-events-none text-destructive">
              <AlertCircle className="h-4 w-4" />
            </div>
          )}
          {computedSuffix && (
            <div className="absolute right-3 flex items-center">
              {computedSuffix}
            </div>
          )}
        </div>
      );
    };

    return (
      <div className="w-full space-y-1.5">
        {label && (
          <label htmlFor={props.id || id} className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">
            {label}
          </label>
        )}
        
        {renderInput()}

        {error && (
          <p id={errorId} className="text-[0.8rem] font-medium text-destructive flex items-center gap-1">
             <AlertCircle className="h-3 w-3" /> {error}
          </p>
        )}
        {helperText && !error && (
          <p id={helperId} className="text-[0.8rem] text-muted-foreground">
            {helperText}
          </p>
        )}
      </div>
    )
  }
)
Input.displayName = "Input"

export { Input }
