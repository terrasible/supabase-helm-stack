# Supabase Helm Chart Examples

This directory contains example configurations for deploying Supabase using different secrets management approaches. Choose the example that best fits your security requirements and operational preferences.

## Available Examples

### 1. Auto-generated Secrets (`secrets-auto-generated.yaml`)

**Best for:** Development, testing, and quick deployments

**Security Level:** Basic

**Description:** The simplest approach where the Helm chart automatically generates all secrets. Perfect for getting started quickly or for non-production environments.

**Pros:**

- Zero configuration required
- Quick setup
- No external dependencies

**Cons:**

- Secrets are stored in Kubernetes etcd
- No external secret rotation
- Not suitable for production environments with strict security requirements

**Usage:**

```bash
helm install supabase ./charts/supabase -f examples/secrets-auto-generated.yaml
```

### 2. External Secret References (`secrets-external-refs.yaml`)

**Best for:** Production environments with existing secret management workflows

**Security Level:** High

**Description:** References existing Kubernetes secrets that you create and manage separately. Provides full control over secret lifecycle and rotation.

**Pros:**

- Full control over secret values
- Can integrate with existing secret management processes
- Supports secret rotation
- Clear separation of concerns

**Cons:**

- Requires manual secret creation
- More setup complexity
- Secrets still stored in Kubernetes etcd

**Prerequisites:**

1. Create the required secrets in your cluster
2. Ensure secrets are in the same namespace as Supabase

**Usage:**

```bash
# Create secrets first (see commands in the example file)
kubectl create secret generic my-supabase-db-secret \
  --from-literal=db-username=postgres \
  --from-literal=db-password=your-secure-password \
  --from-literal=db-name=postgres

# Deploy Supabase
helm install supabase ./charts/supabase -f examples/secrets-external-refs.yaml
```

### 3. External Secrets Operator (`secrets-external-secrets-operator.yaml`)

**Best for:** Enterprise production environments with external secret stores

**Security Level:** Maximum

**Description:** Integrates with External Secrets Operator to fetch secrets from external systems like AWS Secrets Manager, Azure Key Vault, HashiCorp Vault, etc.

**Pros:**

- Secrets never stored in Kubernetes etcd
- Automatic secret rotation
- Integration with enterprise secret stores
- Audit trails and compliance
- Centralized secret management

**Cons:**

- Requires External Secrets Operator installation
- More complex setup
- Additional infrastructure dependencies

**Prerequisites:**

1. Install External Secrets Operator
2. Configure SecretStore/ClusterSecretStore
3. Store secrets in your external secret system

**Usage:**

```bash
# Install External Secrets Operator (if not already installed)
helm repo add external-secrets https://charts.external-secrets.io
helm install external-secrets external-secrets/external-secrets -n external-secrets-system --create-namespace

# Create SecretStore (see example in the file)
kubectl apply -f secretstore.yaml

# Deploy Supabase
helm install supabase ./charts/supabase -f examples/secrets-external-secrets-operator.yaml
```

### 4. Mixed Approach (`secrets-mixed-approach.yaml`)

**Best for:** Environments with varying security requirements per service

**Security Level:** Variable (per service)

**Description:** Demonstrates using different secrets management strategies for different services based on their security requirements.

**Example Strategy:**

- **Database:** External Secrets Operator (highest security)
- **JWT:** External secret reference (high security)
- **SMTP:** Auto-generated (medium security)
- **Dashboard:** External secret reference (medium security)
- **Analytics:** Auto-generated (low security)

**Pros:**

- Flexible security posture
- Optimized for different service requirements
- Gradual migration path
- Cost-effective

**Cons:**

- More complex configuration
- Mixed operational procedures
- Requires understanding of all approaches

**Usage:**

```bash
# Create required external secrets
kubectl create secret generic my-jwt-secret --from-literal=...
kubectl create secret generic my-dashboard-secret --from-literal=...

# Configure External Secrets Operator for database
kubectl apply -f secretstore.yaml

# Deploy Supabase
helm install supabase ./charts/supabase -f examples/secrets-mixed-approach.yaml
```

## Choosing the Right Approach

### Decision Matrix

| Requirement | Auto-generated | External Refs | External Secrets Operator | Mixed |
|-------------|----------------|---------------|---------------------------|-------|
| Quick setup | ✅ Excellent | ⚠️ Moderate | ❌ Complex | ⚠️ Moderate |
| Production ready | ❌ No | ✅ Yes | ✅ Yes | ✅ Yes |
| Secret rotation | ❌ Manual | ⚠️ Manual | ✅ Automatic | ⚠️ Variable |
| Compliance | ❌ Basic | ⚠️ Moderate | ✅ High | ⚠️ Variable |
| External integration | ❌ No | ❌ No | ✅ Yes | ⚠️ Partial |
| Operational complexity | ✅ Low | ⚠️ Moderate | ❌ High | ❌ High |

### Recommendations by Environment

**Development/Testing:**

- Use `secrets-auto-generated.yaml`
- Quick setup, no external dependencies

**Staging:**

- Use `secrets-external-refs.yaml` or `secrets-mixed-approach.yaml`
- Practice production-like secret management

**Production:**

- Use `secrets-external-secrets-operator.yaml` for maximum security
- Use `secrets-external-refs.yaml` if External Secrets Operator is not available
- Use `secrets-mixed-approach.yaml` for gradual migration or mixed requirements

## Security Best Practices

1. **Never commit secrets to version control**
2. **Use strong, randomly generated passwords**
3. **Rotate secrets regularly**
4. **Limit secret access with RBAC**
5. **Enable audit logging for secret access**
6. **Use encryption at rest for etcd**
7. **Monitor secret usage and access patterns**

## Migration Paths

### From Auto-generated to External References

1. Extract current secret values:

   ```bash
   kubectl get secret <release-name>-supabase-db -o yaml > current-secrets.yaml
   ```

2. Create new external secrets with the same values

3. Update values.yaml to reference external secrets

4. Upgrade Helm release

### From External References to External Secrets Operator

1. Install and configure External Secrets Operator

2. Store current secret values in external secret store

3. Create ExternalSecret resources

4. Update values.yaml to enable External Secrets Operator

5. Upgrade Helm release

## Troubleshooting

### Common Issues

1. **Secret not found errors**
   - Verify secret exists: `kubectl get secrets`
   - Check namespace: secrets must be in same namespace as Supabase
   - Verify secret name matches configuration

2. **Wrong secret key errors**
   - Check secret keys: `kubectl describe secret <secret-name>`
   - Verify `secretRefKey` values match actual keys

3. **External Secrets not syncing**
   - Check External Secrets Operator logs
   - Verify SecretStore configuration
   - Check external secret store connectivity

### Debugging Commands

```bash
# List all secrets
kubectl get secrets -n <namespace>

# Describe a secret
kubectl describe secret <secret-name> -n <namespace>

# Check External Secrets status
kubectl get externalsecrets -n <namespace>
kubectl describe externalsecret <name> -n <namespace>

# View External Secrets Operator logs
kubectl logs -n external-secrets-system deployment/external-secrets

# Test secret access from a pod
kubectl run test-pod --image=busybox --rm -it -- sh
# Inside the pod:
cat /var/run/secrets/kubernetes.io/serviceaccount/token
```

## Support

For more detailed information, see:

- [SECRETS.md](../SECRETS.md) - Comprehensive secrets management guide
- [values.yaml](../values.yaml) - All available configuration options
- [External Secrets Operator Documentation](https://external-secrets.io/)
