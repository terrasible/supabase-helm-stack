# Secrets Management in Supabase Helm Chart

This Helm chart provides three flexible approaches for managing secrets in your Supabase deployment. Choose the approach that best fits your security requirements and operational preferences.

## Overview

The chart supports three secrets management patterns:

1. **Auto-generated Secrets** - Chart creates and manages secrets automatically
2. **External Secret References** - Reference existing secrets in your cluster
3. **External Secrets Operator** - Integration with External Secrets Operator for advanced secret management

## 1. Auto-generated Secrets (Default)

The simplest approach where the chart automatically generates secrets for all services.

### Configuration

```yaml
# values.yaml
secret:
  # All services use auto-generated secrets
  db:
    # No secretRef specified - auto-generated
  jwt:
    # No secretRef specified - auto-generated
  smtp:
    # No secretRef specified - auto-generated
  dashboard:
    # No secretRef specified - auto-generated
  analytics:
    # No secretRef specified - auto-generated
```

### Generated Secret Names

- Database: `<release-name>-supabase-db`
- JWT: `<release-name>-supabase-jwt`
- SMTP: `<release-name>-supabase-smtp`
- Dashboard: `<release-name>-supabase-dashboard`
- Analytics: `<release-name>-supabase-analytics`

### Secret Keys

**Database Secret:**

- `username` - Database username
- `password` - Database password
- `database` - Database name

**JWT Secret:**

- `anonKey` - Anonymous JWT key
- `serviceKey` - Service role JWT key
- `secret` - JWT signing secret

**SMTP Secret:**

- `username` - SMTP username
- `password` - SMTP password

**Dashboard Secret:**

- `username` - Dashboard username
- `password` - Dashboard password

**Analytics Secret:**

- `apiKey` - Logflare API key

## 2. External Secret References

Reference existing secrets in your Kubernetes cluster for fine-grained control.

### Configuration

```yaml
# values.yaml
secret:
  db:
    secretRef: my-existing-db-secret
    secretRefKey:
      username: db-user
      password: db-pass
      database: db-name

  jwt:
    secretRef: my-existing-jwt-secret
    secretRefKey:
      anonKey: anon-key
      serviceKey: service-key
      secret: jwt-secret

  smtp:
    secretRef: my-existing-smtp-secret
    secretRefKey:
      username: smtp-user
      password: smtp-pass

  dashboard:
    secretRef: my-existing-dashboard-secret
    secretRefKey:
      username: dash-user
      password: dash-pass

  analytics:
    secretRef: my-existing-analytics-secret
    secretRefKey:
      apiKey: api-key
```

### Creating External Secrets

```bash
# Example: Create a database secret
kubectl create secret generic my-db-secret \
  --from-literal=db-user=postgres \
  --from-literal=db-pass=mypassword \
  --from-literal=db-name=postgres

# Example: Create a JWT secret
kubectl create secret generic my-jwt-secret \
  --from-literal=anon-key=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9... \
  --from-literal=service-key=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9... \
  --from-literal=jwt-secret=your-super-secret-jwt-token
```

## 3. External Secrets Operator Integration

Integrate with External Secrets Operator for advanced secret management from external systems like AWS Secrets Manager, Azure Key Vault, HashiCorp Vault, etc.

### Prerequisites

1. Install External Secrets Operator in your cluster
2. Configure SecretStore or ClusterSecretStore for your secret backend

### Configuration

```yaml
# values.yaml
externalSecrets:
  enabled: true

  # Global settings
  secretStore:
    name: vault-backend
    kind: SecretStore  # or ClusterSecretStore

  # Per-service configuration
  db:
    enabled: true
    secretName: supabase-db-secret
    data:
      - secretKey: username
        remoteRef:
          key: supabase/db
          property: username
      - secretKey: password
        remoteRef:
          key: supabase/db
          property: password
      - secretKey: database
        remoteRef:
          key: supabase/db
          property: database

  jwt:
    enabled: true
    secretName: supabase-jwt-secret
    data:
      - secretKey: anonKey
        remoteRef:
          key: supabase/jwt
          property: anonKey
      - secretKey: serviceKey
        remoteRef:
          key: supabase/jwt
          property: serviceKey
      - secretKey: secret
        remoteRef:
          key: supabase/jwt
          property: secret

  smtp:
    enabled: true
    secretName: supabase-smtp-secret
    data:
      - secretKey: username
        remoteRef:
          key: supabase/smtp
          property: username
      - secretKey: password
        remoteRef:
          key: supabase/smtp
          property: password
```

### Example SecretStore Configuration

```yaml
# secretstore.yaml
apiVersion: external-secrets.io/v1beta1
kind: SecretStore
metadata:
  name: vault-backend
  namespace: supabase
spec:
  provider:
    vault:
      server: "https://vault.example.com"
      path: "secret"
      version: "v2"
      auth:
        kubernetes:
          mountPath: "kubernetes"
          role: "supabase-role"
          serviceAccountRef:
            name: "external-secrets-sa"
```

## Mixed Approach

You can mix different approaches for different services:

```yaml
# values.yaml
secret:
  # Use auto-generated secret for database
  db: {}

  # Use external secret reference for JWT
  jwt:
    secretRef: my-jwt-secret
    secretRefKey:
      anonKey: anon-key
      serviceKey: service-key
      secret: jwt-secret

  # Use auto-generated for SMTP
  smtp: {}

externalSecrets:
  enabled: true

  # Use External Secrets Operator for dashboard only
  dashboard:
    enabled: true
    secretName: supabase-dashboard-secret
    data:
      - secretKey: username
        remoteRef:
          key: supabase/dashboard
          property: username
      - secretKey: password
        remoteRef:
          key: supabase/dashboard
          property: password
```

## Security Best Practices

1. **Use External Secrets for Production**: For production deployments, use external secret references or External Secrets Operator instead of auto-generated secrets.

2. **Rotate Secrets Regularly**: Implement a secret rotation strategy, especially for JWT secrets.

3. **Limit Secret Access**: Use Kubernetes RBAC to limit which services and users can access secrets.

4. **Monitor Secret Usage**: Enable audit logging to track secret access patterns.

5. **Use Strong Passwords**: When creating external secrets, ensure passwords meet your security requirements.

6. **Encrypt at Rest**: Ensure your Kubernetes cluster has encryption at rest enabled for etcd.

## Troubleshooting

### Common Issues

1. **Secret Not Found**: Ensure the referenced secret exists in the same namespace as the Supabase deployment.

2. **Wrong Secret Key**: Verify that the `secretRefKey` values match the actual keys in your secret.

3. **External Secrets Not Syncing**: Check the External Secrets Operator logs and ensure your SecretStore is properly configured.

### Debugging Commands

```bash
# List all secrets in the namespace
kubectl get secrets -n supabase

# Describe a specific secret
kubectl describe secret <secret-name> -n supabase

# Check External Secrets status
kubectl get externalsecrets -n supabase
kubectl describe externalsecret <external-secret-name> -n supabase

# View External Secrets Operator logs
kubectl logs -n external-secrets-system deployment/external-secrets
```

## Migration Guide

### From Auto-generated to External Secrets

1. Extract current secret values:

   ```bash
   kubectl get secret <release-name>-supabase-db -o yaml > db-secret.yaml
   ```

2. Create new external secret with the same values

3. Update values.yaml to reference the external secret

4. Upgrade the Helm release

### From External Secrets to External Secrets Operator

1. Install and configure External Secrets Operator

2. Create ExternalSecret resources

3. Update values.yaml to enable External Secrets Operator

4. Upgrade the Helm release
