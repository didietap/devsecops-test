#!/usr/bin/env bash
# ==============================================
# Fetch Secrets from Infisical
# ==============================================

set -e

if [ ! -f /secrets/.machine.infisical.json ]; then
  echo "❌ Machine identity not found at /secrets/.machine.infisical.json"
  exit 1
fi

echo "🔐 Fetching secrets from Infisical..."

# Example API call (adjust URL and workspace ID)
curl -s -X GET "https://app.infisical.com/api/v1/secrets?environment=dev" \
  -H "Content-Type: application/json" \
  --header "Authorization: Bearer $(jq -r .machine_token /secrets/.machine.infisical.json)" \
  | jq -r '.secrets[] | "\(.key)=\(.value)"' > /secrets/.env

echo "✅ Secrets written to /secrets/.env"
