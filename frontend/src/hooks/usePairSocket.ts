import { useEffect, useRef, useState } from 'react'
import { getSocket } from '../lib/socket'
import type { GradeResponse } from '../types/api'

interface Handlers {
  onGradingStart?: () => void
  onGraded?: (grading: GradeResponse) => void
  onGradingError?: (message: string) => void
}

export interface PairSocketState {
  phoneConnected: boolean
  images: string[] // dataURLs streamed from the phone, in arrival order
  grading: boolean
  error: string | null
}

// Subscribes the desktop to a pairing token's room and surfaces the live events the
// phone triggers. Grading start/result are forwarded to the practice state machine via handlers.
export function usePairSocket(token: string | null, handlers: Handlers = {}): PairSocketState {
  const [phoneConnected, setPhoneConnected] = useState(false)
  const [images, setImages] = useState<string[]>([])
  const [grading, setGrading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  // Keep handlers in a ref so changing them doesn't tear down the subscription.
  const handlersRef = useRef(handlers)
  handlersRef.current = handlers

  useEffect(() => {
    if (!token) return
    const socket = getSocket()

    // Reset state for a fresh pairing.
    setPhoneConnected(false)
    setImages([])
    setGrading(false)
    setError(null)

    const onConnected = () => setPhoneConnected(true)
    const onImage = (p: { index: number; dataUrl: string }) => {
      setPhoneConnected(true)
      setImages((prev) => [...prev, p.dataUrl])
    }
    const onGrading = () => {
      setGrading(true)
      handlersRef.current.onGradingStart?.()
    }
    const onGraded = (p: { grading: GradeResponse }) => {
      setGrading(false)
      handlersRef.current.onGraded?.(p.grading)
    }
    const onError = (p: { message: string }) => {
      setGrading(false)
      setError(p.message)
      handlersRef.current.onGradingError?.(p.message)
    }

    socket.emit('pair:subscribe', { token })
    socket.on('pair:phone-connected', onConnected)
    socket.on('pair:image', onImage)
    socket.on('pair:grading', onGrading)
    socket.on('pair:graded', onGraded)
    socket.on('pair:error', onError)

    return () => {
      socket.emit('pair:unsubscribe', { token })
      socket.off('pair:phone-connected', onConnected)
      socket.off('pair:image', onImage)
      socket.off('pair:grading', onGrading)
      socket.off('pair:graded', onGraded)
      socket.off('pair:error', onError)
    }
  }, [token])

  return { phoneConnected, images, grading, error }
}
