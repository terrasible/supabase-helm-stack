# Kong Operator Integration

This document explains how to use the Kong Operator with the Supabase Helm chart instead of the embedded Kong chart.

## Overview

The Supabase Helm chart now supports integration with the Kong Operator, which provides a more production-ready and scalable way to manage Kong Gateway instances in Kubernetes.

## Prerequisites

1. Kong Operator installed in your cluster
2. A Kong Gateway instance managed by the Kong Operator
3. Proper RBAC permissions for cross-namespace communication

## Configuration

### Basic Kong Operator Configuration

```yaml
kongOperator:
  enabled: true
  serviceNamespace: "kong-system"
  serviceName: "kong-gateway"
  servicePort: 8000
  adminApi:
    serviceName: "kong-admin"
    servicePort: 8001
```

### Complete Example

```yaml
# values.yaml
kongOperator:
  enabled: true
  serviceNamespace: "kong-system"
  serviceName: "kong-gateway"
  servicePort: 8000
  adminApi:
    serviceName: "kong-admin"
    servicePort: 8001

# Supabase configuration
supabase:
  url: "https://your-domain.com"
  anonKey: "your-anon-key"
  serviceKey: "your-service-key"

# Database configuration
postgresql:
  enabled: true
  auth:
    postgresPassword: "your-postgres-password"
    database: "supabase"
```

## Kong Gateway Setup

Before deploying Supabase, ensure you have a Kong Gateway instance running via the Kong Operator:

```yaml
# kong-gateway.yaml
apiVersion: configuration.konghq.com/v1
kind: KongIngress
metadata:
  name: supabase-kong-ingress
  namespace: kong-system
spec:
  upstream:
    healthchecks:
      active:
        healthy:
          interval: 30
        unhealthy:
          interval: 30
  proxy:
    connect_timeout: 60000
    read_timeout: 60000
    write_timeout: 60000
---
apiVersion: v1
kind: Service
metadata:
  name: kong-gateway
  namespace: kong-system
  annotations:
    konghq.com/plugins: rate-limiting,cors
spec:
  type: LoadBalancer
  ports:
  - name: proxy
    port: 8000
    targetPort: 8000
    protocol: TCP
  - name: proxy-ssl
    port: 8443
    targetPort: 8443
    protocol: TCP
  selector:
    app: kong
```

## Network Policies

When using Kong Operator, the Supabase chart automatically configures network policies to allow traffic from the Kong Gateway namespace. Ensure your cluster supports network policies and that the Kong Operator namespace is properly labeled:

```bash
kubectl label namespace kong-system name=kong-system
```

## Service Routes Configuration

The Kong Operator integration requires proper route configuration. Here's an example of how to configure Kong routes for Supabase services:

```yaml
# kong-routes.yaml
apiVersion: configuration.konghq.com/v1
kind: KongIngress
metadata:
  name: supabase-routes
  namespace: kong-system
spec:
  route:
    methods:
    - GET
    - POST
    - PUT
    - DELETE
    - PATCH
    - OPTIONS
    paths:
    - /rest/v1
    - /auth/v1
    - /storage/v1
    - /realtime/v1
    strip_path: false
    preserve_host: true
```

## Troubleshooting

### Common Issues

1. **Network connectivity issues**: Ensure network policies allow traffic between namespaces
2. **Service discovery**: Verify that Kong Gateway can resolve Supabase service names
3. **RBAC permissions**: Check that Kong Operator has necessary permissions

### Debugging Commands

```bash
# Check Kong Gateway status
kubectl get pods -n kong-system

# Verify network policies
kubectl get networkpolicies -n supabase

# Check service endpoints
kubectl get endpoints -n supabase
kubectl get endpoints -n kong-system

# Test connectivity from Kong to Supabase services
kubectl exec -n kong-system deployment/kong-gateway -- curl http://supabase-rest.supabase:3000/health
```

## Migration from Embedded Kong

If you're migrating from the embedded Kong chart:

1. Deploy Kong Operator and Gateway instance
2. Update your values.yaml to enable Kong Operator integration
3. Disable the embedded Kong chart:

   ```yaml
   kongOperator:
     enabled: true
     # ... configuration
   ```

4. Redeploy the Supabase chart
5. Verify all services are accessible through the Kong Gateway

## Security Considerations

- Use proper RBAC to limit cross-namespace access
- Configure network policies to restrict traffic flow
- Enable TLS for all Kong Gateway communications
- Regularly update Kong Gateway and Operator versions
- Monitor Kong Gateway metrics and logs

## Performance Tuning

- Configure appropriate resource limits for Kong Gateway
- Use horizontal pod autoscaling for Kong Gateway pods
- Optimize Kong plugins for your use case
- Monitor response times and adjust timeouts accordingly
