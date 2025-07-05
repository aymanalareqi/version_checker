# Version Checker

[![pub package](https://img.shields.io/pub/v/version_checker.svg)](https://pub.dev/packages/version_checker)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A comprehensive Flutter plugin for checking app version updates with customizable dialogs and seamless API integration. Perfect for keeping your users informed about new app versions with beautiful, customizable update prompts.

## Features

✨ **Easy Integration** - Simple setup with minimal configuration  
🎨 **Customizable Dialogs** - Beautiful, fully customizable update dialogs  
🔄 **Automatic Version Checking** - Smart version comparison and update detection  
🌐 **API Integration** - Works with any REST API endpoint  
📱 **Cross Platform** - Supports iOS and Android  
⚡ **Caching Support** - Built-in response caching for better performance  
🎯 **Force Updates** - Support for mandatory app updates  
🛠️ **Error Handling** - Comprehensive error handling with retry functionality  

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  version_checker: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Quick Start

### Basic Usage

```dart
import 'package:version_checker/version_checker.dart';

// Create a version checker instance
final versionChecker = VersionChecker(
  config: VersionCheckerConfig(
    apiUrl: 'https://your-api.com/version/check',
  ),
);

// Check for updates with default dialogs
await versionChecker.checkForUpdates(
  context: context,
  showDialogs: true,
);
```

### Advanced Usage with Custom Configuration

```dart
import 'package:version_checker/version_checker.dart';

final versionChecker = VersionChecker(
  config: VersionCheckerConfig(
    apiUrl: 'https://your-api.com/version/check',
    timeout: Duration(seconds: 30),
    enableCaching: true,
    cacheExpiration: Duration(hours: 1),
    locale: 'en',
  ),
);

await versionChecker.checkForUpdates(
  context: context,
  showDialogs: true,
  onUpdatePressed: () {
    // Handle update button press
    print('User wants to update');
  },
  onLaterPressed: () {
    // Handle later button press
    print('User chose to update later');
  },
  onError: () {
    // Handle error scenarios
    print('Error checking for updates');
  },
);
```

## API Integration

The plugin expects your API to return a JSON response in the following format:

```json
{
  "success": true,
  "current_version": "1.0.0",
  "latest_version": "1.2.0",
  "update_available": true,
  "force_update": false,
  "message": "A new version is available with exciting features!",
  "release_notes": {
    "en": "• Bug fixes\n• Performance improvements\n• New features",
    "ar": "• إصلاح الأخطاء\n• تحسينات الأداء\n• ميزات جديدة"
  },
  "download_url": "https://play.google.com/store/apps/details?id=com.yourapp"
}
```

### API Request Format

The plugin sends a POST request with:

```json
{
  "current_version": "1.0.0",
  "platform": "android",
  "locale": "en"
}
```

## Dialog Customization

### Custom Dialog Styling

```dart
final customConfig = DialogConfig(
  title: 'Update Available',
  message: 'A new version of the app is available.',
  positiveButtonText: 'Update Now',
  negativeButtonText: 'Later',
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
  negativeButtonStyle: TextButton.styleFrom(
    foregroundColor: Colors.grey,
  ),
  icon: Icons.system_update,
  barrierDismissible: true,
  showNegativeButton: true,
);

// Use custom dialog config
await versionChecker.checkForUpdates(
  context: context,
  showDialogs: true,
  customDialogConfig: customConfig,
);
```

### Manual Dialog Display

```dart
// Show update dialog manually
await showDialog(
  context: context,
  builder: (context) => UpdateDialog(
    response: versionCheckResponse,
    config: DialogConfig.update,
    onUpdate: () {
      Navigator.of(context).pop();
      // Handle update action
    },
    onLater: () {
      Navigator.of(context).pop();
      // Handle later action
    },
  ),
);
```

## Configuration Options

### VersionCheckerConfig

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `apiUrl` | `String` | Required | API endpoint for version checking |
| `timeout` | `Duration` | `30 seconds` | Request timeout duration |
| `enableCaching` | `bool` | `true` | Enable response caching |
| `cacheExpiration` | `Duration` | `1 hour` | Cache expiration time |
| `locale` | `String?` | `null` | Locale for localized responses |

### DialogConfig

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `title` | `String` | `'Update Available'` | Dialog title |
| `message` | `String?` | `null` | Dialog message |
| `positiveButtonText` | `String?` | `'Update'` | Positive button text |
| `negativeButtonText` | `String?` | `'Later'` | Negative button text |
| `showNegativeButton` | `bool` | `true` | Show negative button |
| `barrierDismissible` | `bool` | `true` | Allow dismissing by tapping outside |
| `icon` | `IconData?` | `null` | Dialog icon |

## Platform Support

- ✅ **Android** - Full support with Google Play Store integration
- ✅ **iOS** - Full support with App Store integration
- ⏳ **Web** - Coming soon
- ⏳ **macOS** - Coming soon
- ⏳ **Windows** - Coming soon
- ⏳ **Linux** - Coming soon

## Example App

Check out the [example app](./example) for a complete implementation showing all features:

```bash
cd example
flutter run
```

The example demonstrates:
- Basic version checking
- Custom dialog styling
- Force update scenarios
- Error handling
- API integration

## API Reference

### VersionChecker

Main class for version checking functionality.

#### Methods

##### `checkForUpdates()`

Checks for app updates and optionally displays dialogs.

```dart
Future<VersionCheckResponse> checkForUpdates({
  BuildContext? context,
  bool showDialogs = true,
  VersionCheckCallback? onResult,
  UserActionCallback? onUpdatePressed,
  UserActionCallback? onLaterPressed,
  UserActionCallback? onDismissed,
  UserActionCallback? onError,
})
```

**Parameters:**
- `context` - Build context for showing dialogs
- `showDialogs` - Whether to show update dialogs automatically
- `onResult` - Callback for version check results
- `onUpdatePressed` - Callback when update button is pressed
- `onLaterPressed` - Callback when later button is pressed
- `onDismissed` - Callback when dialog is dismissed
- `onError` - Callback for error scenarios

**Returns:** `Future<VersionCheckResponse>` - Version check result

##### `clearCache()`

Clears the cached version check responses.

```dart
Future<void> clearCache()
```

### VersionCheckResponse

Response model for version check results.

#### Properties

- `bool success` - Whether the request was successful
- `String? currentVersion` - Current app version
- `String? latestVersion` - Latest available version
- `bool updateAvailable` - Whether an update is available
- `bool forceUpdate` - Whether the update is mandatory
- `String? message` - Update message
- `Map<String, String>? releaseNotes` - Localized release notes
- `String? downloadUrl` - Download URL for the update
- `String? error` - Error message if request failed

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- 📧 Email: support@smartfingers.com
- 🐛 Issues: [GitHub Issues](https://github.com/aymanalareqi/version_checker/issues)
- 📖 Documentation: [API Docs](https://pub.dev/documentation/version_checker/latest/)

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a detailed list of changes and updates.
