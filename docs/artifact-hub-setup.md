# Artifact Hub Integration

This document describes how to integrate the Supabase Helm Stack with [Artifact Hub](https://artifacthub.io/) for chart discovery and publishing.

## Overview

Artifact Hub is a web-based application that enables finding, installing, and publishing Cloud Native packages. Unlike other package registries, Artifact Hub works by scanning your existing Helm repository automatically once it's added to their platform.

## How Artifact Hub Works

Artifact Hub uses a **scan-based approach** rather than direct publishing:

1. **Manual Repository Addition**: You add your repository once manually to Artifact Hub through their web UI
2. **Automatic Scanning**: Artifact Hub then scans your repository periodically for changes
3. **Automatic Updates**: New chart versions are automatically detected and published
4. **No API Required**: No GitHub Actions or API tokens needed for publishing

## Configuration

### Chart.yaml Annotations

The `Chart.yaml` file includes specific annotations for Artifact Hub:

```yaml
annotations:
  # Artifact Hub annotations
  artifacthub.io/category: database
  artifacthub.io/license: Apache-2.0
  artifacthub.io/prerelease: "false"
  artifacthub.io/operator: "false"
  artifacthub.io/securityUpdates: "false"
  artifacthub.io/changes: |
    - kind: added
      description: Initial Supabase Helm chart with enterprise features
    - kind: added
      description: Kong Operator integration for API gateway
    - kind: added
      description: Comprehensive monitoring with Prometheus and Grafana
    - kind: added
      description: Security enhancements and RBAC configurations
  artifacthub.io/links: |
    - name: Chart Source
      url: https://github.com/your-org/supabase-helm-stack
    - name: Supabase Documentation
      url: https://supabase.com/docs
```

### Repository Metadata

The `artifacthub-repo.yml` file provides repository-level metadata:

```yaml
repositoryID: supabase-helm-stack
displayName: Supabase Helm Stack
description: Production-ready Helm chart for deploying Supabase on Kubernetes
url: https://github.com/your-org/supabase-helm-stack
branch: main
ignore:
  - name: "*-dev"
  - name: "*-test"
data:
  logoURL: https://supabase.com/favicon/favicon-32x32.png
  links:
    - name: GitHub Repository
      url: https://github.com/your-org/supabase-helm-stack
    - name: Documentation
      url: https://github.com/your-org/supabase-helm-stack/blob/main/README.md
```

## Setup Process

### Step 1: Prepare Your Repository

Ensure your repository has:

- ✅ `Chart.yaml` with Artifact Hub annotations
- ✅ `artifacthub-repo.yml` in the repository root
- ✅ Comprehensive `README.md` for chart documentation
- ✅ Valid Helm chart structure

### Step 2: Add Repository to Artifact Hub

1. Visit [artifacthub.io](https://artifacthub.io/)
2. Sign in with your GitHub account
3. Click "Add Repository"
4. Select "Helm charts" as the repository kind
5. Enter your repository URL: `https://github.com/your-org/supabase-helm-stack`
6. Configure any additional settings
7. Submit the repository

### Step 3: Verification

After adding your repository:

1. Artifact Hub will scan your repository
2. Your chart should appear in search results within a few minutes
3. Verify the chart information and metadata are correct

## Publishing Process

Once your repository is added to Artifact Hub:

1. **Automatic Detection**: When you create a new release, Artifact Hub automatically detects it during the next scan
2. **No Manual Action**: No additional steps required in your CI/CD pipeline
3. **Metadata Updates**: Changes to `Chart.yaml` annotations are automatically reflected

## Verification

After a successful release, you can verify the publication by:

1. Visiting [Artifact Hub](https://artifacthub.io/)
2. Searching for "supabase-helm-stack"
3. Confirming your chart appears in the search results

## Chart Discovery

Once published, users can discover and install your chart through:

- **Artifact Hub Web Interface**: Browse and view chart details
- **Helm CLI**: `helm repo add supabase-helm-stack https://artifacthub.io/packages/helm/supabase-helm-stack`
- **Direct Installation**: `helm install my-supabase oci://artifacthub.io/supabase-helm-stack/supabase`

## Maintenance

### Updating Chart Information

To update chart information on Artifact Hub:

1. Modify the annotations in `Chart.yaml`
2. Update the `artifacthub-repo.yml` file if needed
3. Create a new release

### Security Updates

When releasing security updates, set:

```yaml
annotations:
  artifacthub.io/containsSecurityUpdates: "true"
```

This will highlight the release as containing security fixes on Artifact Hub.

## Best Practices

1. **Keep annotations up-to-date**: Regularly update the `artifacthub.io/changes` annotation
2. **Use semantic versioning**: Follow semver for chart versions
3. **Provide comprehensive documentation**: Include detailed README and examples
4. **Maintain security**: Regularly update dependencies and scan for vulnerabilities
5. **Monitor metrics**: Use Artifact Hub analytics to understand chart usage

## Troubleshooting

### Common Issues

1. **Publishing fails**: Check that `ARTIFACTHUB_TOKEN` is correctly set
2. **Chart not appearing**: Verify repository metadata and wait for indexing
3. **Metadata not updating**: Ensure Chart.yaml annotations are properly formatted

### Support

For Artifact Hub-specific issues:

- [Artifact Hub Documentation](https://artifacthub.io/docs)
- [Artifact Hub GitHub Repository](https://github.com/artifacthub/hub)
