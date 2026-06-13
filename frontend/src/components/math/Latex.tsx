import katex from 'katex'
import { useMemo } from 'react'

interface Props {
  children: string
  display?: boolean
  className?: string
}

export function Latex({ children, display = false, className }: Props) {
  const html = useMemo(() => {
    try {
      return katex.renderToString(children, {
        displayMode: display,
        throwOnError: false,
        strict: false,
      })
    } catch {
      return `<span class="text-red-500">[LaTeX error]</span>`
    }
  }, [children, display])

  return (
    <span
      className={className}
      dangerouslySetInnerHTML={{ __html: html }}
    />
  )
}
