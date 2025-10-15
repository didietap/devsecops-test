#!/usr/bin/env bash
# ==============================================
# Monitoring Access Script - Kibana & APM
# ==============================================

set -e

NAMESPACE="devsecops"

echo "📊 Checking ELK Stack status..."

echo "🔍 Verifying pods in namespace: $NAMESPACE"
microk8s kubectl get pods -n $NAMESPACE

echo "🌐 Checking Kibana service status..."
if microk8s kubectl get svc -n $NAMESPACE | grep -q "kibana"; then
    echo "✅ Kibana detected"
    echo "📌 Attempting to forward Kibana to localhost:5601"
    microk8s kubectl port-forward svc/kibana -n $NAMESPACE 5601:5601 &
    echo "🌍 Access Kibana: http://localhost:5601"
else
    echo "⚠ Kibana service not found. Ensure ELK Stack is deployed."
fi

echo "🎯 Checking APM Server..."
if microk8s kubectl get svc -n $NAMESPACE | grep -q "apm-server"; then
    echo "✅ APM Server detected"
    echo "📌 Attempting to forward APM Server to localhost:8200"
    microk8s kubectl port-forward svc/apm-server -n $NAMESPACE 8200:8200 &
    echo "🌍 APM Endpoint: http://localhost:8200"
else
    echo "⚠ APM Server not found. Ensure APM is deployed."
fi

echo "🎉 Monitoring forwarding initialized. Use browser to access dashboards."
