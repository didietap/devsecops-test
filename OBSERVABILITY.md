# 📊 Observability Strategy – DevSecOps Platform

This document defines the **monitoring, logging, tracing, and dashboard visibility strategy** for the DevSecOps platform running on **MicroK8s**.

---

## 🎯 Observability Goals

| Goal | Implementation |
|------|--------------|
| **Real-time Failure Detection** | Health checks (`/health`, `/ready`) & APM alerts |
| **Performance Insight** | APM traces integrated into NestJS backend |
| **Centralized Log Collection** | Elasticsearch (MicroK8s-hosted) |
| **Service Behavior Insight** | Metrics endpoint `/metrics` for Prometheus-style scraping |
| **Visual Dashboard** | Kibana for APM + custom dashboards |

---

## 🧩 Observability Components

| Component | Purpose |
|-----------|--------|
| **Elasticsearch** | Stores logs and trace data |
| **Kibana** | Visual interface for dashboards |
| **APM Server** | Collects traces from backend |
| **NestJS APM Agent** | Sends telemetry from API calls |
| **MicroK8s Metrics Server** | Enables HPA + resource monitoring |

---

## 🚦 Health & Metrics Endpoints

The backend will expose:

| Endpoint | Purpose |
|----------|--------|
| `/health` | Basic service health check |
| `/ready` | Readiness probe for Kubernetes |
| `/metrics` | HTTP metrics for monitoring |
| `APM auto-instrumentation` | Deep telemetry via Elastic APM |

> These endpoints will be used in Kubernetes `livenessProbe` and `readinessProbe`.

---

## 🔍 Log & Trace Flow

```
Backend API (NestJS) 
    └──→ Elastic APM Agent
           └──→ APM Server (MicroK8s svc/apm-server)
                   └──→ Elasticsearch (index: apm-*)
                          └──→ Kibana Dashboard (/app/apm/services)
```

---

## 🎛 Access Flow

### Local Kibana Access

```
make monitor
```

This will port-forward:

| Service | Port | Access |
|---------|------|--------|
| Kibana | `5601` | http://localhost:5601 |
| APM Server | `8200` | http://localhost:8200 |

---

## 📈 Dashboard Plan

| Dashboard Type | Description | Export File |
|---------------|------------|------------|
| **APM Service View** | Auto-generated via Elastic APM | Built-in |
| **Backend Error Rate View** | Filter 5xx responses | Planned |
| **Incident View** | Shows pod kills / DB down correlation | `monitoring/dashboards/incident.json` (planned) |
| **Security Scan Dashboard** | Pulls Trivy output index | Planned |

---

## 🛠 Logs & Metrics Verification Checklist

| Check | Command |
|-------|--------|
| Check pods | `microk8s kubectl get pods -n devsecops` |
| Check logs backend | `microk8s kubectl logs deploy/backend-api -n devsecops` |
| Check APM index | `curl localhost:9200/_cat/indices` |
| Open Kibana | http://localhost:5601 |

---
