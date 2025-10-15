# ⚠ Incident Simulation & Recovery Guide – DevSecOps Platform

This document explains how incidents are intentionally triggered to **validate resilience, observability, and automated recovery behavior** of the platform.

---

## 🎯 Purpose of Incident Simulation

| Objective | Expected Outcome |
|-----------|-----------------|
| Validate Kubernetes self-healing | Pods restart automatically |
| Verify observability effectiveness | Errors appear in Kibana/APM |
| Test DB dependency resilience | Backend returns proper error status |
| Validate alerting flow (if configured) | Dashboard reflects incident timeline |

---

## ⚙ Executing Incident Tests

Run:

```
make demo-incident
```

Which triggers:

```
scripts/incident_simulation.sh
```

---

## 🔁 Available Incident Scenarios

| Scenario | Command Triggered | Expected Behavior |
|----------|------------------|------------------|
| Kill Backend API pod | `kubectl delete pod ...` | Pod restarts automatically |
| Kill PostgreSQL pod | `kubectl delete pod ...` | Backend throws DB errors in APM logs |
| Scale backend to zero | `kubectl scale ... --replicas=0` | Endpoint becomes unreachable |
| Restart MicroK8s control plane | `systemctl restart` | API temporarily unavailable |
| Force DB offline | `kubectl scale statefulset ... --replicas=0` | DB connection errors visible |
| Stress CPU (optional) | `stress-ng` | Node-level resource spike in metrics |

---

## 📊 Observability Expectations

| Component | What to monitor |
|-----------|----------------|
| 🟢 **Kubernetes** | Pod restart count, event logs |
| 🟡 **Backend APM** | Spike in error traces and latency |
| 🔴 **Elasticsearch/Kibana** | Incident timeline dashboards |
| 🔐 **Security Logs** | Auth failures, Trivy scan logs (if triggered during incident) |

---

## 🎛 Example Dashboards (Planned)

| Dashboard | Description |
|-----------|------------|
| **Incident Timeline Dashboard** | Sequence of pod restarts + DB down events |
| **Error Tracking View** | Shows HTTP 5xx spikes over time |
| **APM Service Map** | Visual dependency graph highlighting failure point |

---

## 🔄 Recovery Checklist

| Step | Verification |
|------|------------|
| Pod restarts automatically | `kubectl get pods -w` |
| Backend recovers after DB restored | Call `/health` and `/ready` endpoints |
| APM stops receiving new errors | Check APM traces after incident |
| Persistent storage not corrupted | PostgreSQL data remains after restart |

---

## 📌 Integration with Documentation

After each incident demo, screenshots / logs can be captured and added to `monitoring/dashboards/incident-report/`.

> This allows documenting resilience validation as **audit-proof evidence** for DevSecOps process maturity.

---
