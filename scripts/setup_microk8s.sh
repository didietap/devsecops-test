#!/usr/bin/env bash
# ==============================================
# MicroK8s Setup Script - DevSecOps Platform
# ==============================================

set -e

echo "🚀 Checking MicroK8s installation..."
if ! command -v microk8s >/dev/null 2>&1; then
    echo "📦 Installing MicroK8s..."
    sudo snap install microk8s --classic --channel=1.30/stable
else
    echo "✅ MicroK8s already installed"
fi

echo "👤 Adding current user to microk8s group..."
sudo usermod -aG microk8s $USER
sudo chown -f -R $USER ~/.kube || true

echo "🔄 Enabling MicroK8s addons..."
sudo microk8s enable dns storage ingress registry metrics-server

echo "⏳ Waiting for MicroK8s to be ready..."
sudo microk8s status --wait-ready

echo "🔁 Enabling kubectl alias..."
sudo snap alias microk8s.kubectl kubectl || true

echo "🔧 Verifying cluster nodes..."
microk8s kubectl get nodes

echo "✅ MicroK8s setup completed successfully!"
echo "👉 You may need to log out and log back in for group changes to apply"
