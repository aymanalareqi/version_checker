# Contributing to Version Checker

Thank you for your interest in contributing to the version_checker Flutter plugin! We welcome contributions from the community and are grateful for your support.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Contributing Guidelines](#contributing-guidelines)
- [Pull Request Process](#pull-request-process)
- [Issue Reporting](#issue-reporting)
- [Development Workflow](#development-workflow)
- [Testing](#testing)
- [Documentation](#documentation)

## Code of Conduct

This project adheres to a code of conduct that we expect all contributors to follow. Please be respectful and constructive in all interactions.

### Our Standards

- Use welcoming and inclusive language
- Be respectful of differing viewpoints and experiences
- Gracefully accept constructive criticism
- Focus on what is best for the community
- Show empathy towards other community members

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Git
- A code editor (VS Code, Android Studio, or IntelliJ IDEA recommended)

### Fork and Clone

1. Fork the repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/version_checker.git
   cd version_checker
   ```

3. Add the upstream repository:
   ```bash
   git remote add upstream https://github.com/aymanalareqi/version_checker.git
   ```

## Development Setup

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Run tests to ensure everything works:**
   ```bash
   flutter test
   ```

3. **Run the example app:**
   ```bash
   cd example
   flutter pub get
   flutter run
   ```

## Contributing Guidelines

### Types of Contributions

We welcome several types of contributions:

- 🐛 **Bug fixes** - Fix issues and improve stability
- ✨ **New features** - Add new functionality
- 📚 **Documentation** - Improve docs, examples, and guides
- 🧪 **Tests** - Add or improve test coverage
- 🎨 **UI/UX improvements** - Enhance dialog designs and user experience
- 🔧 **Refactoring** - Code improvements and optimizations

### Before You Start

1. **Check existing issues** - Look for existing issues or discussions
2. **Create an issue** - For new features or significant changes, create an issue first
3. **Discuss your approach** - Get feedback before starting major work

### Coding Standards

#### Dart/Flutter Guidelines

- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter analyze` to check for issues
- Format code with `dart format`
- Add dartdoc comments for public APIs
- Use meaningful variable and function names

#### Code Structure

- Keep functions small and focused
- Use proper error handling
- Follow the existing project structure
- Add appropriate logging where needed

#### Example Code Style

```dart
/// Checks for app updates with comprehensive error handling.
/// 
/// Returns a [VersionCheckResponse] containing update information.
/// Throws [TimeoutException] if the request times out.
Future<VersionCheckResponse> checkForUpdates({
  required BuildContext context,
  bool showDialogs = true,
}) async {
  try {
    // Implementation here
  } on TimeoutException {
    // Handle timeout
    rethrow;
  } catch (e) {
    // Handle other errors
    throw VersionCheckException('Failed to check for updates: $e');
  }
}
```

## Pull Request Process

### 1. Create a Branch

Create a descriptive branch name:
```bash
git checkout -b feature/add-web-support
git checkout -b fix/dialog-styling-issue
git checkout -b docs/improve-api-documentation
```

### 2. Make Your Changes

- Write clean, well-documented code
- Add tests for new functionality
- Update documentation as needed
- Ensure all tests pass

### 3. Commit Your Changes

Use clear, descriptive commit messages:
```bash
git commit -m "feat: add web platform support for version checking"
git commit -m "fix: resolve dialog styling issue on iOS"
git commit -m "docs: improve API documentation with examples"
```

### 4. Push and Create PR

```bash
git push origin your-branch-name
```

Then create a pull request on GitHub with:
- Clear title and description
- Reference to related issues
- Screenshots for UI changes
- Test results

### 5. PR Review Process

- Maintainers will review your PR
- Address any feedback or requested changes
- Once approved, your PR will be merged

## Issue Reporting

### Bug Reports

When reporting bugs, please include:

- **Flutter/Dart version**
- **Plugin version**
- **Platform** (iOS, Android, etc.)
- **Steps to reproduce**
- **Expected behavior**
- **Actual behavior**
- **Error messages or logs**
- **Code samples** (if applicable)

### Feature Requests

For feature requests, please provide:

- **Clear description** of the feature
- **Use case** - why is this needed?
- **Proposed implementation** (if you have ideas)
- **Examples** from other libraries (if applicable)

## Development Workflow

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/version_checker_test.dart
```

### Code Analysis

```bash
# Analyze code
flutter analyze

# Format code
dart format .

# Check for outdated dependencies
flutter pub outdated
```

### Example App Testing

```bash
cd example
flutter pub get
flutter run -d ios
flutter run -d android
```

## Testing

### Test Requirements

- All new features must include tests
- Bug fixes should include regression tests
- Maintain or improve test coverage
- Tests should be clear and well-documented

### Test Structure

```dart
group('VersionChecker', () {
  late VersionChecker versionChecker;
  
  setUp(() {
    versionChecker = VersionChecker(
      config: VersionCheckerConfig(
        apiUrl: 'https://test-api.com/version/check',
      ),
    );
  });
  
  test('should check for updates successfully', () async {
    // Test implementation
  });
  
  test('should handle network errors gracefully', () async {
    // Test implementation
  });
});
```

### Widget Testing

```dart
testWidgets('UpdateDialog displays correctly', (WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: UpdateDialog(
        response: mockResponse,
        config: DialogConfig.updateAvailable,
      ),
    ),
  );
  
  expect(find.text('Update Available'), findsOneWidget);
  expect(find.text('Update'), findsOneWidget);
});
```

## Documentation

### Documentation Standards

- Use clear, concise language
- Include code examples
- Add dartdoc comments for all public APIs
- Update README.md for significant changes
- Keep CHANGELOG.md updated

### API Documentation

```dart
/// Checks for app updates and displays appropriate dialogs.
/// 
/// This method performs a version check against the configured API endpoint
/// and automatically displays update dialogs based on the response.
/// 
/// Parameters:
/// - [context]: Build context for showing dialogs
/// - [showDialogs]: Whether to show dialogs automatically
/// 
/// Returns a [Future<VersionCheckResponse>] with update information.
/// 
/// Throws:
/// - [TimeoutException] if the request times out
/// - [SocketException] for network connectivity issues
/// 
/// Example:
/// ```dart
/// final response = await versionChecker.checkForUpdates(
///   context: context,
///   showDialogs: true,
/// );
/// ```
/// 
/// @since 1.0.0
Future<VersionCheckResponse> checkForUpdates({...}) async {
  // Implementation
}
```

## Release Process

### Version Numbering

We follow [Semantic Versioning](https://semver.org/):
- **MAJOR** version for incompatible API changes
- **MINOR** version for backwards-compatible functionality
- **PATCH** version for backwards-compatible bug fixes

### Release Checklist

- [ ] Update version in `pubspec.yaml`
- [ ] Update `CHANGELOG.md`
- [ ] Run all tests
- [ ] Update documentation
- [ ] Create release PR
- [ ] Tag release after merge

## Getting Help

- 📖 **Documentation**: Check the [README](README.md) and [API docs](API.md)
- 💬 **Discussions**: Use [GitHub Discussions](https://github.com/aymanalareqi/version_checker/discussions)
- 🐛 **Issues**: Report bugs via [GitHub Issues](https://github.com/aymanalareqi/version_checker/issues)
- 📧 **Email**: Contact maintainers at support@smartfingers.com

## Recognition

Contributors will be recognized in:
- GitHub contributors list
- CHANGELOG.md for significant contributions
- README.md acknowledgments section

Thank you for contributing to version_checker! 🎉
