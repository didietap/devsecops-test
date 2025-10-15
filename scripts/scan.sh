#!/usr/bin/env bash
# ==============================================
# Trivy Security Scan Script - DevSecOps Platform
# ==============================================

set -e

IMAGE_NAME=${1:-"localhost:32000/backend-api:latest"}

echo "🛡 Checking Trivy installation..."
if ! command -v trivy >/dev/null 2>&1; then
    echo "⚠ Trivy is not installed."
    echo "👉 Install using: sudo apt install trivy -y"
    exit 1
fi

echo "🚀 Starting Trivy scan for image: $IMAGE_NAME"
trivy image --severity HIGH,CRITICAL --ignore-unfixed $IMAGE_NAME

echo "✅ Scan complete."
echo "📌 Recommendation: Integrate this in CI using GitHub Actions (workflow/security-scan.yaml)"
