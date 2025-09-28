# Testing Guide

This guide covers comprehensive testing for the Supabase Helm chart, including individual component tests, integration tests, and example configurations.

## Overview

The Supabase Helm chart includes a comprehensive test suite that validates:

- **Individual Service Tests**: Each Supabase component (Auth, REST API, Storage, etc.)
- **Kong Operator Integration**: API Gateway functionality and routing
- **Network Policies**: Security and network isolation
- **Monitoring & Metrics**: Prometheus integration and health checks
- **Security & RBAC**: Authentication, authorization, and security contexts
- **Scaling & Autoscaling**: HPA, PDB, and resource management
- **Integration Tests**: End-to-end functionality validation

## Test Structure

```text
charts/supabase/tests/
├── kong-operator-test.yaml      # Kong Operator integration tests
├── services-test.yaml           # Individual service health checks
├── network-policy-test.yaml     # Network policy validation
├── monitoring-test.yaml         # Monitoring and metrics tests
├── security-rbac-test.yaml      # Security and RBAC tests
├── scaling-test.yaml            # Scaling and autoscaling tests
└── integration-test-suite.yaml  # Comprehensive integration tests

examples/test-configurations/
├── minimal-test.yaml            # Minimal configuration for testing
├── production-test.yaml         # Production-ready test configuration
└── kong-operator-test.yaml      # Kong Operator specific test config

scripts/
└── run-tests.sh                 # Automated test runner script
```

## Quick Start

### 1. Run All Tests (Recommended)

```bash
# Run all tests with default configuration
./scripts/run-tests.sh

# Run all tests with production configuration
./scripts/run-tests.sh -f examples/test-configurations/production-test.yaml
```

### 2. Run Specific Test Suites

```bash
# Run only quick smoke tests
./scripts/run-tests.sh -s quick

# Run individual component tests
./scripts/run-tests.sh -s individual

# Run only integration tests
./scripts/run-tests.sh -s integration
```

### 3. Manual Test Execution

```bash
# Install the chart
helm install supabase ./charts/supabase -n supabase --create-namespace

# Run specific test
helm test supabase -n supabase --filter name=supabase-services-test

# Run all tests
helm test supabase -n supabase
```

## Test Configurations

### Minimal Test Configuration

Use `examples/test-configurations/minimal-test.yaml` for:

- Quick validation
- Resource-constrained environments
- Basic functionality testing

```yaml
# Key features enabled:
- PostgreSQL
- Auth Service
- REST API
- Meta Service
- Kong Gateway (embedded)

# Disabled features:
- Kong Operator
- Storage Service
- Realtime Service
- Studio
- Monitoring
- Network Policies
```

### Production Test Configuration

Use `examples/test-configurations/production-test.yaml` for:

- Full feature validation
- Production readiness testing
- Performance testing

```yaml
# All features enabled:
- All Supabase services
- Kong Operator (recommended)
- Monitoring & Metrics
- Network Policies
- Autoscaling
- Security features
- Resource quotas
```

### Kong Operator Test Configuration

Use `examples/test-configurations/kong-operator-test.yaml` for:

- Kong Operator specific testing
- API Gateway validation
- Service routing testing

## Individual Test Details

### 1. Kong Operator Integration Test

**File**: `tests/kong-operator-test.yaml`

**Purpose**: Validates Kong Operator integration and API Gateway functionality

**Tests**:

- Kong Gateway connectivity
- Admin API access
- Service route configuration
- Plugin loading
- Supabase service routing (REST, Auth, Storage, etc.)

**Usage**:

```bash
helm test supabase -n supabase --filter name=supabase-kong-operator-test
```

### 2. Services Test

**File**: `tests/services-test.yaml`

**Purpose**: Validates individual Supabase service health and connectivity

**Tests**:

- PostgreSQL connectivity
- Auth service health
- REST API availability
- Storage service status
- Realtime service connectivity
- Studio accessibility
- Meta service health
- Functions service (if enabled)
- MinIO health (if enabled)

**Usage**:

```bash
helm test supabase -n supabase --filter name=supabase-services-test
```

### 3. Network Policy Test

**File**: `tests/network-policy-test.yaml`

**Purpose**: Validates network security and isolation policies

**Tests**:

- Internal service connectivity
- PostgreSQL access restrictions
- External connectivity validation
- DNS resolution
- Cilium-specific policies (if enabled)
- Network policy resource validation

**Usage**:

```bash
helm test supabase -n supabase --filter name=supabase-network-policy-test
```

### 4. Monitoring Test

**File**: `tests/monitoring-test.yaml`

**Purpose**: Validates monitoring, metrics, and observability features

**Tests**:

- Prometheus metrics endpoints
- Service health endpoints
- ServiceMonitor resources
- Metrics format validation

**Usage**:

```bash
helm test supabase -n supabase --filter name=supabase-monitoring-test
```

### 5. Security & RBAC Test

**File**: `tests/security-rbac-test.yaml`

**Purpose**: Validates security configurations and RBAC policies

**Tests**:

- RBAC permissions
- Security contexts
- Secret management
- Pod security standards
- Resource limits
- Pod security policies (if enabled)

**Usage**:

```bash
helm test supabase -n supabase --filter name=supabase-security-rbac-test
```

### 6. Scaling Test

**File**: `tests/scaling-test.yaml`

**Purpose**: Validates scaling and autoscaling configurations

**Tests**:

- Horizontal Pod Autoscaler (HPA) configuration
- Pod Disruption Budgets (PDB)
- Resource quotas
- Resource usage validation
- Deployment rollout status
- Load balancing

**Usage**:

```bash
helm test supabase -n supabase --filter name=supabase-scaling-test
```

### 7. Integration Test Suite

**File**: `tests/integration-test-suite.yaml`

**Purpose**: Comprehensive end-to-end testing of the entire Supabase stack

**Test Categories**:

1. **Basic Connectivity**: Service health and availability
2. **Database Connectivity**: PostgreSQL connection validation
3. **API Gateway**: Kong/Kong Operator functionality
4. **Storage Backend**: MinIO integration
5. **Monitoring**: Metrics and health endpoints
6. **Authentication Flow**: Auth service functionality
7. **API Integration**: REST API with authentication
8. **Cross-Service Communication**: Internal service connectivity
9. **Security**: Access control and JWT validation
10. **Performance**: Response time validation
11. **Data Persistence**: Storage validation
12. **Configuration Validation**: Environment and secrets

**Usage**:

```bash
helm test supabase -n supabase --filter name=supabase-integration-test-suite
```

## Test Runner Script

The `scripts/run-tests.sh` script provides automated testing with the following features:

### Options

```bash
./scripts/run-tests.sh [OPTIONS]

Options:
    -n, --namespace NAMESPACE       Kubernetes namespace (default: supabase)
    -r, --release RELEASE_NAME      Helm release name (default: supabase)
    -c, --chart CHART_PATH          Path to chart directory (default: ./charts/supabase)
    -f, --values VALUES_FILE        Values file to use for testing
    -t, --timeout TIMEOUT          Test timeout (default: 300s)
    -s, --suite SUITE              Test suite: all|individual|quick|integration
    --no-cleanup                   Don't cleanup on failure
    -v, --verbose                   Verbose output
    -h, --help                     Show help
```

### Test Suites

- **all**: Run all tests including integration suite (default)
- **individual**: Run individual component tests only
- **quick**: Run quick smoke tests (services + monitoring)
- **integration**: Run integration test suite only

### Examples

```bash
# Basic usage
./scripts/run-tests.sh

# Test with production configuration
./scripts/run-tests.sh -f examples/test-configurations/production-test.yaml

# Quick smoke tests
./scripts/run-tests.sh -s quick

# Test in custom namespace with verbose output
./scripts/run-tests.sh -n my-supabase -r my-release -v

# Test without cleanup on failure
./scripts/run-tests.sh --no-cleanup
```

## Troubleshooting

### Common Issues

1. **Test Timeout**

   ```bash
   # Increase timeout
   ./scripts/run-tests.sh -t 600s
   ```

2. **Resource Constraints**

   ```bash
   # Use minimal configuration
   ./scripts/run-tests.sh -f examples/test-configurations/minimal-test.yaml
   ```

3. **Network Policy Issues**

   ```bash
   # Check network policy status
   kubectl get networkpolicies -n supabase

   # Disable network policies for testing
   helm upgrade supabase ./charts/supabase -n supabase --set networkPolicy.enabled=false
   ```

4. **Kong Operator Issues**

   ```bash
   # Check Kong Operator status
   kubectl get kongingress,kongplugin,kongconsumer -n supabase

   # Use embedded Kong instead
   helm upgrade supabase ./charts/supabase -n supabase --set kongOperator.enabled=false --set kong.enabled=true
   ```

### Debugging Failed Tests

1. **View Test Logs**

   ```bash
   # Get test pod logs
   kubectl logs -n supabase -l "app.kubernetes.io/name=supabase" --tail=100

   # Get specific test logs
   kubectl logs -n supabase supabase-services-test
   ```

2. **Check Pod Status**

   ```bash
   # Check all pods
   kubectl get pods -n supabase

   # Describe problematic pod
   kubectl describe pod -n supabase <pod-name>
   ```

3. **Check Service Connectivity**

   ```bash
   # Test service connectivity manually
   kubectl run debug --image=curlimages/curl -n supabase --rm -it -- sh

   # Inside the debug pod:
   curl http://supabase-auth:3000/health
   curl http://supabase-rest:3000/
   ```

4. **Check Configuration**

   ```bash
   # View current values
   helm get values supabase -n supabase

   # Check secrets
   kubectl get secrets -n supabase
   ```

## Best Practices

### 1. Test Environment Setup

- Use dedicated test namespaces
- Ensure sufficient cluster resources
- Use appropriate test configurations
- Clean up after testing

### 2. Continuous Integration

```yaml
# Example GitHub Actions workflow
name: Helm Chart Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Kubernetes
        uses: helm/kind-action@v1
      - name: Run Tests
        run: |
          ./scripts/run-tests.sh -f examples/test-configurations/minimal-test.yaml
```

### 3. Production Validation

- Test with production-like configurations
- Validate all security features
- Test scaling scenarios
- Verify monitoring integration
- Test backup and recovery procedures

### 4. Performance Testing

```bash
# Load testing with production config
./scripts/run-tests.sh -f examples/test-configurations/production-test.yaml -v

# Monitor resource usage during tests
kubectl top pods -n supabase
kubectl top nodes
```

## Contributing

When adding new tests:

1. Follow the existing test structure
2. Use conditional execution based on feature flags
3. Include appropriate resource limits
4. Add comprehensive error handling
5. Update this documentation
6. Test with multiple configurations

## Support

For issues with testing:

1. Check the troubleshooting section
2. Review test logs and pod status
3. Verify cluster resources and permissions
4. Test with minimal configuration first
5. Open an issue with detailed logs and configuration
