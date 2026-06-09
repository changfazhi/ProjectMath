import { Latex } from './Latex'

export function LatexBlock({ children }: { children: string }) {
  return (
    <div className="overflow-x-auto py-2 my-1">
      <Latex display>{children}</Latex>
    </div>
  )
}
