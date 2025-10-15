# 🏗 Infrastructure Provisioning – MicroK8s DevSecOps Platform

This document describes how the infrastructure is provisioned, automated, and maintained using **Makefile, Bash, Terraform, and Ansible** on a **MicroK8s environment**.

---

## 🧭 Provisioning Strategy Overview

| Layer | Tool | Responsibility |
|-------|------|--------------|
| Base Kubernetes Runtime | MicroK8s | Cluster runtime, storage, ingress, metrics |
| Orchestration & Automation | Makefile + Bash | Declarative task runner |
| Declarative Infrastructure | Terraform (planned) | Network & volumes (if extended to cloud) |
| Configuration Management | Ansible (planned) | Optional host hardening and sysctl rules |
| Kubernetes Deployments | YAML Manifests | Stateless + Stateful service definitions |

---

## ⚙ MicroK8s Setup

Setup is performed via:

```
make setup
```

Which runs:

```
scripts/setup_microk8s.sh
```

This script ensures:

- MicroK8s is installed (snap-based)
- Current user is added to `microk8s` group
- Addons enabled:
  - `dns` – service discovery
  - `storage` – dynamic PVC support
  - `ingress` – external access
  - `registry` – local container registry `localhost:32000`
  - `metrics-server` – required for APM and HPA telemetry
- Kubectl alias enabled (`kubectl` → `microk8s kubectl`)

---

## 📁 Directory: `infra/`

```
infra/
├── terraform/           # (Planned) Cloud or hybrid infra resources
├── ansible/             # (Planned) Host hardening and config enforcement
├── k8s-manifests/
│   ├── backend/
│   ├── postgresql/
│   ├── ingress/
│   └── storage/
└── storage/             # Local PV definitions (if using static provisioning)
```

> The manifest folders will be filled in **Phase 2 & 3** when services are deployed.

---

## 📌 MicroK8s Storage Strategy

Two options available:

| Mode | Description | Status |
|------|-------------|--------|
| **Dynamic (default)** | Uses `microk8s-hostpath` provisioner | ✅ Enabled |
| **Static (optional)** | PV + PVC manually created in `infra/storage/` | Planned |

---

## 🚀 Deployment Trigger

Infrastructure-level deployment is initiated via:

```
make deploy
```

Which triggers:

```
scripts/deploy.sh
```

That will include applying manifests located in `infra/k8s-manifests/**`. In later phases, this deployment script will be extended to:

- Deploy PostgreSQL using StatefulSet
- Deploy Backend with health + readiness probes
- Deploy ELK Stack components
- Apply Ingress resources for dashboard access

---

## 🧾 Future Extension: Terraform/Ansible Integration

Although this environment is **local-first using MicroK8s**, we plan to include optional cloud-ready Terraform and Ansible modules:

| Tool | Purpose | Status |
|------|--------|--------|
| Terraform | VPC/network + storage class + cloud registry | Planned |
| Ansible | SSH host hardening, UFW firewall, Docker daemon policies | Planned |

> These modules will be optional, enabled via `make infra` toggle in later phase.

---
