# Contributing to Supabase Helm Stack

Thank you for your interest in contributing to the Supabase Helm Stack! This document provides guidelines and information for contributors.

## 🤝 Code of Conduct

By participating in this project, you agree to abide by our [Code of Conduct](CODE_OF_CONDUCT.md). Please read it before contributing.

## 🚀 Getting Started

### Prerequisites

- Kubernetes cluster (local or remote)
- Helm 3.8+
- kubectl configured
- Git
- Make (optional, for automation)

### Development Setup

1. **Fork and Clone**

   ```bash
   git clone https://github.com/your-username/supabase-helm-stack.git
   cd supabase-helm-stack
   ```

2. **Install Dependencies**

   ```bash
   helm dependency update ./charts/supabase
   ```

3. **Verify Setup**

   ```bash
   helm lint ./charts/supabase
   helm template test ./charts/supabase --debug
   ```

## 📝 How to Contribute

### Reporting Issues

1. **Search Existing Issues**: Check if your issue already exists
2. **Use Issue Templates**: Follow the provided templates
3. **Provide Details**: Include:
   - Kubernetes version
   - Helm version
   - Chart version
   - Steps to reproduce
   - Expected vs actual behavior
   - Relevant logs

### Suggesting Features

1. **Open a Discussion**: Start with a GitHub Discussion
2. **Describe the Use Case**: Explain why this feature is needed
3. **Propose Implementation**: If you have ideas on how to implement it

### Submitting Changes

1. **Create a Branch**

   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make Changes**
   - Follow coding standards
   - Update documentation
   - Add tests if applicable

3. **Test Your Changes**

   ```bash
   # Lint the chart
   helm lint ./charts/supabase

   # Test template rendering
   helm template test ./charts/supabase --debug

   # Test installation (if possible)
   helm install test ./charts/supabase --dry-run
   ```

4. **Commit Changes**

   ```bash
   git add .
   git commit -m "feat: add new feature description"
   ```

5. **Push and Create PR**

   ```bash
   git push origin feature/your-feature-name
   ```

## 📋 Development Guidelines

### Helm Chart Standards

1. **Follow Helm Best Practices**
   - Use semantic versioning
   - Include proper labels and annotations
   - Use helper templates for common patterns
   - Validate input values

2. **Template Structure**

   ```text
   templates/
   ├── _helpers.tpl          # Common template helpers
   ├── NOTES.txt            # Installation notes
   ├── component/
   │   ├── _helpers.tpl     # Component-specific helpers
   │   ├── deployment.yaml  # Main deployment
   │   ├── service.yaml     # Service definition
   │   ├── configmap.yaml   # Configuration
   │   ├── secret.yaml      # Secrets (if needed)
   │   ├── ingress.yaml     # Ingress (if applicable)
   │   ├── networkpolicy.yaml # Network policies
   │   ├── serviceaccount.yaml # Service account
   │   ├── rbac.yaml        # RBAC resources
   │   └── servicemonitor.yaml # Monitoring
   ```

3. **Values Structure**

   ```yaml
   component:
     enabled: true
     image:
       repository: ""
       tag: ""
       pullPolicy: IfNotPresent
     replicaCount: 1
     resources: {}
     nodeSelector: {}
     tolerations: []
     affinity: {}
     podAnnotations: {}
     podLabels: {}
     securityContext: {}
     service:
       type: ClusterIP
       port: 80
     ingress:
       enabled: false
     autoscaling:
       enabled: false
   ```

### Code Style

1. **YAML Formatting**
   - Use 2 spaces for indentation
   - No trailing whitespace
   - Consistent key ordering

2. **Template Conventions**

   ```yaml
   # Good: Use consistent naming
   {{- include "supabase.fullname" . }}-component

   # Good: Proper indentation in templates
   spec:
     {{- with .Values.nodeSelector }}
     nodeSelector:
       {{- toYaml . | nindent 8 }}
     {{- end }}

   # Good: Use default values
   image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
   ```

3. **Documentation**
   - Comment complex template logic
   - Document all values in values.yaml
   - Update README for new features

### Testing

1. **Required Tests**

   ```bash
   # Helm lint
   helm lint ./charts/supabase

   # Template validation
   helm template test ./charts/supabase --debug

   # Dry run installation
   helm install test ./charts/supabase --dry-run
   ```

2. **Optional Tests**

   ```bash
   # Full installation test
   helm install test ./charts/supabase
   helm test test
   helm uninstall test
   ```

### Security Considerations

1. **Secrets Management**
   - Never hardcode secrets
   - Use Kubernetes secrets
   - Support external secret management

2. **RBAC**
   - Follow principle of least privilege
   - Document required permissions
   - Make RBAC configurable

3. **Network Policies**
   - Include network policy templates
   - Document network requirements
   - Support different CNI implementations

## 🔄 Pull Request Process

### PR Requirements

1. **Description**: Clear description of changes
2. **Testing**: Evidence of testing
3. **Documentation**: Updated docs if needed
4. **Breaking Changes**: Clearly marked and documented
5. **Changelog**: Update if significant change

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Helm lint passes
- [ ] Template rendering works
- [ ] Dry run installation succeeds
- [ ] Full installation tested (if applicable)

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] Tests added/updated
```

### Review Process

1. **Automated Checks**: CI/CD must pass
2. **Code Review**: At least one maintainer review
3. **Testing**: Reviewer may test changes
4. **Approval**: Maintainer approval required
5. **Merge**: Squash and merge preferred

## 🏷️ Versioning and Releases

### Semantic Versioning

- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

### Release Process

1. **Version Bump**: Update Chart.yaml version
2. **Changelog**: Update CHANGELOG.md
3. **Tag**: Create git tag
4. **Release**: GitHub release with notes
5. **Package**: Update Helm repository

## 🎯 Areas for Contribution

### High Priority

- [ ] Improve test coverage
- [ ] Add more configuration examples
- [ ] Enhance security features
- [ ] Performance optimizations
- [ ] Documentation improvements

### Medium Priority

- [ ] Additional monitoring integrations
- [ ] Multi-cloud support
- [ ] Backup and restore procedures
- [ ] Migration guides
- [ ] Troubleshooting guides

### Low Priority

- [ ] Additional deployment strategies
- [ ] Integration with service meshes
- [ ] Advanced networking features
- [ ] Custom resource definitions

## 📚 Resources

### Documentation

- [Helm Documentation](https://helm.sh/docs/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Supabase Documentation](https://supabase.com/docs)

### Tools

- [Helm](https://helm.sh/)
- [kubectl](https://kubernetes.io/docs/reference/kubectl/)
- [kubeval](https://github.com/instrumenta/kubeval)
- [helm-docs](https://github.com/norwoodj/helm-docs)

### Community

- [GitHub Discussions](https://github.com/your-username/supabase-helm-stack/discussions)
- [Issues](https://github.com/your-username/supabase-helm-stack/issues)
- [Supabase Community](https://supabase.com/community)

## 🆘 Getting Help

If you need help:

1. **Check Documentation**: README and this guide
2. **Search Issues**: Existing issues and discussions
3. **Ask Questions**: GitHub Discussions
4. **Contact Maintainers**: Tag maintainers in issues

## 🙏 Recognition

Contributors will be:

- Listed in CONTRIBUTORS.md
- Mentioned in release notes
- Credited in documentation
- Invited to maintainer team (for significant contributions)

Thank you for contributing to the Supabase Helm Stack! 🎉
