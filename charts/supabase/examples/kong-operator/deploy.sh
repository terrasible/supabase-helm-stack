#!/bin/bash

# Supabase with Kong Operator Deployment Script
# This script helps deploy Kong Gateway and Supabase using Kong Operator integration

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
KONG_NAMESPACE="kong-system"
SUPABASE_NAMESPACE="supabase"
CHART_PATH="../../"
VALUES_FILE="values-kong-operator.yaml"
KONG_GATEWAY_FILE="kong-gateway.yaml"

# Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_prerequisites() {
    log_info "Checking prerequisites..."

    # Check if kubectl is installed
    if ! command -v kubectl &> /dev/null; then
        log_error "kubectl is not installed or not in PATH"
        exit 1
    fi

    # Check if helm is installed
    if ! command -v helm &> /dev/null; then
        log_error "helm is not installed or not in PATH"
        exit 1
    fi

    # Check if cluster is accessible
    if ! kubectl cluster-info &> /dev/null; then
        log_error "Cannot connect to Kubernetes cluster"
        exit 1
    fi

    log_success "Prerequisites check passed"
}

install_kong_operator() {
    log_info "Installing Kong Operator..."

    # Add Kong Helm repository
    helm repo add kong https://charts.konghq.com
    helm repo update

    # Create kong-system namespace if it doesn't exist
    kubectl create namespace $KONG_NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

    # Install Kong Operator
    if helm list -n $KONG_NAMESPACE | grep -q kong-operator; then
        log_warning "Kong Operator already installed, upgrading..."
        helm upgrade kong-operator kong/kong --namespace $KONG_NAMESPACE
    else
        helm install kong-operator kong/kong --namespace $KONG_NAMESPACE --create-namespace
    fi

    # Wait for Kong Operator to be ready
    log_info "Waiting for Kong Operator to be ready..."
    kubectl wait --for=condition=available --timeout=300s deployment/kong-operator -n $KONG_NAMESPACE

    log_success "Kong Operator installed successfully"
}

deploy_kong_gateway() {
    log_info "Deploying Kong Gateway..."

    # Apply Kong Gateway configuration
    kubectl apply -f $KONG_GATEWAY_FILE

    # Wait for Kong Gateway to be ready
    log_info "Waiting for Kong Gateway to be ready..."
    kubectl wait --for=condition=available --timeout=300s deployment/kong-gateway -n $KONG_NAMESPACE

    # Wait for Kong Gateway service to have external IP (if LoadBalancer)
    log_info "Waiting for Kong Gateway service to be ready..."
    timeout=300
    while [ $timeout -gt 0 ]; do
        if kubectl get service kong-gateway -n $KONG_NAMESPACE -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null | grep -q .; then
            break
        fi
        if kubectl get service kong-gateway -n $KONG_NAMESPACE -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null | grep -q .; then
            break
        fi
        sleep 5
        timeout=$((timeout - 5))
    done

    log_success "Kong Gateway deployed successfully"
}

deploy_supabase() {
    log_info "Deploying Supabase with Kong Operator integration..."

    # Create supabase namespace if it doesn't exist
    kubectl create namespace $SUPABASE_NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

    # Label the supabase namespace for network policies
    kubectl label namespace $SUPABASE_NAMESPACE name=$SUPABASE_NAMESPACE --overwrite

    # Deploy Supabase
    if helm list -n $SUPABASE_NAMESPACE | grep -q supabase; then
        log_warning "Supabase already installed, upgrading..."
        helm upgrade supabase $CHART_PATH --namespace $SUPABASE_NAMESPACE --values $VALUES_FILE
    else
        helm install supabase $CHART_PATH --namespace $SUPABASE_NAMESPACE --values $VALUES_FILE --create-namespace
    fi

    # Wait for Supabase components to be ready
    log_info "Waiting for Supabase components to be ready..."
    kubectl wait --for=condition=available --timeout=300s deployment/supabase-auth -n $SUPABASE_NAMESPACE
    kubectl wait --for=condition=available --timeout=300s deployment/supabase-rest -n $SUPABASE_NAMESPACE
    kubectl wait --for=condition=available --timeout=300s deployment/supabase-storage -n $SUPABASE_NAMESPACE
    kubectl wait --for=condition=available --timeout=300s deployment/supabase-realtime -n $SUPABASE_NAMESPACE

    log_success "Supabase deployed successfully"
}

verify_deployment() {
    log_info "Verifying deployment..."

    # Check Kong Gateway status
    log_info "Kong Gateway status:"
    kubectl get pods -n $KONG_NAMESPACE -l app=kong
    kubectl get services -n $KONG_NAMESPACE

    # Check Supabase status
    log_info "Supabase status:"
    kubectl get pods -n $SUPABASE_NAMESPACE
    kubectl get services -n $SUPABASE_NAMESPACE

    # Get Kong Gateway external IP/hostname
    KONG_EXTERNAL_IP=$(kubectl get service kong-gateway -n $KONG_NAMESPACE -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || echo "")
    KONG_EXTERNAL_HOSTNAME=$(kubectl get service kong-gateway -n $KONG_NAMESPACE -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null || echo "")

    if [ -n "$KONG_EXTERNAL_IP" ]; then
        KONG_URL="http://$KONG_EXTERNAL_IP:8000"
    elif [ -n "$KONG_EXTERNAL_HOSTNAME" ]; then
        KONG_URL="http://$KONG_EXTERNAL_HOSTNAME:8000"
    else
        KONG_URL="http://localhost:8000 (use port-forward: kubectl port-forward -n $KONG_NAMESPACE service/kong-gateway 8000:8000)"
    fi

    log_success "Deployment verification completed"
    echo
    log_info "Access URLs:"
    echo "  Kong Gateway: $KONG_URL"
    echo "  Supabase API: $KONG_URL/rest/v1"
    echo "  Supabase Auth: $KONG_URL/auth/v1"
    echo "  Supabase Storage: $KONG_URL/storage/v1"
    echo "  Supabase Realtime: $KONG_URL/realtime/v1"
    echo
    log_info "To access Supabase Studio, use port-forward:"
    echo "  kubectl port-forward -n $SUPABASE_NAMESPACE service/supabase-studio 3000:3000"
    echo "  Then open: http://localhost:3000"
}

cleanup() {
    log_warning "Cleaning up deployment..."

    # Remove Supabase
    if helm list -n $SUPABASE_NAMESPACE | grep -q supabase; then
        helm uninstall supabase -n $SUPABASE_NAMESPACE
    fi

    # Remove Kong Gateway
    kubectl delete -f $KONG_GATEWAY_FILE --ignore-not-found=true

    # Remove Kong Operator
    if helm list -n $KONG_NAMESPACE | grep -q kong-operator; then
        helm uninstall kong-operator -n $KONG_NAMESPACE
    fi

    # Remove namespaces
    kubectl delete namespace $SUPABASE_NAMESPACE --ignore-not-found=true
    kubectl delete namespace $KONG_NAMESPACE --ignore-not-found=true

    log_success "Cleanup completed"
}

show_help() {
    echo "Supabase with Kong Operator Deployment Script"
    echo
    echo "Usage: $0 [COMMAND]"
    echo
    echo "Commands:"
    echo "  deploy     Deploy Kong Gateway and Supabase (default)"
    echo "  cleanup    Remove Kong Gateway and Supabase"
    echo "  verify     Verify existing deployment"
    echo "  help       Show this help message"
    echo
    echo "Environment Variables:"
    echo "  KONG_NAMESPACE      Kong namespace (default: kong-system)"
    echo "  SUPABASE_NAMESPACE  Supabase namespace (default: supabase)"
    echo "  VALUES_FILE         Helm values file (default: values-kong-operator.yaml)"
    echo
}

# Main script
case "${1:-deploy}" in
    "deploy")
        check_prerequisites
        install_kong_operator
        deploy_kong_gateway
        deploy_supabase
        verify_deployment
        ;;
    "cleanup")
        cleanup
        ;;
    "verify")
        verify_deployment
        ;;
    "help")
        show_help
        ;;
    *)
        log_error "Unknown command: $1"
        show_help
        exit 1
        ;;
esac
