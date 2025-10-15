# 🏗 Architecture Overview – DevSecOps MicroK8s Platform

This document provides a high-level architectural overview of the **Secure DevSecOps Platform** built on **MicroK8s Kubernetes** with **APM, ELK Stack, Secret Management, and Security Scanning Integration**.

---

## 🎯 Design Principles

| Principle | Implementation |
|-----------|--------------|
| **Immutable Infrastructure** | Automated via Makefile + Terraform + Ansible |
| **Security by Default** | Non-root containers, Trivy scan, SecurityContext in manifests |
| **Observability First** | ELK Stack with APM traces, health checks, metrics endpoint |
| **Fail Fast & Recover** | Chaos simulation via scripted `make demo-incident` |
| **Declarative & Reproducible** | All deployment steps automated, no manual kubectl apply |

---

## 🧩 System Components

| Component | Description |
|-----------|-----------|
| **MicroK8s** | Lightweight Kubernetes runtime (Ubuntu-native) |
| **Backend API (NestJS)** | Secure API with health, metrics, APM instrumentation |
| **PostgreSQL** | Stateful DB with PersistentVolume via MicroK8s hostpath |
| **ELK Stack** | Elasticsearch, Kibana, APM Server |
| **Infisical** | Centralized secret management |
| **Trivy** | Security vulnerability scanner |

---

## 🔄 Deployment Flow

```
Developer → Git Push → (Optional CI/CD) → Make Deploy → MicroK8s Apply Manifests
```

- **Secrets** are fetched from Infisical inside CI or via mounted secrets.
- **Containers** are scanned using Trivy before deployment.
- **MicroK8s** runs workloads inside namespace `devsecops`.

---

## 🌐 High-Level Architecture Diagram (Text-based)

```
                         ┌────────────────────────────┐
                         │      Developer / CLI       │
                         │  (make setup / deploy ...) │
                         └─────────────┬──────────────┘
                                       │
                                       ▼
┌────────────────────────────────────────────────────────────────────────────┐
│                             MicroK8s Cluster                               │
│ Namespace: devsecops                                                       │
│                                                                            │
│  ┌──────────────┐     ┌────────────┐      ┌─────────────┐                 │
│  │ Backend API  │◄──► │ PostgreSQL │      │ Infisical   │ (Secrets)       │
│  │  (NestJS)    │     │   Stateful │      │ (External)  │                 │
│  └──────┬───────┘     └────┬───────┘      └──────┬──────┘                 │
│         │ APM + Logs       │                        │                      │
│         ▼                  ▼                        │                      │
│   ┌────────────┐    ┌────────────┐         ┌────────────┐                 │
│   │ APM Server │→→→ │ Elasticsearch │ ←──── │ Trivy Scan │ → (CI/CD)       │
│   └────────────┘    └────────────┘         └────────────┘                 │
│            │                    ▲                                         │
│            ▼                    │                                         │
│        ┌──────────┐            │                                         │
│        │ Kibana   │ (Visual APM, Logs)                                   │
│        └──────────┘                                                      │
└────────────────────────────────────────────────────────────────────────────┘
```

---

## 📌 Next Sections (detailed in other docs)

| Document | Purpose |
|----------|--------|
| `INFRASTRUCTURE.md` | How MicroK8s, Terraform, Ansible, and storage are set up |
| `SECURITY.md` | Security policies, Trivy, TLS, RBAC, non-root configs |
| `OBSERVABILITY.md` | How APM, logging, dashboards, and alerts are wired |
| `INCIDENT.md` | Chaos simulation guide and expected recovery behavior |

---
