# Contributing to CalcMaster

Thank you for your interest in contributing to CalcMaster! This document provides guidelines and information for contributors.

## 🤝 How to Contribute

### Reporting Issues

Before creating an issue, please:
1. Check if the issue already exists
2. Use the appropriate issue template
3. Provide detailed information about the problem
4. Include steps to reproduce the issue
5. Specify your platform and version

### Suggesting Features

We welcome feature suggestions! Please:
1. Check if the feature is already planned
2. Use the feature request template
3. Provide a clear description of the feature
4. Explain the use case and benefits
5. Consider implementation complexity

### Code Contributions

#### Getting Started

1. **Fork the repository**
   ```bash
   git clone https://github.com/yourusername/calcmaster.git
   cd calcmaster
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   flutter packages pub run build_runner build
   ```

4. **Make your changes**
   - Follow the coding standards
   - Add tests for new functionality
   - Update documentation as needed

5. **Test your changes**
   ```bash
   flutter test
   flutter analyze
   ```

6. **Submit a pull request**
   - Use a descriptive title
   - Provide a detailed description
   - Link any related issues

#### Coding Standards

- **Dart/Flutter**: Follow the official Dart style guide
- **Naming**: Use descriptive, clear names for variables and functions
- **Comments**: Add comments for complex logic
- **Documentation**: Update relevant documentation
- **Testing**: Add tests for new features and bug fixes

#### Code Style

```dart
// Good
class CalculatorLogic {
  static double calculate(String expression) {
    // Implementation
  }
}

// Bad
class calc {
  static double calc(String exp) {
    // Implementation
  }
}
```

#### Commit Messages

Use clear, descriptive commit messages:

```
feat: add matrix multiplication functionality
fix: resolve calculation error in scientific mode
docs: update README with new features
test: add unit tests for geometry calculations
refactor: improve performance of chart rendering
```

### Testing

#### Unit Tests
- Test all calculation functions
- Verify edge cases and error handling
- Test theme switching and persistence
- Test encryption/decryption functionality

#### Widget Tests
- Test UI components
- Verify user interactions
- Test responsive layouts
- Test accessibility features

#### Integration Tests
- Test complete user workflows
- Test cross-platform compatibility
- Test performance under load
- Test offline functionality

### Documentation

#### Code Documentation
- Add doc comments for public APIs
- Explain complex algorithms
- Document configuration options
- Update inline comments

#### User Documentation
- Update README for new features
- Add screenshots for UI changes
- Update changelog
- Create user guides for complex features

## 🏗️ Development Setup

### Prerequisites
- Flutter SDK 3.7.2+
- Dart SDK 3.0+
- Android Studio / Xcode
- VS Code (recommended)

### Environment Setup

1. **Clone and setup**
   ```bash
   git clone https://github.com/yourusername/calcmaster.git
   cd calcmaster
   flutter pub get
   ```

2. **Generate code**
   ```bash
   flutter packages pub run build_runner build
   ```

3. **Run tests**
   ```bash
   flutter test
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Project Structure

```
lib/
├── core/                 # Business logic
├── ui/                   # User interface
│   ├── screens/         # App screens
│   ├── widgets/         # Reusable widgets
│   ├── themes/          # Theme definitions
│   └── animations/      # Animation components
├── services/            # External services
├── models/              # Data models
├── providers/           # State management
└── main.dart           # App entry point

test/
├── unit/               # Unit tests
├── widget/             # Widget tests
└── integration/        # Integration tests
```

## 🐛 Bug Reports

When reporting bugs, please include:

1. **Environment**
   - Flutter version
   - Dart version
   - Platform (Android/iOS/Web/Desktop)
   - Device/OS version

2. **Steps to Reproduce**
   - Clear, numbered steps
   - Expected vs actual behavior
   - Screenshots or videos if helpful

3. **Additional Information**
   - Error messages or logs
   - Related issues
   - Workarounds if any

## 💡 Feature Requests

When suggesting features:

1. **Problem Description**
   - What problem does this solve?
   - Who would benefit from this feature?

2. **Proposed Solution**
   - How should this feature work?
   - Any design considerations?

3. **Alternatives**
   - Other ways to solve this problem?
   - Existing workarounds?

## 📋 Pull Request Process

### Before Submitting

1. **Code Quality**
   - Run `flutter analyze`
   - Fix all linting issues
   - Ensure tests pass
   - Update documentation

2. **Testing**
   - Add tests for new features
   - Test on multiple platforms
   - Verify performance impact

3. **Documentation**
   - Update relevant docs
   - Add code comments
   - Update changelog

### Pull Request Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests pass
- [ ] Widget tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] Tests added/updated
```

## 🏷️ Release Process

### Version Numbering
We use [Semantic Versioning](https://semver.org/):
- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

### Release Checklist
- [ ] All tests pass
- [ ] Documentation updated
- [ ] Changelog updated
- [ ] Version bumped
- [ ] Release notes prepared
- [ ] Platform-specific builds tested

## 🤔 Questions?

- **Discussions**: [GitHub Discussions](https://github.com/yourusername/calcmaster/discussions)
- **Issues**: [GitHub Issues](https://github.com/yourusername/calcmaster/issues)
- **Email**: contributors@calcmaster.app

## 📜 Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive environment for all contributors.

### Expected Behavior

- Be respectful and inclusive
- Use welcoming and inclusive language
- Accept constructive criticism gracefully
- Focus on what's best for the community
- Show empathy towards other community members

### Unacceptable Behavior

- Harassment or discrimination
- Trolling or inflammatory comments
- Personal attacks or political discussions
- Public or private harassment
- Any conduct inappropriate in a professional setting

## 📄 License

By contributing to CalcMaster, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to CalcMaster! 🎉
