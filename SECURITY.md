# 🛡 Security Design & Controls – DevSecOps Platform

This document outlines the **security strategy** for the MicroK8s-based DevSecOps environment, covering image scanning, Kubernetes security policies, secret management, and runtime enforcement.

---

## 🎯 Security Objectives

| Goal | Implementation |
|------|--------------|
| **Shift Left Security** | Vulnerability scanning before deployment using `Trivy` |
| **Secure Container Runtime** | Non-root containers, controlled capabilities |
| **Network & Access Control** | Kubernetes namespace isolation + RBAC |
| **Secure Secret Handling** | Externalize secrets using **Infisical** |
| **Observability Integration** | Security events forwarded to APM/Elastic Stack |

---

## 🔍 Image Scanning (Trivy)

Security scanning is triggered with:

```
make scan
```

Which runs:

```
scripts/scan.sh
```

Trivy checks for:
- **HIGH + CRITICAL** CVEs only (ignore low/noise)
- Keeps **`--ignore-unfixed`** to focus on actionable issues

> Future CI/CD integration planned via `.github/workflows/security-scan.yaml`

---

## 🚫 Dockerfile Hardening Policy

- ✅ Must use **multi-stage build**
- ✅ Must **set non-root user**: `USER node` or `USER app`
- ❌ Do **NOT** use: `apt install curl wget ...` in final image
- ✅ Add `HEALTHCHECK`
- ✅ Restrict filesystem access to `/app` only

Example enforcement (to apply in backend Dockerfile):

```
USER 1001
RUN chown -R 1001:1001 /app
```

---

## 🔐 Secrets Management (Infisical)

- `.machine.infisical.json` contains **machine identity credentials**
- Backend deployments **must not use Kubernetes Secrets directly**
- Deployment flow:
  1. Pod starts → fetch secret from Infisical via API or sidecar
  2. APM/DB credentials injected just-in-time
  3. No static `.env` file embedded

> ✅ Infisical will replace `.env` assignment in NestJS using SDK or init script

---

## ⚙ Kubernetes Runtime Security

| Control | Status |
|---------|--------|
| **Namespace Isolation (`devsecops`)** | ✅ |
| **Pod Security (non-root, read-only FS)** | Planned |
| **RBAC Per Deployment** | Planned |
| **NetworkPolicy (restrict DB access)** | Planned |
| **Resource Limits (CPU/memory)** | Planned |
| **TLS Ingress** | Planned (via MicroK8s `ingress + cert-manager`) |

---

## 🚨 Security Observability

Security-related messages from:
- Trivy scan
- Failed auth attempts in backend/API
- Pod restarts due to probe failures
- Unauthorized access attempts (RBAC errors)

→ Will be shipped to **Elasticsearch** and visualized in **Kibana (Security Dashboard)**

> A custom dashboard will be imported under `monitoring/dashboards/security.json` in later phase.

---

## 🧾 Audit & Compliance Notes

- All deployments logged via `microk8s kubectl apply -f`
- Future CI/CD integration will enforce signed commits + policy validation
- Planned integration: **OPA Gatekeeper or Kyverno** for policy-based admission control

---
