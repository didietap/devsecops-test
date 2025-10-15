# 🚀 Backend API – Build & Deploy Guide (MicroK8s Environment)

This backend service is built using **NestJS**, designed with **APM, health checks, metrics, and secure Docker practices**.  
This guide explains how to **build, tag, and deploy** the backend image into **MicroK8s local registry (`localhost:32000`)**.

---

## ✅ Requirements

Ensure the following are installed on your machine:

| Tool | Version | Check |
|------|--------|-------|
| Node.js | v18 or v20 | `node -v` |
| npm | ≥ 8.x | `npm -v` |
| Docker | latest | `docker -v` |
| MicroK8s | installed & registry enabled | `microk8s status` |

> MicroK8s registry should be available at: **`localhost:32000`**

---

## 📦 Install Dependencies & Build

```bash
cd backend
npm ci
npm run build
```

---

## 🛠 Docker Image Build (Multi-Stage, Hardened)

```bash
# Build image
docker build -t localhost:32000/backend-api:latest -f Dockerfile .

# Verify image
docker images | grep backend-api
```

---

## 📤 Push to MicroK8s Internal Registry (Method A – Preferred)

```bash
docker push localhost:32000/backend-api:latest
```

> If push fails with **insecure registry error**, enable insecure registry in Docker daemon or use **Method B** below.

---

## 📥 Load Image into MicroK8s Containerd (Method B – Offline / Airgap)

```bash
# Save image to tar archive
docker save localhost:32000/backend-api:latest -o backend-api.tar

# Import via MicroK8s
microk8s ctr image import backend-api.tar

# Check image is available
microk8s ctr images ls | grep backend
```

---

## 🚀 Deploy to MicroK8s

```bash
# Ensure namespace exists
microk8s kubectl apply -f k8s/namespace.yaml

# Apply deployment
microk8s kubectl apply -f k8s/deployment.yaml

# Watch pods
microk8s kubectl get pods -n devsecops -w
```

---

## 🔍 Test Health & Metrics

After pod is running, forward port:

```bash
microk8s kubectl port-forward svc/backend-api -n devsecops 3000:3000
```

Then access:

| Endpoint | Description |
|----------|------------|
| `http://localhost:3000/health` | Service health check |
| `http://localhost:3000/ready` | Readiness check |
| `http://localhost:3000/metrics` | Prometheus metrics |
| `APM auto-trace` | Visible after APM Server is deployed |

---

## 💡 Notes

- By default, **APM is optional**. It auto-enables when `ELASTIC_APM_SERVER_URL` is provided.
- All logs include **`x-request-id` correlation ID** for traceability.
- **Image runs as non-root user (UID 1001)** for security compliance.

---
