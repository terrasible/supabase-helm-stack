# Supabase Helm Stack Makefile
# Provides convenient commands for development, testing, and maintenance

.PHONY: help lint test install uninstall clean docs deps security

# Default target
help: ## Show this help message
	@echo "Supabase Helm Stack - Development Commands"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# Variables
CHART_NAME := supabase
CHART_PATH := ./charts/$(CHART_NAME)
NAMESPACE := supabase
RELEASE_NAME := supabase-stack
KUBE_VERSION := 1.28.0

# Helm and Kubernetes tools
HELM := helm
KUBECTL := kubectl
KUBEVAL := kubeval
HELM_DOCS := helm-docs

# Development targets
lint: ## Lint the Helm chart
	@echo "🔍 Linting Helm chart..."
	$(HELM) lint $(CHART_PATH)
	@echo "✅ Helm lint completed"

template: ## Generate Kubernetes manifests from the chart
	@echo "📝 Generating templates..."
	$(HELM) template $(RELEASE_NAME) $(CHART_PATH) --debug

dry-run: ## Perform a dry-run installation
	@echo "🧪 Performing dry-run installation..."
	$(HELM) install $(RELEASE_NAME) $(CHART_PATH) --dry-run --debug --namespace $(NAMESPACE)

validate: ## Validate generated manifests against Kubernetes schemas
	@echo "✅ Validating Kubernetes manifests..."
	$(HELM) template $(RELEASE_NAME) $(CHART_PATH) | $(KUBEVAL) --kubernetes-version $(KUBE_VERSION)

test: lint template dry-run validate ## Run all tests
	@echo "🎉 All tests passed!"

# Installation targets
install: ## Install the chart
	@echo "🚀 Installing Supabase Helm Stack..."
	$(KUBECTL) create namespace $(NAMESPACE) --dry-run=client -o yaml | $(KUBECTL) apply -f -
	$(HELM) install $(RELEASE_NAME) $(CHART_PATH) --namespace $(NAMESPACE) --wait
	@echo "✅ Installation completed"

upgrade: ## Upgrade the chart
	@echo "⬆️ Upgrading Supabase Helm Stack..."
	$(HELM) upgrade $(RELEASE_NAME) $(CHART_PATH) --namespace $(NAMESPACE) --wait
	@echo "✅ Upgrade completed"

uninstall: ## Uninstall the chart
	@echo "🗑️ Uninstalling Supabase Helm Stack..."
	$(HELM) uninstall $(RELEASE_NAME) --namespace $(NAMESPACE)
	@echo "✅ Uninstallation completed"

status: ## Show the status of the release
	$(HELM) status $(RELEASE_NAME) --namespace $(NAMESPACE)

# Testing targets
helm-test: ## Run Helm tests
	@echo "🧪 Running Helm tests..."
	$(HELM) test $(RELEASE_NAME) --namespace $(NAMESPACE)

integration-test: ## Run integration tests (requires running cluster)
	@echo "🔧 Running integration tests..."
	@echo "Checking if all pods are ready..."
	$(KUBECTL) wait --for=condition=ready pod -l app.kubernetes.io/instance=$(RELEASE_NAME) --namespace $(NAMESPACE) --timeout=300s
	@echo "Running connectivity tests..."
	$(KUBECTL) run test-pod --image=curlimages/curl --rm -i --restart=Never --namespace $(NAMESPACE) -- curl -f http://$(RELEASE_NAME)-kong:8000/health

# Documentation targets
docs: ## Generate documentation
	@echo "📚 Generating documentation..."
	$(HELM_DOCS) --chart-search-root=charts
	@echo "✅ Documentation generated"

# Dependency management
deps: ## Update chart dependencies
	@echo "📦 Updating dependencies..."
	$(HELM) dependency update $(CHART_PATH)
	@echo "✅ Dependencies updated"

deps-build: ## Build chart dependencies
	@echo "🔨 Building dependencies..."
	$(HELM) dependency build $(CHART_PATH)

# Security targets
security-scan: ## Run security scans on the chart
	@echo "🔒 Running security scans..."
	@if command -v trivy >/dev/null 2>&1; then \
		echo "Running Trivy scan..."; \
		trivy config $(CHART_PATH); \
	else \
		echo "Trivy not found, skipping security scan"; \
	fi

# Package and release targets
package: ## Package the chart
	@echo "📦 Packaging chart..."
	$(HELM) package $(CHART_PATH) --destination ./dist
	@echo "✅ Chart packaged"

release: package ## Create a release (requires proper versioning)
	@echo "🚀 Creating release..."
	@echo "Please ensure version is updated in Chart.yaml before releasing"

# Cleanup targets
clean: ## Clean up generated files
	@echo "🧹 Cleaning up..."
	rm -rf ./dist
	rm -rf $(CHART_PATH)/charts/*.tgz
	rm -rf $(CHART_PATH)/Chart.lock
	@echo "✅ Cleanup completed"

# Development environment
dev-setup: ## Set up development environment
	@echo "🛠️ Setting up development environment..."
	@echo "Checking required tools..."
	@command -v $(HELM) >/dev/null 2>&1 || { echo "Helm is required but not installed. Please install Helm."; exit 1; }
	@command -v $(KUBECTL) >/dev/null 2>&1 || { echo "kubectl is required but not installed. Please install kubectl."; exit 1; }
	@echo "Installing helm-docs..."
	@if ! command -v $(HELM_DOCS) >/dev/null 2>&1; then \
		echo "helm-docs not found, please install it: https://github.com/norwoodj/helm-docs"; \
	fi
	@echo "Installing kubeval..."
	@if ! command -v $(KUBEVAL) >/dev/null 2>&1; then \
		echo "kubeval not found, please install it: https://github.com/instrumenta/kubeval"; \
	fi
	@echo "✅ Development environment setup completed"

# Quick development workflow
dev: deps lint template ## Quick development workflow
	@echo "🎯 Development workflow completed"

# CI/CD simulation
ci: clean deps lint template dry-run validate security-scan ## Simulate CI pipeline
	@echo "🤖 CI pipeline simulation completed"

# Show chart information
info: ## Show chart information
	@echo "📊 Chart Information:"
	@echo "Name: $(CHART_NAME)"
	@echo "Path: $(CHART_PATH)"
	@echo "Namespace: $(NAMESPACE)"
	@echo "Release Name: $(RELEASE_NAME)"
	@echo ""
	@echo "📋 Chart Details:"
	@$(HELM) show chart $(CHART_PATH)

# Show values
values: ## Show chart values
	@echo "⚙️ Chart Values:"
	@$(HELM) show values $(CHART_PATH)

# Debug helpers
debug-template: ## Debug template rendering with verbose output
	@echo "🐛 Debug template rendering..."
	$(HELM) template $(RELEASE_NAME) $(CHART_PATH) --debug --dry-run

debug-install: ## Debug installation with verbose output
	@echo "🐛 Debug installation..."
	$(HELM) install $(RELEASE_NAME) $(CHART_PATH) --namespace $(NAMESPACE) --debug --dry-run

# Local development with kind
kind-create: ## Create a kind cluster for local development
	@echo "🐳 Creating kind cluster..."
	kind create cluster --name supabase-dev
	@echo "✅ Kind cluster created"

kind-delete: ## Delete the kind cluster
	@echo "🗑️ Deleting kind cluster..."
	kind delete cluster --name supabase-dev
	@echo "✅ Kind cluster deleted"

kind-install: kind-create install ## Create kind cluster and install chart
	@echo "🎉 Kind cluster created and chart installed"

# Show logs
logs: ## Show logs from all pods
	@echo "📋 Showing logs from all pods..."
	$(KUBECTL) logs -l app.kubernetes.io/instance=$(RELEASE_NAME) --namespace $(NAMESPACE) --tail=100

# Port forwarding for local access
port-forward-studio: ## Port forward to Supabase Studio
	@echo "🌐 Port forwarding to Supabase Studio (http://localhost:3000)..."
	$(KUBECTL) port-forward svc/$(RELEASE_NAME)-studio 3000:3000 --namespace $(NAMESPACE)

port-forward-api: ## Port forward to Supabase API
	@echo "🌐 Port forwarding to Supabase API (http://localhost:8000)..."
	$(KUBECTL) port-forward svc/$(RELEASE_NAME)-kong 8000:8000 --namespace $(NAMESPACE)

# Default target when no target is specified
.DEFAULT_GOAL := help
