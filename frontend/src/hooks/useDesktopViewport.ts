import { useEffect, useState } from 'react'

// The viewport we hand back when a route stops asking for a fixed-width one. Kept in sync
// with the tag in `index.html` — no `maximum-scale`/`user-scalable=no`, so pinch-zoom is
// always available everywhere in the app.
const DEVICE_VIEWPORT = 'width=device-width, initial-scale=1.0'

// Safari only re-runs viewport adaptation reliably when the meta element itself is replaced,
// so swap the node rather than mutate `content` in place.
function writeViewport(content: string) {
  document.head.querySelector('meta[name="viewport"]')?.remove()
  const meta = document.createElement('meta')
  meta.name = 'viewport'
  meta.content = content
  document.head.appendChild(meta)
}

/**
 * Lays the current route out in a fixed-width viewport instead of the device's own, for as
 * long as the component is mounted.
 *
 * The marketing landing page is a bespoke fixed-width desktop design — 1180px content
 * columns, absolutely-positioned floating cards, pixel font sizes, no breakpoints. Laid out
 * into a `width=device-width` viewport on a phone it collapses: the two-column grids squeeze
 * to ~150px so every heading wraps one word per line, and the wide hero/feature cards get
 * clipped. Giving the browser a fixed layout viewport instead makes it lay the page out
 * exactly as a desktop would and shrink-to-fit the result, so a phone shows the real design,
 * zoomable and laterally scrollable with the platform's own gestures — no custom pan/zoom.
 *
 * Pass `null` to suspend it, e.g. while a modal sized for the device viewport is open; the
 * previous viewport is restored and re-applied when the argument goes back to a width.
 *
 * Returns whether the fixed viewport is currently in force, so the caller can keep any layout
 * that depends on it (a `min-width`, say) in step. It must not outlive the viewport: a page
 * left wider than the screen keeps the layout viewport wide too, and on mobile a `fixed`
 * element's containing block is the *layout* viewport — so an overlay meant to cover the
 * screen would instead be laid out across the whole zoomed-out page and centre itself
 * off-screen.
 */
export function useDesktopViewport(width: number | null): boolean {
  const [active, setActive] = useState(false)

  useEffect(() => {
    if (width == null) return
    // A viewport already at least as wide as the design needs no help — and desktop browsers
    // ignore the meta tag outright, so the tag itself is a no-op there either way. (A desktop
    // window narrower than the design does fall through, and gets the `min-width` that makes
    // the page scroll sideways rather than collapse.)
    if (document.documentElement.clientWidth >= width) return

    const previous =
      document.head.querySelector('meta[name="viewport"]')?.getAttribute('content') ?? DEVICE_VIEWPORT

    // Only `width` is given so the browser picks the initial scale that fits the layout
    // viewport on screen. `minimum-scale` has to sit below that shrink-to-fit ratio (≈0.26 on
    // a 320px phone) or the page opens cropped at the clamped scale instead of fitted.
    writeViewport(`width=${width}, minimum-scale=0.1, user-scalable=yes`)
    setActive(true)
    return () => {
      writeViewport(previous)
      setActive(false)
    }
  }, [width])

  return active
}
