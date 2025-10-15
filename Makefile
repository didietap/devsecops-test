# ================================
# DevSecOps Test - Makefile Skeleton
# MicroK8s-based Kubernetes Platform
# ================================

SHELL := /bin/bash

# Variables
MICROK8S = microk8s
KUBECTL = microk8s kubectl

# --------------------------------
# ✅ Setup MicroK8s Environment
# --------------------------------
.PHONY: setup
setup:
	@echo "🚀 Setting up MicroK8s environment..."
	chmod +x scripts/setup_microk8s.sh
	sudo scripts/setup_microk8s.sh

# --------------------------------
# 🚀 Deployment Commands
# --------------------------------
.PHONY: deploy
deploy:
	@echo "🚀 Deploying application stacks (Backend + PostgreSQL + ELK)..."
	chmod +x scripts/deploy.sh
	bash scripts/deploy.sh

.PHONY: monitor
monitor:
	@echo "📊 Opening monitoring dashboards..."
	chmod +x scripts/monitor.sh
	bash scripts/monitor.sh

# --------------------------------
# 🛡 Security Commands
# --------------------------------
.PHONY: scan
scan:
	@echo "🛡 Running Trivy Security Scan..."
	chmod +x scripts/scan.sh
	bash scripts/scan.sh

# --------------------------------
# ⚠ Incident Simulation
# --------------------------------
.PHONY: demo-incident
demo-incident:
	@echo "🔥 Running incident simulation..."
	chmod +x scripts/incident_simulation.sh
	bash scripts/incident_simulation.sh

# --------------------------------
# 🧹 Cleanup Commands
# --------------------------------
.PHONY: clean
clean:
	@echo "🧹 Cleaning up deployments..."
	$(KUBECTL) delete all --all --force --grace-period=0

# --------------------------------
# 💡 Utilities
# --------------------------------
.PHONY: status
status:
	@echo "📌 MicroK8s Status:"
	sudo $(MICROK8S) status

.PHONY: logs
logs:
	@echo "📜 Tail logs (MicroK8s systemd)"
	journalctl -u snap.microk8s.daemon-kubelet -f
