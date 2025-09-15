## Description

Please include a summary of the changes and the related issue. Include relevant motivation and context.

Fixes # (issue)

## Type of Change

Please delete options that are not relevant.

- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update
- [ ] Refactoring (no functional changes)
- [ ] Performance improvement
- [ ] Security improvement

## Component(s) Affected

Please check all that apply:

- [ ] Chart structure/metadata
- [ ] Auth service
- [ ] REST API service
- [ ] Realtime service
- [ ] Storage service
- [ ] Meta service
- [ ] Studio dashboard
- [ ] Functions runtime
- [ ] Kong gateway
- [ ] PostgreSQL
- [ ] MinIO
- [ ] Monitoring/metrics
- [ ] Security/RBAC
- [ ] Documentation
- [ ] CI/CD

## Testing

Please describe the tests that you ran to verify your changes:

- [ ] Helm lint passes (`helm lint ./charts/supabase`)
- [ ] Template rendering works (`helm template test ./charts/supabase --debug`)
- [ ] Dry run installation succeeds (`helm install test ./charts/supabase --dry-run`)
- [ ] Full installation tested locally
- [ ] Helm tests pass (`helm test <release-name>`)
- [ ] Manual testing performed

### Test Configuration

```yaml
# Please provide the values.yaml configuration used for testing
# Remove any sensitive information
global:
  environment: development

# ... your test configuration
```

### Test Environment

- **Kubernetes version**:
- **Helm version**:
- **Platform**: (minikube, kind, EKS, GKE, etc.)

## Breaking Changes

If this is a breaking change, please describe:

1. What breaks?
2. How to migrate from the previous version?
3. Why is this change necessary?

## Documentation

- [ ] I have updated the README.md if needed
- [ ] I have updated the values.yaml comments
- [ ] I have updated the Chart.yaml if needed
- [ ] I have added/updated examples if applicable
- [ ] I have updated the CHANGELOG.md (for significant changes)

## Security Considerations

- [ ] This change does not introduce new security vulnerabilities
- [ ] I have reviewed the security implications of this change
- [ ] Secrets are properly managed (not hardcoded)
- [ ] RBAC permissions follow the principle of least privilege
- [ ] Network policies are updated if needed

## Performance Impact

- [ ] This change does not negatively impact performance
- [ ] I have considered the resource usage implications
- [ ] Resource requests/limits are appropriate

## Checklist

Please check all that apply:

- [ ] My code follows the style guidelines of this project
- [ ] I have performed a self-review of my own code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] New and existing unit tests pass locally with my changes
- [ ] Any dependent changes have been merged and published

## Screenshots (if applicable)

<!-- Add screenshots to help explain your changes -->

## Additional Notes

<!-- Add any additional notes, concerns, or questions for reviewers -->

## Reviewer Checklist

<!-- For maintainers/reviewers -->

- [ ] Code review completed
- [ ] Documentation review completed
- [ ] Security review completed (if applicable)
- [ ] Performance review completed (if applicable)
- [ ] Breaking changes properly documented
- [ ] Tests are adequate
- [ ] CI/CD checks pass

---

**Thank you for contributing to the Supabase Helm Stack! 🎉**
