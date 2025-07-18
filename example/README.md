# Version Checker Example App

A comprehensive example app demonstrating all features of the `version_checker` Flutter plugin.

## Overview

This example app showcases the complete functionality of the version_checker plugin, including:

- ✨ **Basic version checking** with default dialogs
- 🎨 **Custom dialog styling** and configuration
- 🔄 **Force update scenarios** for mandatory updates
- 🛠️ **Error handling** with retry functionality
- 🌐 **API integration** with real endpoints
- 📱 **Cross-platform support** (iOS & Android)
- 🎯 **Different update scenarios** and user flows

## Features Demonstrated

### 1. Basic Version Check
- Simple version checking with minimal configuration
- Default dialog styling and behavior
- Automatic platform detection

### 2. Custom Dialog Styling
- Customized dialog appearance with colors, fonts, and icons
- Custom button text and styling
- Configurable dialog behavior (dismissible, button visibility)

### 3. Force Update Flow
- Mandatory update scenarios
- Non-dismissible dialogs for critical updates
- Different messaging for force updates

### 4. Error Handling
- Network error scenarios with retry functionality
- API error responses with user-friendly messages
- Offline handling and graceful degradation

### 5. API Integration
- Real API endpoint integration
- Request/response handling
- Caching demonstration

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- iOS Simulator or Android Emulator (or physical device)

### Installation Options

#### Option 1: Using the Plugin in Your Own Project

1. **Create a new Flutter project** (or use existing):
   ```bash
   flutter create my_version_checker_app
   cd my_version_checker_app
   ```

2. **Add the dependency** to your `pubspec.yaml`:
   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     version_checker:
       git:
         url: https://github.com/aymanalareqi/version_checker.git
         ref: main  # Use main branch for latest updates
   ```

3. **Install dependencies**:
   ```bash
   flutter pub get
   ```

4. **Copy example code** from this directory or follow the usage examples in the main README.

#### Option 2: Running the Example App Directly

1. **Clone the repository**:
   ```bash
   git clone https://github.com/aymanalareqi/version_checker.git
   cd version_checker/example
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

### Running on Specific Platforms

**iOS:**
```bash
flutter run -d ios
```

**Android:**
```bash
flutter run -d android
```

**Web (when supported):**
```bash
flutter run -d chrome
```

## App Structure

The example app is organized into several demonstration screens:

### Main Screen
- Overview of all available demos
- Quick access to different scenarios
- Plugin information and version display

### Demo Screens

1. **Basic Demo** (`/basic`)
   - Simple version check implementation
   - Default dialog behavior
   - Minimal configuration example

2. **Custom Styling Demo** (`/custom`)
   - Fully customized dialog appearance
   - Custom colors, fonts, and styling
   - Advanced configuration options

3. **Enhanced Icons & Shapes Demo**
   - Custom icon configurations with different colors and sizes
   - Shaped dialogs with borders and custom styling
   - Download, security, and modern icon themes
   - Error simulation with custom error dialogs

4. **Modern Circular Design Demo**
   - Circular and stadium-shaped dialogs
   - Modern icon themes (rocket launch, priority high)
   - Advanced shape customization examples
   - Contemporary UI design patterns

5. **Text Customization Demo**
   - Dynamic placeholder substitution with {currentVersion}, {latestVersion}
   - Custom text properties for all dialog elements
   - Localization support with Spanish example
   - Custom placeholder support for app-specific variables

6. **Localized Dialogs Demo**
   - Spanish language interface demonstration
   - Localized text with cultural formatting
   - Custom placeholder integration for localized content
   - Multi-language support patterns

8. **Force Update Demo** (`/force`)
   - Mandatory update scenario
   - Non-dismissible dialog behavior
   - Critical update messaging

9. **Error Handling Demo** (`/error`)
   - Network error simulation
   - Retry functionality demonstration
   - Error message customization

10. **API Integration Demo** (`/api`)
   - Real API endpoint usage
   - Request/response handling
   - Caching behavior demonstration

## Configuration Examples

### Basic Configuration

```dart
final versionChecker = VersionChecker(
  config: VersionCheckerConfig(
    apiUrl: 'https://salawati.smart-fingers.com/api/version/check',
  ),
);
```

### Advanced Configuration

```dart
final versionChecker = VersionChecker(
  config: VersionCheckerConfig(
    apiUrl: 'https://salawati.smart-fingers.com/api/version/check',
    timeout: Duration(seconds: 30),
    enableCaching: true,
    cacheExpiration: Duration(hours: 1),
    locale: 'en',
  ),
);
```

### Custom Dialog Configuration

#### Basic Custom Dialog

```dart
final customDialogConfig = DialogConfig(
  title: 'Update Available',
  message: 'A new version is available with exciting features!',
  positiveButtonText: 'Update Now',
  negativeButtonText: 'Maybe Later',
  titleStyle: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
  ),
  messageStyle: TextStyle(
    fontSize: 16,
    color: Colors.grey[700],
  ),
  positiveButtonStyle: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
  ),
  barrierDismissible: true,
  showNegativeButton: true,
);
```

#### Enhanced Icon & Shape Configuration

```dart
// Download theme with custom icon and border
final enhancedConfig = DialogConfig(
  icon: Icons.cloud_download,
  iconColor: Colors.green,
  iconSize: 72,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
    side: BorderSide(color: Colors.green, width: 2),
  ),
  title: 'Download Update',
  message: 'New features are ready to download!',
  backgroundColor: Colors.green.shade50,
  titleStyle: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.green.shade800,
  ),
  positiveButtonStyle: ElevatedButton.styleFrom(
    backgroundColor: Colors.green,
    foregroundColor: Colors.white,
  ),
  elevation: 12,
  padding: EdgeInsets.all(24),
);
```

#### Modern Circular Design

```dart
// Circular dialog with modern styling
final modernConfig = DialogConfig(
  icon: Icons.rocket_launch,
  iconColor: Colors.purple,
  iconSize: 80,
  shape: CircleBorder(),
  padding: EdgeInsets.all(32),
  title: 'New Features',
  message: 'Experience the latest innovations!',
  backgroundColor: Colors.purple.shade50,
  titleStyle: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.purple.shade800,
  ),
  positiveButtonStyle: ElevatedButton.styleFrom(
    backgroundColor: Colors.purple,
    foregroundColor: Colors.white,
    shape: StadiumBorder(),
  ),
  elevation: 16,
);
```

#### Security Update Configuration

```dart
// Security-focused design with warning theme
final securityConfig = DialogConfig(
  icon: Icons.security,
  iconColor: Colors.red,
  iconSize: 64,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
    side: BorderSide(color: Colors.red, width: 2),
  ),
  title: 'Security Update Required',
  message: 'This update contains important security fixes.',
  backgroundColor: Colors.red.shade50,
  titleStyle: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.red.shade800,
  ),
  positiveButtonStyle: ElevatedButton.styleFrom(
    backgroundColor: Colors.red,
    foregroundColor: Colors.white,
  ),
  elevation: 8,
);
```

#### Text Customization with Dynamic Placeholders

```dart
// English text with dynamic placeholders
final textCustomConfig = DialogConfig(
  title: 'Update {appName}',
  message: 'Ready to upgrade your experience?',
  positiveButtonText: 'Upgrade Now',
  negativeButtonText: 'Not Now',

  // Custom text with placeholders
  currentVersionText: 'Current: {currentVersion}',
  latestVersionText: 'Available: {latestVersion}',
  updateAvailableText: 'Update from {currentVersion} to {latestVersion} now!',
  releaseNotesTitle: 'What\'s New in {latestVersion}:',

  // Custom placeholders
  customPlaceholders: {
    'appName': 'MyApp',
    'supportEmail': 'support@myapp.com',
    'downloadSize': '45.2 MB',
  },
);
```

#### Localized Text Configuration (Spanish)

```dart
// Spanish localization with custom text
final localizedConfig = DialogConfig(
  title: '¡Actualización Disponible!',
  message: '¿Listo para mejorar tu experiencia?',
  positiveButtonText: 'Actualizar',
  negativeButtonText: 'Más Tarde',

  // Spanish text with placeholders
  currentVersionText: 'Versión actual: {currentVersion}',
  latestVersionText: 'Nueva versión: {latestVersion}',
  updateAvailableText: '¡Actualiza de {currentVersion} a {latestVersion}!',
  releaseNotesTitle: 'Novedades en {latestVersion}:',
  downloadSizeText: 'Tamaño: {downloadSize}',
  lastCheckedText: 'Última verificación: {lastChecked}',

  customPlaceholders: {
    'appName': 'MiApp',
    'supportEmail': 'soporte@miapp.com',
  },
);
```

## API Endpoint

The example app uses a test API endpoint:
- **URL**: `https://salawati.smart-fingers.com/api/version/check`
- **Method**: POST
- **Content-Type**: application/json

### Request Format
```json
{
  "current_version": "1.0.0",
  "platform": "android",
  "locale": "en"
}
```

### Response Format
```json
{
  "success": true,
  "current_version": "1.0.0",
  "latest_version": "1.2.0",
  "update_available": true,
  "force_update": false,
  "message": "A new version is available!",
  "release_notes": {
    "en": "• Bug fixes\n• Performance improvements",
    "ar": "• إصلاح الأخطاء\n• تحسينات الأداء"
  },
  "download_url": "https://play.google.com/store/apps/details?id=com.example.app"
}
```

## Screenshots

*Screenshots will be added showing the different dialog styles and scenarios*

## Testing Different Scenarios

The example app allows you to test various scenarios:

1. **Update Available**: Simulates when a new version is available
2. **Force Update**: Demonstrates mandatory update behavior
3. **No Update**: Shows behavior when app is up to date
4. **Network Error**: Tests error handling and retry functionality
5. **API Error**: Demonstrates server error handling

## Troubleshooting

### GitHub Installation Issues

**Problem: `flutter pub get` fails**
```
Because version_checker depends on version_checker from git which doesn't exist, version solving failed.
```

**Solutions:**
1. **Check internet connection** - Git dependencies require internet access
2. **Verify the repository URL** in your `pubspec.yaml`
3. **Try clearing cache**:
   ```bash
   flutter clean
   flutter pub cache clean
   flutter pub get
   ```

**Problem: Slow dependency resolution**

**Solutions:**
1. **Use a specific version tag** instead of `main`:
   ```yaml
   version_checker:
     git:
       url: https://github.com/aymanalareqi/version_checker.git
       ref: v1.0.0
   ```

2. **Check your internet connection speed**

### Common Runtime Issues

1. **Build Errors**: Make sure you have the latest Flutter SDK
2. **iOS Signing**: Configure code signing for iOS deployment
3. **Network Issues**: Check internet connection for API calls
4. **Platform Issues**: Ensure platform-specific setup is complete
5. **Git Dependency Issues**: See GitHub installation troubleshooting above

### Getting Help

- 📖 **Documentation**: [Main README](../README.md)
- 🐛 **Issues**: [GitHub Issues](https://github.com/aymanalareqi/version_checker/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/aymanalareqi/version_checker/discussions)

## Contributing

Found a bug or want to improve the example? Contributions are welcome!

1. Fork the repository
2. Create your feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This example app is part of the version_checker plugin and is licensed under the MIT License.
