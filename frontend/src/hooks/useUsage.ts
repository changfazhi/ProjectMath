import { useCallback, useEffect, useState } from 'react'
import { api } from '../lib/api'
import { useAuth } from '../contexts/AuthContext'
import type { UsageSummary } from '../types/api'

/**
 * Today's quota usage (scans / chat messages) for the signed-in user.
 * Call refresh() after a grading or chat send so the counters stay current;
 * the server remains authoritative — stale client state just means a 429 message.
 */
export function useUsage() {
  const { user } = useAuth()
  const [usage, setUsage] = useState<UsageSummary | null>(null)

  const refresh = useCallback(() => {
    if (!user) return
    api.usage
      .get()
      .then(setUsage)
      .catch(() => {
        /* non-critical — counters simply don't render */
      })
  }, [user])

  useEffect(() => {
    refresh()
  }, [refresh])

  return { usage, refresh }
}
