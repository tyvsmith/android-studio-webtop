# Contributing to Android Studio Webtop

Thank you for your interest in contributing to Android Studio Webtop! This document provides guidelines and instructions for contributing to the project.

## Table of Contents

1. [Code of Conduct](#code-of-conduct)
2. [Getting Started](#getting-started)
3. [How to Contribute](#how-to-contribute)
4. [Development Setup](#development-setup)
5. [Submitting Changes](#submitting-changes)
6. [Style Guidelines](#style-guidelines)
7. [Testing](#testing)
8. [Documentation](#documentation)
9. [Community](#community)

## Code of Conduct

By participating in this project, you agree to abide by our Code of Conduct:

- Be respectful and inclusive
- Welcome newcomers and help them get started
- Focus on constructive criticism
- Respect differing viewpoints and experiences
- Show empathy towards other community members

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/your-username/android-studio-webtop.git
   cd android-studio-webtop
   ```
3. **Add the upstream remote**:
   ```bash
   git remote add upstream https://github.com/tyvsmith/android-studio-webtop.git
   ```
4. **Create a new branch** for your feature or fix:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## How to Contribute

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates. When creating a bug report, include:

- A clear and descriptive title
- Steps to reproduce the issue
- Expected behavior
- Actual behavior
- System information (OS, Docker version, etc.)
- Relevant logs or error messages
- Screenshots if applicable

### Suggesting Enhancements

Enhancement suggestions are welcome! Please provide:

- A clear and descriptive title
- Detailed description of the proposed enhancement
- Use cases and benefits
- Possible implementation approach
- Any potential drawbacks or considerations

### Pull Requests

1. **Small, focused changes**: Keep PRs focused on a single feature or fix
2. **Test your changes**: Ensure all tests pass and add new tests if needed
3. **Update documentation**: Include relevant documentation updates
4. **Follow style guidelines**: Maintain consistency with existing code
5. **Write clear commit messages**: Use conventional commit format

## Development Setup

### Prerequisites

- Docker Desktop or Docker Engine (20.10+)
- Docker Compose (2.0+)
- Git
- VS Code (recommended)

### Local Development

1. **Build the development container**:
   ```bash
   cd .devcontainer
   docker-compose build
   ```

2. **Run the container**:
   ```bash
   docker-compose up -d
   ```

3. **Access the environment**:
   - Web UI: http://localhost:3000
   - Terminal: `docker exec -it android-studio-dev bash`

### Making Changes

1. **DevContainer Development**:
   - Modify files in `.devcontainer/`
   - Test changes by rebuilding: `docker-compose build`

2. **Script Development**:
   - Edit scripts in `scripts/`
   - Test in running container

3. **Documentation**:
   - Update markdown files in `docs/`
   - Ensure links are valid

## Submitting Changes

### Commit Message Format

We use conventional commits format:

```
type(scope): subject

body

footer
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Test additions or modifications
- `chore`: Maintenance tasks
- `perf`: Performance improvements

**Examples**:
```bash
feat(sdk): add Android SDK 35 support
fix(docker): resolve KVM permission issue
docs(setup): update installation instructions
```

### Pull Request Process

1. **Update your fork**:
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

2. **Push your changes**:
   ```bash
   git push origin feature/your-feature-name
   ```

3. **Create a Pull Request**:
   - Go to GitHub and create a PR from your fork
   - Fill in the PR template
   - Link related issues
   - Request reviews if needed

4. **Address review feedback**:
   - Make requested changes
   - Push updates to the same branch
   - Respond to comments

## Style Guidelines

### Docker/Dockerfile

- Use multi-stage builds when possible
- Minimize layers
- Order commands from least to most frequently changing
- Use specific versions for base images
- Add comments for complex operations

### Shell Scripts

- Use `#!/bin/bash` shebang
- Set `set -euo pipefail` for error handling
- Use meaningful variable names
- Add comments for complex logic
- Follow [ShellCheck](https://www.shellcheck.net/) recommendations

### Documentation

- Use clear, concise language
- Include code examples
- Add table of contents for long documents
- Keep line length under 120 characters
- Use proper markdown formatting

## Testing

### Running Tests

1. **Build tests**:
   ```bash
   ./scripts/test-build.sh
   ```

2. **Integration tests**:
   ```bash
   ./scripts/test-integration.sh
   ```

3. **Manual testing checklist**:
   - [ ] Container builds successfully
   - [ ] Android Studio launches
   - [ ] Web interface is accessible
   - [ ] SDK tools work correctly
   - [ ] Emulator runs (if KVM available)
   - [ ] File persistence works

### Adding Tests

- Add test scripts to `scripts/tests/`
- Document test purpose and expected outcomes
- Ensure tests are idempotent
- Include both positive and negative test cases

## Documentation

### Areas Needing Documentation

- New features or significant changes
- Configuration options
- Troubleshooting guides
- API or interface changes
- Performance optimizations

### Documentation Standards

- Keep README.md updated
- Add detailed guides to `docs/`
- Include examples and use cases
- Update CHANGELOG.md
- Add inline code comments

## Community

### Getting Help

- **Issues**: Check existing issues or create new ones
- **Discussions**: Use GitHub Discussions for questions
- **Discord**: Join our community server (link in README)

### Helping Others

- Answer questions in issues and discussions
- Review pull requests
- Improve documentation
- Share your use cases and experiences

## Recognition

Contributors will be recognized in:
- The project README
- Release notes
- Special thanks in documentation

Thank you for contributing to Android Studio Webtop! Your efforts help make Android development more accessible to everyone.