import { Latex } from './Latex'
import { cn } from '../../lib/utils'

interface MathButton {
  label: string   // LaTeX rendered on the button face
  insert: string  // LaTeX inserted into the math field
  title: string   // tooltip
}

interface Group {
  name: string
  buttons: MathButton[]
}

const GROUPS: Group[] = [
  {
    name: 'Powers & Roots',
    buttons: [
      { label: 'x^2',           insert: '^{2}',           title: 'Square' },
      { label: 'x^3',           insert: '^{3}',           title: 'Cube' },
      { label: 'x^n',           insert: '^{#?}',           title: 'Power' },
      { label: '\\sqrt{x}',     insert: '\\sqrt{#?}',     title: 'Square root' },
      { label: '\\sqrt[n]{x}',  insert: '\\sqrt[#?]{#?}', title: 'nth root' },
    ],
  },
  {
    name: 'Fractions',
    buttons: [
      { label: '\\frac{a}{b}', insert: '\\frac{#?}{#?}', title: 'Fraction' },
    ],
  },
  {
    name: 'Greek',
    buttons: [
      { label: '\\pi',     insert: '\\pi ',     title: 'pi' },
      { label: '\\alpha',  insert: '\\alpha ',  title: 'alpha' },
      { label: '\\beta',   insert: '\\beta ',   title: 'beta' },
      { label: '\\theta',  insert: '\\theta ',  title: 'theta' },
      { label: '\\lambda', insert: '\\lambda ', title: 'lambda' },
      { label: '\\mu',     insert: '\\mu ',     title: 'mu' },
      { label: '\\omega',  insert: '\\omega ',  title: 'omega' },
      { label: '\\infty',  insert: '\\infty ',  title: 'infinity' },
    ],
  },
  {
    name: 'Derivatives',
    buttons: [
      { label: '\\frac{d}{dx}',      insert: '\\frac{d}{dx}',      title: 'Derivative d/dx' },
      { label: '\\frac{dy}{dx}',     insert: '\\frac{dy}{dx}',     title: 'Derivative dy/dx' },
      { label: '\\frac{d^2y}{dx^2}', insert: '\\frac{d^2y}{dx^2}', title: 'Second derivative' },
    ],
  },
  {
    name: 'Integrals',
    buttons: [
      { label: '\\int',                       insert: '\\int ',                          title: 'Integral' },
      { label: '\\int_a^b',                   insert: '\\int_{#?}^{#?}',               title: 'Definite integral' },
      { label: '\\int_{-\\infty}^{\\infty}',  insert: '\\int_{-\\infty}^{\\infty}',    title: 'Improper integral' },
    ],
  },
  {
    name: 'Limits',
    buttons: [
      { label: '\\lim_{x \\to 0}',      insert: '\\lim_{x \\to 0}',      title: 'Limit as x→0' },
      { label: '\\lim_{x \\to \\infty}', insert: '\\lim_{x \\to \\infty}', title: 'Limit as x→∞' },
      { label: '\\lim_{x \\to a}',      insert: '\\lim_{x \\to a}',      title: 'Limit as x→a' },
    ],
  },
  {
    name: 'Series',
    buttons: [
      { label: '\\sum_{i=1}^{n}',  insert: '\\sum_{#?}^{#?}',  title: 'Summation' },
      { label: '\\prod_{i=1}^{n}', insert: '\\prod_{#?}^{#?}', title: 'Product' },
    ],
  },
  {
    name: 'Trig',
    buttons: [
      { label: '\\sin', insert: '\\sin ', title: 'sine' },
      { label: '\\cos', insert: '\\cos ', title: 'cosine' },
      { label: '\\tan', insert: '\\tan ', title: 'tangent' },
      { label: '\\cot', insert: '\\cot ', title: 'cotangent' },
      { label: '\\sec', insert: '\\sec ', title: 'secant' },
      { label: '\\csc', insert: '\\csc ', title: 'cosecant' },
    ],
  },
  {
    name: 'Log / Exp',
    buttons: [
      { label: '\\ln',    insert: '\\ln ',    title: 'Natural log' },
      { label: '\\log',   insert: '\\log ',   title: 'Logarithm' },
      { label: '\\log_a', insert: '\\log_{#?}', title: 'Log base a' },
      { label: 'e^x',     insert: 'e^{#?}',    title: 'Exponential' },
    ],
  },
  {
    name: 'Symbols',
    buttons: [
      { label: '\\pm',     insert: '\\pm ',     title: 'Plus-minus' },
      { label: '\\times',  insert: '\\times ',  title: 'Multiply' },
      { label: '\\div',    insert: '\\div ',    title: 'Divide' },
      { label: '\\leq',    insert: '\\leq ',    title: 'Less or equal' },
      { label: '\\geq',    insert: '\\geq ',    title: 'Greater or equal' },
      { label: '\\neq',    insert: '\\neq ',    title: 'Not equal' },
      { label: '\\approx', insert: '\\approx ', title: 'Approximately' },
      { label: '\\in',     insert: '\\in ',     title: 'Element of' },
      { label: '\\cdot',   insert: '\\cdot ',   title: 'Dot product' },
    ],
  },
]

interface Props {
  onInsert: (latex: string) => void
  className?: string
}

export function MathKeyboard({ onInsert, className }: Props) {
  return (
    <div
      className={cn(
        'rounded-xl border border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-900 p-3 flex flex-col gap-3',
        className,
      )}
    >
      {GROUPS.map((group) => (
        <div key={group.name}>
          <p className="text-[10px] font-semibold uppercase tracking-wider text-slate-400 dark:text-slate-500 mb-1.5">
            {group.name}
          </p>
          <div className="flex flex-wrap gap-1">
            {group.buttons.map((btn) => (
              <button
                key={btn.title}
                type="button"
                title={btn.title}
                onMouseDown={(e) => {
                  // Prevent the math field from losing focus when a keyboard button is clicked
                  e.preventDefault()
                  onInsert(btn.insert)
                }}
                className="inline-flex items-center justify-center min-w-[2.75rem] px-2 py-1.5 rounded-lg border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-800 hover:bg-blue-50 dark:hover:bg-slate-700 hover:border-blue-400 dark:hover:border-blue-500 transition-colors text-slate-800 dark:text-slate-200 text-sm leading-none"
              >
                <Latex>{btn.label}</Latex>
              </button>
            ))}
          </div>
        </div>
      ))}
    </div>
  )
}
