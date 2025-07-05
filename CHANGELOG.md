# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-01-05

### Added
- 🎉 **Initial release** of the version_checker Flutter plugin
- ✨ **Core version checking functionality** with API integration
- 🎨 **Customizable dialog widgets** for update notifications
  - `UpdateDialog` - Standard update dialog with customizable styling
  - `ForceUpdateDialog` - Mandatory update dialog for critical updates
  - `ErrorDialog` - Error handling dialog with retry functionality
- 🔧 **Comprehensive configuration options**
  - `VersionCheckerConfig` for API and caching settings
  - `DialogConfig` for complete dialog customization
- 🌐 **Multi-language support** with localized release notes
- ⚡ **Built-in caching system** for improved performance
- 📱 **Cross-platform support** for iOS and Android
- 🛠️ **Robust error handling** with automatic retry mechanisms
- 🎯 **Force update support** for mandatory app updates
- 📊 **Semantic version comparison** with custom version comparator
- 🔄 **HTTP client abstraction** for easy testing and mocking
- 📝 **Comprehensive documentation** with examples and API reference
- 🧪 **Complete test suite** with 77 unit tests covering all components
- 📱 **Example app** demonstrating all plugin features

### Features
- **API Integration**: RESTful API integration with customizable endpoints
- **Smart Caching**: Configurable response caching with expiration
- **Version Comparison**: Intelligent semantic version comparison
- **Dialog Customization**: Fully customizable dialog appearance and behavior
- **Platform Detection**: Automatic iOS/Android platform detection
- **Locale Support**: Multi-language support for international apps
- **Error Recovery**: Automatic retry mechanisms with user-friendly error dialogs
- **Flexible Configuration**: Extensive configuration options for all aspects

### Technical Details
- **Minimum Flutter Version**: 3.0.0
- **Minimum Dart SDK**: 3.0.0
- **Dependencies**:
  - `http: ^1.1.0` - HTTP client for API requests
  - `package_info_plus: ^4.2.0` - App version information
  - `shared_preferences: ^2.2.2` - Local caching storage
- **Dev Dependencies**:
  - `flutter_test` - Testing framework
  - `mockito: ^5.4.4` - Mocking for unit tests
  - `build_runner: ^2.4.9` - Code generation
  - `flutter_lints: ^3.0.0` - Linting rules

### Package Structure
```
lib/
├── src/
│   ├── models/
│   │   ├── dialog_config.dart
│   │   ├── version_check_request.dart
│   │   ├── version_check_response.dart
│   │   └── version_checker_config.dart
│   ├── services/
│   │   └── version_checker_service.dart
│   ├── utils/
│   │   └── version_comparator.dart
│   ├── widgets/
│   │   ├── error_dialog.dart
│   │   ├── force_update_dialog.dart
│   │   └── update_dialog.dart
│   └── version_checker_plugin.dart
└── version_checker.dart
```

### API Compatibility
- **Request Format**: JSON POST with `current_version`, `platform`, and `locale`
- **Response Format**: JSON with `success`, version info, and update details
- **Error Handling**: Comprehensive error responses with user-friendly messages

### Testing Coverage
- **77 Unit Tests** covering all major components:
  - VersionComparator utility functions
  - API request/response models
  - Version checker service logic
  - All dialog widget functionality
  - Error handling scenarios
  - Caching mechanisms

### Documentation
- **Complete README** with usage examples and API reference
- **Inline Documentation** with dartdoc comments for all public APIs
- **Example App** demonstrating real-world usage
- **API Integration Guide** with request/response formats

### Platform Support
- ✅ **Android**: Full support with Google Play Store integration
- ✅ **iOS**: Full support with App Store integration
- ⏳ **Web**: Planned for future release
- ⏳ **Desktop**: Planned for future release

---

## [Unreleased]

### Planned Features
- 🌐 **Web platform support** - Flutter web compatibility
- 🖥️ **Desktop platform support** - Windows, macOS, and Linux
- 🔔 **Push notification integration** - Background update notifications
- 📈 **Analytics integration** - Update adoption tracking
- 🎨 **Additional dialog themes** - Pre-built beautiful dialog designs
- 🔄 **Automatic update scheduling** - Background update checking
- 📱 **In-app update support** - Native in-app update flows
- 🌍 **Extended localization** - More language support
- 🔧 **Advanced configuration** - More granular control options

### Future Enhancements
- **Performance Optimizations**: Further caching improvements
- **UI/UX Improvements**: Enhanced dialog animations and transitions
- **Developer Experience**: Better debugging tools and error messages
- **Integration Examples**: More platform-specific integration guides

---

## Version History Summary

| Version | Release Date | Key Features |
|---------|--------------|--------------|
| 1.0.0   | 2025-01-05   | Initial release with full feature set |

---

## Migration Guide

### From Pre-release to 1.0.0
This is the initial stable release. No migration needed.

### Breaking Changes
None in this release.

---

## Support and Feedback

- 🐛 **Bug Reports**: [GitHub Issues](https://github.com/aymanalareqi/version_checker/issues)
- 💡 **Feature Requests**: [GitHub Discussions](https://github.com/aymanalareqi/version_checker/discussions)
- 📧 **Support**: support@smartfingers.com
- 📖 **Documentation**: [pub.dev](https://pub.dev/packages/version_checker)

---

*For more detailed information about each release, please refer to the [GitHub Releases](https://github.com/aymanalareqi/version_checker/releases) page.*
