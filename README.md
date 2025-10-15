# DevSecOps Test – Secure MicroK8s Platform with Observability & Incident Simulation

This repository is part of a comprehensive **DevSecOps Architecture & Implementation Test**.  
The goal is to **design, automate, secure, monitor, and simulate failure scenarios** on a **MicroK8s-based Kubernetes environment** using modern DevSecOps practices.

---

## 🎯 Objectives

- ✅ Build a secure Kubernetes deployment using **MicroK8s**
- ✅ Automate infrastructure and application deployment using **Makefile, Bash scripts, Terraform, and Ansible**
- ✅ Implement **Security Scanning** using Trivy and supply chain best practices
- ✅ Enable **Observability & APM** using ELK Stack (Elasticsearch, Logstash, Kibana)
- ✅ Deploy a **secure NestJS API** with health checks, metrics, tracing, and proper security headers
- ✅ Integrate with **Infisical Secret Management**
- ✅ Provide **Incident Simulation & Recovery Scripts**

---

## 📌 Tech Stack Overview

| Layer               | Tools & Technology |
|-------------------|-------------------|
| Container Runtime  | Docker / MicroK8s |
| Infrastructure     | Bash, Makefile, Terraform, Ansible |
| Backend API        | NestJS (Node.js) |
| Security Scanning  | Trivy |
| Observability      | Elasticsearch, Kibana, APM |
| Secret Management  | Infisical |
| Incident Simulation| Custom Bash Tools |

---

## 🚀 Quickstart Commands

| Command | Description |
|---------|------------|
| `make setup` | Install and configure MicroK8s environment |
| `make deploy` | Deploy backend, PostgreSQL, and ELK Stack |
| `make monitor` | Open Kibana / APM dashboard |
| `make scan` | Run Trivy image scan |
| `make demo-incident` | Trigger incident simulation |

---

## 📂 Repository Structure (initial phase)

```
devsecops-test/
├── README.md
├── Makefile
├── ARCHITECTURE.md
├── INFRASTRUCTURE.md
├── SECURITY.md
├── OBSERVABILITY.md
├── INCIDENT.md
├── scripts/
├── backend/
└── infra/
```



