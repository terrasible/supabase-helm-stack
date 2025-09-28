# Kong Operator Integration Examples

This directory contains examples and configuration files for deploying Supabase with Kong Operator integration.

## Files Overview

- `values-kong-operator.yaml` - Example Helm values file for Supabase with Kong Operator configuration
- `kong-gateway.yaml` - Kong Gateway deployment manifest for use with Kong Operator
- `deploy.sh` - Automated deployment script for Kong Gateway and Supabase
- `README.md` - This documentation file

## Quick Start

### Prerequisites

1. Kubernetes cluster (1.19+)
2. Helm 3.x installed
3. kubectl configured to access your cluster
4. Sufficient cluster resources (minimum 4 CPU cores, 8GB RAM)

### Automated Deployment

The easiest way to deploy Supabase with Kong Operator is using the provided deployment script:

```bash
# Make the script executable (if not already)
chmod +x deploy.sh

# Deploy Kong Gateway and Supabase
./deploy.sh deploy

# Verify the deployment
./deploy.sh verify

# Clean up (when needed)
./deploy.sh cleanup
```

### Manual Deployment

If you prefer manual deployment:

#### Step 1: Install Kong Operator

```bash
# Add Kong Helm repository
helm repo add kong https://charts.konghq.com
helm repo update

# Install Kong Operator
helm install kong-operator kong/kong --namespace kong-system --create-namespace
```

#### Step 2: Deploy Kong Gateway

```bash
# Apply Kong Gateway configuration
kubectl apply -f kong-gateway.yaml

# Wait for Kong Gateway to be ready
kubectl wait --for=condition=available --timeout=300s deployment/kong-gateway -n kong-system
```

#### Step 3: Deploy Supabase

```bash
# Create Supabase namespace
kubectl create namespace supabase

# Label namespace for network policies
kubectl label namespace supabase name=supabase

# Deploy Supabase with Kong Operator integration
helm install supabase ../../ --namespace supabase --values values-kong-operator.yaml
```

## Configuration

### Kong Operator Settings

The key configuration options for Kong Operator integration:

```yaml
kongOperator:
  enabled: true                    # Enable Kong Operator integration
  serviceNamespace: "kong-system"  # Namespace where Kong Gateway is deployed
  serviceName: "kong-gateway"      # Name of the Kong Gateway service
  servicePort: 8000                # Kong Gateway proxy port
  adminApi:
    serviceName: "kong-admin"      # Name of the Kong Admin API service
    servicePort: 8001              # Kong Admin API port
```

### Customizing the Deployment

You can customize the deployment by modifying `values-kong-operator.yaml`:

1. **Database Configuration**: Update PostgreSQL settings
2. **Resource Limits**: Adjust CPU and memory limits for each service
3. **Storage**: Configure persistent storage settings
4. **Security**: Update JWT secrets and API keys
5. **Monitoring**: Enable/disable monitoring components

### Network Policies

The chart automatically configures network policies to allow traffic between Kong Gateway and Supabase services. Ensure your cluster supports network policies and that namespaces are properly labeled.

## Accessing Services

### Kong Gateway

After deployment, Kong Gateway will be accessible via LoadBalancer service:

```bash
# Get Kong Gateway external IP
kubectl get service kong-gateway -n kong-system

# If using port-forward (for testing)
kubectl port-forward -n kong-system service/kong-gateway 8000:8000
```

### Supabase APIs

All Supabase APIs are accessible through Kong Gateway:

- REST API: `http://<kong-gateway-ip>:8000/rest/v1`
- Auth API: `http://<kong-gateway-ip>:8000/auth/v1`
- Storage API: `http://<kong-gateway-ip>:8000/storage/v1`
- Realtime API: `http://<kong-gateway-ip>:8000/realtime/v1`

### Supabase Studio

Supabase Studio is not exposed through Kong Gateway by default. Access it via port-forward:

```bash
kubectl port-forward -n supabase service/supabase-studio 3000:3000
```

Then open http://localhost:3000 in your browser.

## Monitoring and Observability

### Kong Gateway Metrics

Kong Gateway is configured with Prometheus plugin for metrics collection:

```bash
# Access Kong metrics
curl http://<kong-gateway-ip>:8000/metrics
```

### Supabase Metrics

Supabase services expose metrics on their respective metrics endpoints. Configure your monitoring stack to scrape these endpoints.

## Troubleshooting

### Common Issues

1. **Kong Gateway not accessible**
   - Check if LoadBalancer service has external IP assigned
   - Verify firewall rules allow traffic on port 8000
   - Check Kong Gateway pod logs: `kubectl logs -n kong-system deployment/kong-gateway`

2. **Supabase services not reachable through Kong**
   - Verify network policies allow cross-namespace communication
   - Check Kong declarative configuration in ConfigMap
   - Test direct service connectivity: `kubectl exec -n kong-system deployment/kong-gateway -- curl http://supabase-rest.supabase:3000/health`

3. **Database connection issues**
   - Check PostgreSQL pod status: `kubectl get pods -n supabase -l app.kubernetes.io/component=postgresql`
   - Verify database credentials in secrets
   - Check service connectivity between Supabase components and PostgreSQL

### Debugging Commands

```bash
# Check all pods status
kubectl get pods -A

# Check Kong Gateway logs
kubectl logs -n kong-system deployment/kong-gateway -f

# Check Supabase service logs
kubectl logs -n supabase deployment/supabase-auth -f
kubectl logs -n supabase deployment/supabase-rest -f

# Test Kong Gateway health
kubectl exec -n kong-system deployment/kong-gateway -- curl -s http://localhost:8001/status

# Check network policies
kubectl get networkpolicies -n supabase

# Verify service endpoints
kubectl get endpoints -n supabase
kubectl get endpoints -n kong-system
```

## Security Considerations

1. **Network Policies**: Ensure network policies are enabled and properly configured
2. **RBAC**: Use proper RBAC permissions for Kong Operator and Supabase services
3. **Secrets Management**: Store sensitive data in Kubernetes secrets, not in values files
4. **TLS**: Enable TLS for Kong Gateway in production environments
5. **API Keys**: Rotate Supabase API keys regularly
6. **Database Security**: Use strong passwords and enable SSL for PostgreSQL connections

## Production Considerations

1. **High Availability**: Deploy multiple replicas of Kong Gateway and Supabase services
2. **Resource Limits**: Set appropriate resource requests and limits
3. **Persistent Storage**: Use high-performance storage classes for PostgreSQL
4. **Backup Strategy**: Implement regular database backups
5. **Monitoring**: Set up comprehensive monitoring and alerting
6. **Scaling**: Configure horizontal pod autoscaling for Supabase services
7. **Updates**: Plan for rolling updates and maintenance windows

## Support

For issues and questions:

1. Check the main Supabase Helm chart documentation
2. Review Kong Operator documentation
3. Check Kubernetes cluster logs and events
4. Consult the troubleshooting section above
