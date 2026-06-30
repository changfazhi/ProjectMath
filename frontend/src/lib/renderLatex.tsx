import type { ReactNode } from 'react'
import { Latex } from '../components/math/Latex'
import { LatexBlock } from '../components/math/LatexBlock'

// Recognise both LaTeX-style \( \) / \[ \] and TeX-style $ / $$ delimiters. LLMs (Gemini) tend to
// emit math wrapped in $...$ / $$...$$, so without these the feedback would show as raw LaTeX text.
// Order matters: $$...$$ must be tried before $...$ in the alternation.
const DELIMITERS =
  /(\\\([\s\S]*?\\\)|\\\[[\s\S]*?\\\]|\$\$[\s\S]*?\$\$|\$[^$\n]+?\$)/g

export function renderLatex(source: string): ReactNode[] {
  const parts = source.split(DELIMITERS)
  return parts.map((part, i) => {
    if (part.startsWith('\\(') && part.endsWith('\\)')) {
      return <Latex key={i}>{part.slice(2, -2)}</Latex>
    }
    if (part.startsWith('\\[') && part.endsWith('\\]')) {
      return <LatexBlock key={i}>{part.slice(2, -2)}</LatexBlock>
    }
    if (part.startsWith('$$') && part.endsWith('$$') && part.length >= 4) {
      return <LatexBlock key={i}>{part.slice(2, -2)}</LatexBlock>
    }
    if (part.startsWith('$') && part.endsWith('$') && part.length >= 2) {
      return <Latex key={i}>{part.slice(1, -1)}</Latex>
    }
    return part ? <span key={i}>{part}</span> : null
  })
}
