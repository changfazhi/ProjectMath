import { useEffect, useRef, useImperativeHandle, forwardRef } from 'react'
import 'mathlive'
import type { MathfieldElement } from 'mathlive'
import { isTouchDevice } from '../../lib/utils'

// Which keyboard a focused field should raise on a touch device.
//   'native' — the OS keyboard (digits and letters)
//   'math'   — no OS keyboard; our <MathKeyboard> palette supplies the LaTeX instead
export type FieldInputMode = 'native' | 'math'

export interface MathFieldHandle {
  insert: (latex: string) => void
  getValue: () => string
  focus: () => void
  setInputMode: (mode: FieldInputMode) => void
}

interface Props {
  onChange: (latex: string) => void
  disabled?: boolean
  className?: string
  // Optional LaTeX to seed the field with once, on mount (e.g. an AI transcription to edit).
  initialValue?: string
}

export const MathField = forwardRef<MathFieldHandle, Props>(
  ({ onChange, disabled = false, className, initialValue }, ref) => {
    const elRef = useRef<MathfieldElement>(null)
    // Captured once so the seed only applies on mount and never clobbers later edits.
    const initialValueRef = useRef(initialValue)
    // Survives re-renders and the shadow root not being ready yet (see applyInputMode).
    const inputModeRef = useRef<FieldInputMode>('native')

    // MathLive routes keystrokes through a hidden contenteditable in its shadow root and
    // hard-codes inputmode=none on it, so the OS keyboard never opens — it assumes its own
    // virtual keyboard (which we disable below) will serve touch devices. Flipping that
    // attribute is what lets a phone type into the field at all.
    function sinkEl(): HTMLElement | null {
      return elRef.current?.shadowRoot?.querySelector<HTMLElement>('.ML__keyboard-sink') ?? null
    }

    function applyInputMode() {
      if (!isTouchDevice()) return
      sinkEl()?.setAttribute('inputmode', inputModeRef.current === 'native' ? 'text' : 'none')
    }

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
      setInputMode(mode: FieldInputMode) {
        inputModeRef.current = mode
        if (!isTouchDevice()) return
        const mf = elRef.current
        const sink = sinkEl()
        if (!mf || !sink) return
        applyInputMode()
        // Browsers only read inputmode when an element *takes* focus, so switching it on an
        // already-focused field needs a blur/refocus to make the OS keyboard appear or drop.
        // This must stay inside the originating user gesture — a deferred focus() is ignored
        // by iOS. Focus never actually leaves, so the caret and selection survive the cycle
        // and a palette insert still lands where the student left off.
        const isFocused = mf.shadowRoot?.activeElement === sink || document.activeElement === mf
        if (isFocused) {
          mf.blur()
          mf.focus()
        }
      },
    }))

    // On mount: disable MathLive's own keyboard policy and hide its toolbar icons
    useEffect(() => {
      const mf = elRef.current
      if (!mf) return

      // 'manual' = never auto-raise MathLive's own virtual keyboard (we drive the OS keyboard
      // and our <MathKeyboard> palette instead). Was 'off', which isn't one of the accepted
      // values ('auto' | 'manual' | 'sandboxed') — it happened to behave the same only because
      // it fails MathLive's `policy === 'auto'` show-on-focus check.
      ;(mf as unknown as { mathVirtualKeyboardPolicy: string }).mathVirtualKeyboardPolicy = 'manual'
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

      // Seed the field once (setting .value does not dispatch an 'input' event, so onChange
      // stays quiet and the parent's "unchanged" baseline holds until the student actually edits).
      if (initialValueRef.current !== undefined) {
        mf.value = initialValueRef.current
      }

      // Try immediately, then retry once the element has initialised — the shadow root is not
      // reliably populated at ref time. The default mode is 'native', so the very first tap on
      // a phone raises the OS keyboard without the parent having to say anything.
      const init = () => {
        injectStyles()
        applyInputMode()
      }
      init()
      const raf = requestAnimationFrame(init)
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

    // Keep the visible field on screen once the OS keyboard opens. The browser's own
    // scroll-into-view targets MathLive's hidden `position: fixed` sink rather than this
    // element, so on touch we scroll the host ourselves after the keyboard has settled.
    useEffect(() => {
      const mf = elRef.current
      if (!mf) return
      let timer: number | undefined
      const onFocus = () => {
        if (!isTouchDevice()) return
        window.clearTimeout(timer)
        timer = window.setTimeout(
          () => mf.scrollIntoView({ block: 'center', behavior: 'smooth' }),
          300,
        )
      }
      mf.addEventListener('focusin', onFocus)
      return () => {
        window.clearTimeout(timer)
        mf.removeEventListener('focusin', onFocus)
      }
    }, [])

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
