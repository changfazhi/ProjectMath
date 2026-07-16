#!/usr/bin/env bash
# Redeploy math-trainer to Cloud Run from the current working tree.
#
# Env vars and secrets are configured ON THE SERVICE (set during the initial
# deploy) and persist across revisions, so this script only rebuilds the image
# and rolls out the new code — it never needs backend/.env.
#
# The load-bearing scaling flags are re-asserted every deploy so they can't
# silently drift (max-instances=1 keeps in-memory pairing/rate-limit state
# correct; no-cpu-throttling keeps the daily cron alive; session-affinity
# pins a client to one instance). --min-instances is intentionally omitted so
# whatever you've set (0 or 1) is preserved.
#
# Usage:  bash scripts/deploy.sh
set -euo pipefail

REGION="asia-southeast1"
SERVICE="math-trainer"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

gcloud run deploy "$SERVICE" \
  --source "$REPO_ROOT" \
  --region "$REGION" \
  --max-instances=1 \
  --session-affinity \
  --no-cpu-throttling \
  --quiet
