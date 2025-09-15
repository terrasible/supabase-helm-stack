# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Comprehensive open-source project structure
- Detailed README with installation and configuration guides
- Contributing guidelines and code of conduct
- GitHub issue and pull request templates
- Automated CI/CD workflows for testing and releases
- Comprehensive test suite with Helm tests
- Makefile for development convenience
- Copyright headers and proper licensing
- Security scanning and best practices

### Changed

- Enhanced documentation for better community adoption
- Improved project structure for open-source standards

### Security

- Added security scanning workflows
- Implemented proper secret management guidelines
- Added security considerations in PR template

## [0.1.3] - 2024-01-XX

### Added

- Initial Helm chart structure
- Support for all core Supabase components:
  - PostgreSQL database
  - Auth service
  - REST API
  - Realtime service
  - Storage service
  - Meta service
  - Studio dashboard
  - Functions runtime (optional)
- Kong Gateway for API routing
- MinIO for object storage
- Vector for log aggregation
- Production-ready configurations
- RBAC and security policies
- Network policies
- Pod disruption budgets
- Horizontal Pod Autoscaling
- Ingress configurations
- Service monitoring

### Features

- Multi-environment support (development, staging, production)
- Configurable resource limits and requests
- SSL/TLS termination
- Custom domain support
- Backup and restore capabilities
- Monitoring and observability
- High availability configurations

### Dependencies

- PostgreSQL 12.x
- MinIO for object storage
- Kong Gateway 3.x
- Vector for logging

## [0.1.2] - 2024-01-XX

### Fixed

- Template rendering issues
- Service discovery configurations
- Environment variable handling

### Changed

- Updated default resource allocations
- Improved service mesh integration

## [0.1.1] - 2024-01-XX

### Added

- Basic Helm chart structure
- Core service deployments
- Initial documentation

### Fixed

- Chart validation errors
- Missing template files

## [0.1.0] - 2024-01-XX

### Added

- Initial release
- Basic Supabase deployment capability
- Core services: Auth, REST, Realtime, Storage
- PostgreSQL integration
- Basic configuration options

---

## Release Process

1. Update version in `Chart.yaml`
2. Update `CHANGELOG.md` with new version details
3. Create a new release tag
4. GitHub Actions will automatically:
   - Run tests
   - Package the chart
   - Create GitHub release
   - Update Helm repository

## Version Compatibility

| Chart Version | Supabase Version | Kubernetes Version | Helm Version |
|---------------|------------------|--------------------|--------------|
| 0.1.3+        | Latest           | 1.24+              | 3.8+         |
| 0.1.0-0.1.2   | Latest           | 1.20+              | 3.6+         |

## Migration Guides

### Upgrading from 0.1.x to 0.2.x

*Coming soon - breaking changes will be documented here*

### Upgrading from 0.0.x to 0.1.x

*Initial stable release - no migration needed*

## Support

For questions about releases or upgrade procedures:

- Check the [GitHub Issues](https://github.com/your-username/supabase-helm-stack/issues)
- Review the [Documentation](README.md)
- Join our [Community Discussions](https://github.com/your-username/supabase-helm-stack/discussions)

## Contributing to Changelog

When contributing changes:

1. Add your changes to the `[Unreleased]` section
2. Use the categories: `Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, `Security`
3. Include issue/PR references where applicable
4. Follow the existing format and style

Example entry:

```markdown
### Added
- New feature description (#123)
- Another feature with more details (#124)

### Fixed
- Bug fix description (#125)
```
