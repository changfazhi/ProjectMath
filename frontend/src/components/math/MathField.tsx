import { useEffect, useRef, useImperativeHandle, forwardRef } from 'react'
import 'mathlive'
import type { MathfieldElement } from 'mathlive'

export interface MathFieldHandle {
  insert: (latex: string) => void
  getValue: () => string
  focus: () => void
}

interface Props {
  onChange: (latex: string) => void
  disabled?: boolean
  className?: string
}

export const MathField = forwardRef<MathFieldHandle, Props>(
  ({ onChange, disabled = false, className }, ref) => {
    const elRef = useRef<MathfieldElement>(null)

    useImperativeHandle(ref, () => ({
      insert(latex: string) {
        const mf = elRef.current
        if (!mf) return
        mf.focus()
        mf.insert(latex, {
          focus: true,
          feedback: false,
          mode: 'math',
          selectionMode: 'placeholder',
        })
      },
      getValue() {
        return elRef.current?.value ?? ''
      },
      focus() {
        elRef.current?.focus()
      },
    }))

    // On mount: disable MathLive's own keyboard policy and hide its toolbar icons
    useEffect(() => {
      const mf = elRef.current
      if (!mf) return

      ;(mf as MathfieldElement & { mathVirtualKeyboardPolicy: string }).mathVirtualKeyboardPolicy = 'off'
      ;(mf as MathfieldElement & { menuItems: unknown[] }).menuItems = []

      // Remove built-in "or" → \lor and "and" → \land shortcuts — they trigger
      // a suggestion box and leave the cursor in a broken state afterward.
      const shortcuts = { ...(mf as MathfieldElement & { inlineShortcuts: Record<string, string> }).inlineShortcuts }
      delete shortcuts['or']
      delete shortcuts['and']
      ;(mf as MathfieldElement & { inlineShortcuts: Record<string, string> }).inlineShortcuts = shortcuts

      // Insert a thin space on space key instead of jumping the cursor (moveAfterParent).
      ;(mf as MathfieldElement & { mathModeSpace: string }).mathModeSpace = '\\,'

      // MathLive renders toolbar icons into shadow DOM as non-button elements,
      // so we inject a <style> to suppress them after the shadow root is populated.
      const injectStyles = () => {
        const shadow = mf.shadowRoot
        if (!shadow) return
        const existing = shadow.getElementById('ml-toolbar-hide')
        if (existing) return
        const style = document.createElement('style')
        style.id = 'ml-toolbar-hide'
        style.textContent = `
          .ML__virtual-keyboard-toggle,
          [part="virtual-keyboard-toggle"],
          .ML__menu-toggle,
          [part="menu-toggle"],
          .ML__toolbar { display: none !important; }
        `
        shadow.appendChild(style)
      }

      // Try immediately, then retry once the element has initialised
      injectStyles()
      const raf = requestAnimationFrame(injectStyles)
      return () => cancelAnimationFrame(raf)
    }, [])

    // Sync disabled / read-only state
    useEffect(() => {
      const mf = elRef.current
      if (!mf) return
      if (disabled) {
        mf.setAttribute('read-only', '')
      } else {
        mf.removeAttribute('read-only')
      }
    }, [disabled])

    // Forward input events to parent onChange
    useEffect(() => {
      const mf = elRef.current
      if (!mf) return
      const handler = () => onChange(mf.value)
      mf.addEventListener('input', handler)
      return () => mf.removeEventListener('input', handler)
    }, [onChange])

    return (
      // @ts-expect-error — MathfieldElement ref type doesn't extend HTMLElement cleanly
      <math-field
        ref={elRef}
        class={className}
        style={{
          display: 'block',
          width: '100%',
          padding: '12px 16px',
          minHeight: '3rem',
          borderRadius: '0.75rem',
          border: '1px solid',
          fontSize: '1.1rem',
          outline: 'none',
          opacity: disabled ? 0.5 : 1,
          cursor: disabled ? 'not-allowed' : 'text',
        }}
      />
    )
  },
)

MathField.displayName = 'MathField'
