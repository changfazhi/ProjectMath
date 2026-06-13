import type { ReactNode } from 'react'
import { cn } from '../../lib/utils'

type Variant = 'success' | 'warning' | 'danger' | 'info' | 'neutral'

const variantClasses: Record<Variant, string> = {
  success: 'bg-green-100 text-green-800 dark:bg-green-900/40 dark:text-green-300',
  warning: 'bg-amber-100 text-amber-800 dark:bg-amber-900/40 dark:text-amber-300',
  danger: 'bg-red-100 text-red-800 dark:bg-red-900/40 dark:text-red-300',
  info: 'bg-blue-100 text-blue-800 dark:bg-blue-900/40 dark:text-blue-300',
  neutral: 'bg-slate-100 text-slate-700 dark:bg-slate-800 dark:text-slate-300',
}

interface Props {
  variant?: Variant
  children: ReactNode
  className?: string
}

export function Badge({ variant = 'neutral', children, className }: Props) {
  return (
    <span
      className={cn(
        'inline-flex items-center px-2 py-0.5 rounded-md text-xs font-medium',
        variantClasses[variant],
        className,
      )}
    >
      {children}
    </span>
  )
}
