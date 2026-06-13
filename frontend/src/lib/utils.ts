export function cn(...classes: (string | undefined | false | null)[]): string {
  return classes.filter(Boolean).join(' ')
}

export function formatTime(seconds: number): string {
  if (seconds < 60) return `${seconds}s`
  const m = Math.floor(seconds / 60)
  const s = seconds % 60
  return s === 0 ? `${m}m` : `${m}m ${s}s`
}

export function parseOption(opt: string): { letter: string; latex: string } {
  const idx = opt.indexOf(': ')
  if (idx === -1) return { letter: '', latex: opt }
  return { letter: opt.slice(0, idx), latex: opt.slice(idx + 2) }
}
