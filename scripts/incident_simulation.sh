#!/usr/bin/env bash
# ==============================================
# Incident Simulation Script - DevSecOps Platform
# ==============================================

set -e

NAMESPACE="devsecops"

echo "🔥 DevSecOps Incident Simulation Menu"
echo "-----------------------------------------"
echo "1) Kill Backend API pod"
echo "2) Kill PostgreSQL pod"
echo "3) Scale Backend to zero (simulate service down)"
echo "4) Restart MicroK8s service (control plane disruption)"
echo "5) Simulate DB failure via scale down"
echo "6) (Optional) Trigger stress test CPU spike (requires stress-ng)"
echo "-----------------------------------------"
read -p "Select an action [1-6]: " ACTION

case $ACTION in
    1)
        echo "💥 Killing Backend API pod..."
        POD=$(microk8s kubectl get pods -n $NAMESPACE -l app=backend-api -o jsonpath="{.items[0].metadata.name}")
        microk8s kubectl delete pod $POD -n $NAMESPACE
        echo "✅ Pod terminated. Check if it auto-restarts (K8s self-heal)"
        ;;
    2)
        echo "💥 Killing PostgreSQL pod..."
        POD=$(microk8s kubectl get pods -n $NAMESPACE -l app=postgres -o jsonpath="{.items[0].metadata.name}")
        microk8s kubectl delete pod $POD -n $NAMESPACE
        echo "✅ Postgres pod terminated. Observability should show DB error traces."
        ;;
    3)
        echo "🔻 Scaling backend to zero replicas..."
        microk8s kubectl scale deployment backend-api -n $NAMESPACE --replicas=0
        echo "✅ Backend scaled to zero. Clients should receive 503/connection refused."
        ;;
    4)
        echo "⚠ Restarting MicroK8s service..."
        sudo systemctl restart snap.microk8s.daemon-apiserver
        echo "✅ MicroK8s control plane restarted. API should be temporarily down."
        ;;
    5)
        echo "🔻 Scaling PostgreSQL to zero replicas (simulate DB offline)..."
        microk8s kubectl scale statefulset postgres -n $NAMESPACE --replicas=0
        echo "✅ PostgreSQL scaled down. Backend should show DB connection failure."
        ;;
    6)
        echo "🔥 CPU spike simulation (requires 'stress-ng')..."
        if ! command -v stress-ng >/dev/null 2>&1; then
            echo "⚠ stress-ng not found. Install via: sudo apt install stress-ng"
            exit 1
        fi
        echo "🚀 Running CPU stress for 30s..."
        sudo stress-ng --cpu 2 --timeout 30s
        echo "✅ CPU spike simulation complete."
        ;;
    *)
        echo "❌ Invalid option."
        exit 1
        ;;
esac

echo "🎯 Incident simulation finished. Check APM/Kibana traces for errors."
