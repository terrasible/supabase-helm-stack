# Supabase Helm Stack

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Helm Chart Version](https://img.shields.io/badge/Helm-v0.1.3-blue.svg)](https://helm.sh/)
[![Kubernetes Version](https://img.shields.io/badge/Kubernetes-v1.20+-blue.svg)](https://kubernetes.io/)

A production-ready Helm chart for deploying [Supabase](https://supabase.com/) on Kubernetes. This chart provides a scalable, secure, and fully configurable deployment of the complete Supabase stack.

## 🚀 Features

- **Complete Supabase Stack**: Deploy all Supabase services (Auth, API, Realtime, Storage, Studio)
- **Production Ready**: Includes security best practices, monitoring, and high availability
- **Highly Configurable**: Extensive configuration options for all components
- **Cloud Native**: Built for Kubernetes with proper RBAC, network policies, and resource management
- **Monitoring**: Built-in Prometheus metrics and service monitors
- **Security**: Network policies, pod security standards, and secret management

## 📋 Prerequisites

- Kubernetes 1.20+
- Helm 3.8+
- PV provisioner support in the underlying infrastructure
- Ingress controller (optional, for external access)

### Required: Kong Operator Installation

**⚠️ IMPORTANT**: Before installing this chart, you must install the Kong Operator which provides the necessary Custom Resource Definitions (CRDs):

```bash
# Install Kong Operator
kubectl apply -f https://github.com/Kong/kubernetes-ingress-controller/releases/latest/download/all-in-one-dbless.yaml

# Verify Kong Operator is running
kubectl get pods -n kong-system

# Wait for Kong Operator to be ready
kubectl wait --for=condition=ready pod -l app=ingress-kong -n kong-system --timeout=300s
```

### Chart Dependencies

This chart includes dependencies that need to be downloaded before installation:

```bash
# Update chart dependencies (required before first install)
helm dependency update ./charts/supabase
```

## 🛠️ Installation

### Quick Start

```bash
# Add the Helm repository
helm repo add supabase-helm https://your-repo-url.com
helm repo update

# Install Supabase
helm install my-supabase supabase-helm/supabase
```

### Custom Installation

```bash
# Clone the repository
git clone https://github.com/your-username/supabase-helm-stack.git
cd supabase-helm-stack

# Update chart dependencies (required)
helm dependency update ./charts/supabase

# Install with custom values
helm install my-supabase ./charts/supabase -f my-values.yaml
```

### Development Installation

```bash
# Install dependencies
helm dependency update ./charts/supabase

# Install in development mode
helm install supabase-dev ./charts/supabase \
  --set global.environment=development \
  --set ingress.enabled=true \
  --set ingress.hosts[0].host=supabase.local
```

## ⚙️ Configuration

### Basic Configuration

The following table lists the configurable parameters and their default values:

| Parameter | Description | Default |
|-----------|-------------|---------|
| `global.environment` | Environment (development/staging/production) | `production` |
| `ingress.enabled` | Enable ingress | `false` |
| `postgresql.enabled` | Enable PostgreSQL | `true` |
| `minio.enabled` | Enable MinIO for storage | `true` |
| `kongOperator.enabled` | Enable Kong Operator integration | `false` |
| `kongOperator.serviceName` | Kong Gateway service name | `kong-gateway` |
| `kongOperator.serviceNamespace` | Kong Gateway namespace | `kong-system` |

### Advanced Configuration

For detailed configuration options, see:

- [values.yaml](./charts/supabase/values.yaml) - Complete configuration reference
- [values.example.yaml](./charts/supabase/values.example.yaml) - Example configurations

### Environment-Specific Configurations

#### Production

```yaml
global:
  environment: production

rbac:
  create: true

networkPolicy:
  enabled: true

podDisruptionBudget:
  enabled: true
  minAvailable: 1

serviceMonitor:
  enabled: true
```

#### Development

```yaml
global:
  environment: development

ingress:
  enabled: true
  hosts:
    - host: supabase.local

postgresql:
  auth:
    enableSuperuserAccess: true
```

## 🔧 Components

This Helm chart deploys the following Supabase components:

| Component | Description | Port |
|-----------|-------------|------|
| **Kong Gateway** | API Gateway and Load Balancer (via Kong Operator) | 8000 |
| **Auth** | Authentication service | 9999 |
| **REST** | PostgREST API server | 3000 |
| **Realtime** | Real-time subscriptions | 4000 |
| **Storage** | File storage service | 5000 |
| **Meta** | Metadata service | 8080 |
| **Studio** | Web-based dashboard | 3001 |
| **Functions** | Edge Functions runtime | 9000 |
| **PostgreSQL** | Primary database | 5432 |
| **MinIO** | S3-compatible object storage | 9000 |

## 🔍 Monitoring

### Prometheus Metrics

Enable Prometheus monitoring:

```yaml
serviceMonitor:
  enabled: true

prometheus:
  enabled: true
```

### Health Checks

All services include readiness and liveness probes:

```bash
# Check pod status
kubectl get pods -l app.kubernetes.io/name=supabase

# Check service health
# For Kong Operator integration
kubectl port-forward svc/kong-gateway 8000:8000 -n kong-system

# For embedded Kong (legacy)
kubectl port-forward svc/supabase-kong 8000:8000
curl http://localhost:8000/health
```

## 🌐 Kong Operator Integration

This chart supports integration with Kong Gateway via the Kong Operator for production deployments. Kong Operator provides better lifecycle management, scaling, and enterprise features compared to the embedded Kong deployment.

### Prerequisites

- Kong Operator installed in your cluster
- Kong Gateway deployed via Kong Operator

### Configuration

Enable Kong Operator integration:

```yaml
kongOperator:
  enabled: true
  serviceName: "kong-gateway"
  serviceNamespace: "kong-system"
  servicePort: 8000
  admin:
    serviceName: "kong-admin"
    servicePort: 8001
  configuration:
    autoConfig: true
    plugins:
      - "cors"
      - "rate-limiting"
      - "request-id"
```

### Quick Start with Kong Operator

1. **Deploy Kong Operator and Gateway:**

   ```bash
   cd charts/supabase/examples/kong-operator
   ./deploy.sh
   ```

2. **Install Supabase with Kong Operator:**

   ```bash
   helm install supabase ./charts/supabase \
     -f charts/supabase/examples/kong-operator/values-kong-operator.yaml
   ```

3. **Access Supabase services:**

   ```bash
   kubectl port-forward svc/kong-gateway 8000:8000 -n kong-system
   ```

### Service Routes

When Kong Operator integration is enabled, Supabase services are accessible through Kong Gateway:

- **REST API**: `http://kong-gateway:8000/rest/v1`
- **Auth**: `http://kong-gateway:8000/auth/v1`
- **Storage**: `http://kong-gateway:8000/storage/v1`
- **Realtime**: `http://kong-gateway:8000/realtime/v1`
- **Studio**: `http://kong-gateway:8000/studio`

### Migration from Embedded Kong

To migrate from embedded Kong to Kong Operator:

1. **Disable embedded Kong:**

   ```yaml
   kong:
     enabled: false
   ```

2. **Enable Kong Operator integration:**

   ```yaml
   kongOperator:
     enabled: true
   ```

3. **Update network policies** (automatically handled by the chart)

4. **Update client configurations** to use Kong Gateway endpoints

For detailed migration steps and examples, see [Kong Operator Documentation](charts/supabase/docs/kong-operator.md).

## 🔒 Security

### Network Policies

Enable network policies for enhanced security:

```yaml
networkPolicy:
  enabled: true
  cilium:
    enabled: true  # For Cilium CNI
```

### RBAC

Role-Based Access Control is enabled by default:

```yaml
rbac:
  create: true
  additionalRules: []
```

### Secrets Management

Secrets are managed through Kubernetes secrets:

```yaml
secret:
  create: true
  data:
    jwt-secret: "your-jwt-secret"
    postgres-password: "your-db-password"
```

## 🚀 Scaling

### Horizontal Pod Autoscaling

```yaml
autoscaling:
  enabled: true
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilizationPercentage: 80
```

### Resource Management

```yaml
resources:
  limits:
    cpu: 500m
    memory: 512Mi
  requests:
    cpu: 250m
    memory: 256Mi
```

## 🧪 Testing

```bash
# Run Helm tests
helm test my-supabase

# Run chart linting
helm lint ./charts/supabase

# Validate templates
helm template my-supabase ./charts/supabase --debug
```

## 🔄 Upgrading

```bash
# Update Helm repository
helm repo update

# Upgrade release
helm upgrade my-supabase supabase-helm/supabase

# Rollback if needed
helm rollback my-supabase 1
```

## 🗑️ Uninstalling

```bash
# Uninstall the release
helm uninstall my-supabase

# Clean up PVCs (optional)
kubectl delete pvc -l app.kubernetes.io/name=supabase
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Setup

```bash
# Clone the repository
git clone https://github.com/your-username/supabase-helm-stack.git
cd supabase-helm-stack

# Install dependencies
helm dependency update ./charts/supabase

# Run tests
make test
```

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- 📖 [Documentation](https://github.com/your-username/supabase-helm-stack/wiki)
- 🐛 [Issue Tracker](https://github.com/your-username/supabase-helm-stack/issues)
- 💬 [Discussions](https://github.com/your-username/supabase-helm-stack/discussions)
- 📧 [Email Support](mailto:support@example.com)

## 🙏 Acknowledgments

- [Supabase](https://supabase.com/) for the amazing open-source Firebase alternative
- [Helm](https://helm.sh/) for the package manager for Kubernetes
- The Kubernetes community for the excellent ecosystem

---

**Made with ❤️ by the community**
