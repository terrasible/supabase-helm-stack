# Pre-commit Setup Guide

This project uses [pre-commit](https://pre-commit.com/) to ensure code quality and consistency across all contributions.

## Installation

### 1. Install pre-commit

```bash
# Using pip
pip install pre-commit

# Using homebrew (macOS)
brew install pre-commit

# Using conda
conda install -c conda-forge pre-commit
```

### 2. Install the git hook scripts

```bash
pre-commit install
```

### 3. Install commit-msg hook (for conventional commits)

```bash
pre-commit install --hook-type commit-msg
```

## Usage

### Automatic execution

Once installed, pre-commit will run automatically on `git commit`. If any hooks fail, the commit will be aborted and you'll need to fix the issues before committing again.

### Manual execution

```bash
# Run on all files
pre-commit run --all-files

# Run on specific files
pre-commit run --files charts/supabase/values.yaml

# Run specific hook
pre-commit run yamllint --all-files
```

## Hooks Included

### Code Quality

- **trailing-whitespace**: Removes trailing whitespace
- **end-of-file-fixer**: Ensures files end with a newline
- **check-yaml**: Validates YAML syntax
- **check-json**: Validates JSON syntax
- **mixed-line-ending**: Ensures consistent line endings

### YAML & Helm

- **yamllint**: Lints YAML files according to `.yamllint.yaml`
- **helmlint**: Validates Helm charts
- **kubeval**: Validates Kubernetes YAML manifests

### Security

- **detect-secrets**: Scans for potential secrets in code
- **gitleaks**: Detects Git secrets and credential leaks (configured with .gitleaks.toml to ignore example secrets in YAML/MD files)

### Documentation

- **markdownlint**: Lints Markdown files

### Shell & Docker

- **shellcheck**: Lints shell scripts
- **hadolint**: Lints Dockerfiles

### Git

- **commitizen**: Enforces conventional commit messages

## Configuration Files

- `.pre-commit-config.yaml`: Main pre-commit configuration
- `.yamllint.yaml`: YAML linting rules
- `.secrets.baseline`: Baseline for secret detection

## Troubleshooting

### Skipping hooks temporarily

```bash
# Skip all hooks
git commit --no-verify -m "commit message"

# Skip specific hook
SKIP=yamllint git commit -m "commit message"
```

### Updating hooks

```bash
pre-commit autoupdate
```

### Common issues

1. **YAML formatting errors**: Run `yamllint` manually to see detailed errors
2. **Helm lint failures**: Ensure your chart follows Helm best practices
3. **Secret detection**: Add false positives to `.secrets.baseline`

## Best Practices

1. Run `pre-commit run --all-files` before pushing
2. Keep commits small and focused
3. Use conventional commit messages
4. Fix linting issues before committing
5. Update hooks regularly with `pre-commit autoupdate`

## Conventional Commits

This project follows [Conventional Commits](https://www.conventionalcommits.org/) specification:

```text
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks
- `ci`: CI/CD changes

### Examples

```text
feat(auth): add JWT token validation
fix(storage): resolve S3 connection timeout
docs: update installation guide
chore: update dependencies
```
