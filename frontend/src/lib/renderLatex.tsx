import type { ReactNode } from 'react'
import { Latex } from '../components/math/Latex'
import { LatexBlock } from '../components/math/LatexBlock'

const DELIMITERS = /(\\\([\s\S]*?\\\)|\\\[[\s\S]*?\\\])/g

export function renderLatex(source: string): ReactNode[] {
  const parts = source.split(DELIMITERS)
  return parts.map((part, i) => {
    if (part.startsWith('\\(') && part.endsWith('\\)')) {
      return <Latex key={i}>{part.slice(2, -2)}</Latex>
    }
    if (part.startsWith('\\[') && part.endsWith('\\]')) {
      return <LatexBlock key={i}>{part.slice(2, -2)}</LatexBlock>
    }
    return part ? <span key={i}>{part}</span> : null
  })
}
