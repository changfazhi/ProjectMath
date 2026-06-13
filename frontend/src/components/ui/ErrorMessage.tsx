import { Button } from './Button'

interface Props {
  message: string
  onRetry?: () => void
}

export function ErrorMessage({ message, onRetry }: Props) {
  return (
    <div className="rounded-xl border border-red-200 dark:border-red-800 bg-red-50 dark:bg-red-900/20 p-4 flex flex-col gap-3">
      <p className="text-red-700 dark:text-red-400 text-sm">{message}</p>
      {onRetry && (
        <Button variant="secondary" size="sm" onClick={onRetry} className="self-start">
          Try again
        </Button>
      )}
    </div>
  )
}
