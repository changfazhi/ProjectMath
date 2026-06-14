import type { MathfieldElement } from 'mathlive'

declare global {
  namespace JSX {
    interface IntrinsicElements {
      'math-field': React.DetailedHTMLProps<React.HTMLAttributes<MathfieldElement>, MathfieldElement> & {
        'virtual-keyboard-mode'?: string
        'math-mode-space'?: string
        placeholder?: string
      }
    }
  }
}
