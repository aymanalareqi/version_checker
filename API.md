# API Documentation

This document provides comprehensive API documentation for the version_checker Flutter plugin.

## Table of Contents

- [Core Classes](#core-classes)
- [Configuration](#configuration)
- [Models](#models)
- [Widgets](#widgets)
- [Utilities](#utilities)
- [Callbacks](#callbacks)
- [Examples](#examples)

## Core Classes

### VersionChecker

The main plugin class for version checking functionality.

#### Constructor

```dart
VersionChecker({
  VersionCheckerConfig? config,
})
```

Creates a new VersionChecker instance with optional configuration. If no config is provided, uses `VersionCheckerConfig.defaultConfig`.

#### Methods

##### checkForUpdates()

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

Checks for app updates and optionally displays dialogs.

**Parameters:**
- `context` (BuildContext?) - Build context for showing dialogs
- `showDialogs` (bool) - Whether to show dialogs automatically (default: true)
- `onResult` (VersionCheckCallback?) - Callback for version check results
- `onUpdatePressed` (UserActionCallback?) - Callback for update button press
- `onLaterPressed` (UserActionCallback?) - Callback for later button press
- `onDismissed` (UserActionCallback?) - Callback for dialog dismissal
- `onError` (UserActionCallback?) - Callback for error scenarios

**Returns:** `Future<VersionCheckResponse>` - Version check results

**Throws:**
- `TimeoutException` - If API request times out
- `SocketException` - If network connectivity issues occur
- `FormatException` - If API response format is invalid

##### clearCache()

```dart
Future<void> clearCache()
```

Clears cached version check responses.

## Configuration

### VersionCheckerConfig

Configuration class for the version checker plugin.

#### Constructor

```dart
const VersionCheckerConfig({
  required String apiUrl,
  int timeoutSeconds = 30,
  bool enableCaching = true,
  int cacheDurationMinutes = 5,
  String? locale,
  bool showDialogs = true,
  DialogConfig updateDialogConfig = DialogConfig.updateAvailable,
  DialogConfig forceUpdateDialogConfig = DialogConfig.forceUpdate,
  DialogConfig errorDialogConfig = DialogConfig.error,
  Map<String, String>? customHeaders,
  bool includeBuildNumber = true,
  String? userAgent,
})
```

#### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `apiUrl` | `String` | Required | API endpoint URL for version checking |
| `timeoutSeconds` | `int` | `30` | Request timeout in seconds |
| `enableCaching` | `bool` | `true` | Whether to cache responses |
| `cacheDurationMinutes` | `int` | `5` | Cache duration in minutes |
| `locale` | `String?` | `null` | Preferred locale for API responses |
| `showDialogs` | `bool` | `true` | Whether to show dialogs automatically |
| `updateDialogConfig` | `DialogConfig` | `DialogConfig.updateAvailable` | Update dialog configuration |
| `forceUpdateDialogConfig` | `DialogConfig` | `DialogConfig.forceUpdate` | Force update dialog configuration |
| `errorDialogConfig` | `DialogConfig` | `DialogConfig.error` | Error dialog configuration |
| `customHeaders` | `Map<String, String>?` | `null` | Custom headers for API requests |
| `includeBuildNumber` | `bool` | `true` | Whether to include build number in requests |
| `userAgent` | `String?` | `null` | Custom user agent for requests |

#### Static Properties

- `VersionCheckerConfig.defaultConfig` - Default configuration instance

### DialogConfig

Configuration class for customizing dialog appearance and behavior.

#### Constructor

```dart
const DialogConfig({
  String? title,
  String? message,
  String? positiveButtonText,
  String? negativeButtonText,
  bool showNegativeButton = true,
  Color? backgroundColor,
  TextStyle? titleStyle,
  TextStyle? messageStyle,
  ButtonStyle? positiveButtonStyle,
  ButtonStyle? negativeButtonStyle,
  BorderRadius? borderRadius,
  double? elevation,
  bool barrierDismissible = true,
  EdgeInsets? padding,
  Widget? customContent,
  List<Widget>? customActions,
  IconData? icon,
  Color? iconColor,
  double? iconSize,
})
```

#### Pre-configured Instances

- `DialogConfig.updateAvailable` - Standard update dialog
- `DialogConfig.forceUpdate` - Mandatory update dialog
- `DialogConfig.error` - Error dialog with retry functionality

## Models

### VersionCheckResponse

Response model for version checking API results.

#### Constructor

```dart
const VersionCheckResponse({
  required bool success,
  required String currentVersion,
  required String platform,
  required bool updateAvailable,
  required bool forceUpdate,
  String? platformLabel,
  bool? isBeta,
  String? downloadUrl,
  DateTime? releaseDate,
  dynamic releaseNotes,
  Map<String, dynamic>? metadata,
  DateTime? checkedAt,
  String? message,
  String? error,
  String? latestVersion,
})
```

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `success` | `bool` | Whether the request was successful |
| `currentVersion` | `String` | Current app version |
| `platform` | `String` | Platform identifier (ios/android) |
| `updateAvailable` | `bool` | Whether an update is available |
| `forceUpdate` | `bool` | Whether the update is mandatory |
| `latestVersion` | `String?` | Latest available version |
| `downloadUrl` | `String?` | Download URL for the update |
| `releaseNotes` | `dynamic` | Release notes (String or Map<String, String>) |
| `message` | `String?` | Update message |
| `error` | `String?` | Error message if request failed |

#### Methods

##### fromJson()

```dart
factory VersionCheckResponse.fromJson(Map<String, dynamic> json)
```

Creates a VersionCheckResponse from JSON data.

##### toJson()

```dart
Map<String, dynamic> toJson()
```

Converts the response to JSON format.

### VersionCheckRequest

Request model for version checking API calls.

#### Constructor

```dart
const VersionCheckRequest({
  required String currentVersion,
  required String platform,
  String? buildNumber,
  String? locale,
})
```

## Widgets

### UpdateDialog

Dialog widget for displaying update notifications.

#### Constructor

```dart
UpdateDialog({
  Key? key,
  required VersionCheckResponse response,
  required DialogConfig config,
  VoidCallback? onUpdate,
  VoidCallback? onLater,
})
```

### ForceUpdateDialog

Dialog widget for mandatory updates.

#### Constructor

```dart
ForceUpdateDialog({
  Key? key,
  required VersionCheckResponse response,
  required DialogConfig config,
  VoidCallback? onUpdate,
})
```

### ErrorDialog

Dialog widget for error scenarios.

#### Constructor

```dart
ErrorDialog({
  Key? key,
  required String error,
  required DialogConfig config,
  VoidCallback? onRetry,
  VoidCallback? onDismiss,
})
```

## Utilities

### VersionComparator

Utility class for semantic version comparison.

#### Static Methods

##### compare()

```dart
static int compare(String version1, String version2)
```

Compares two version strings using semantic versioning rules.

**Returns:**
- `-1` if version1 < version2
- `0` if version1 == version2
- `1` if version1 > version2

##### isValidVersion()

```dart
static bool isValidVersion(String version)
```

Validates if a string is a valid semantic version.

## Callbacks

### VersionCheckCallback

```dart
typedef VersionCheckCallback = void Function(VersionCheckResponse response);
```

Callback function for version check results.

### UserActionCallback

```dart
typedef UserActionCallback = void Function();
```

Callback function for user actions (button presses, dialog dismissals).

## Examples

### Basic Usage

```dart
import 'package:version_checker/version_checker.dart';

final versionChecker = VersionChecker(
  config: VersionCheckerConfig(
    apiUrl: 'https://your-api.com/version/check',
  ),
);

await versionChecker.checkForUpdates(
  context: context,
  showDialogs: true,
);
```

### Advanced Configuration

```dart
final versionChecker = VersionChecker(
  config: VersionCheckerConfig(
    apiUrl: 'https://your-api.com/version/check',
    timeoutSeconds: 30,
    enableCaching: true,
    cacheDurationMinutes: 60,
    locale: 'en',
    customHeaders: {
      'Authorization': 'Bearer token',
    },
  ),
);

final response = await versionChecker.checkForUpdates(
  context: context,
  showDialogs: true,
  onUpdatePressed: () {
    // Handle update
  },
  onLaterPressed: () {
    // Handle later
  },
  onError: () {
    // Handle error
  },
);
```

### Custom Dialog Styling

```dart
final customConfig = DialogConfig(
  title: 'Update Available',
  message: 'New features await!',
  positiveButtonText: 'Update Now',
  negativeButtonText: 'Later',
  titleStyle: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
  ),
  positiveButtonStyle: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
  ),
  backgroundColor: Colors.white,
  borderRadius: BorderRadius.circular(12),
  elevation: 8,
);
```

### Manual Dialog Display

```dart
final response = await versionChecker.checkForUpdates(
  showDialogs: false,
);

if (response.updateAvailable) {
  showDialog(
    context: context,
    builder: (context) => UpdateDialog(
      response: response,
      config: DialogConfig.updateAvailable,
      onUpdate: () {
        Navigator.of(context).pop();
        // Handle update
      },
      onLater: () {
        Navigator.of(context).pop();
        // Handle later
      },
    ),
  );
}
```

## Error Handling

The plugin provides comprehensive error handling:

```dart
try {
  final response = await versionChecker.checkForUpdates();
  if (!response.success) {
    print('Error: ${response.error}');
  }
} on TimeoutException {
  print('Request timed out');
} on SocketException {
  print('Network error');
} catch (e) {
  print('Unexpected error: $e');
}
```

## API Integration

### Request Format

```json
{
  "current_version": "1.0.0",
  "platform": "android",
  "build_number": "123",
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
  "message": "Update available",
  "release_notes": {
    "en": "Bug fixes and improvements",
    "ar": "إصلاحات وتحسينات"
  },
  "download_url": "https://play.google.com/store/apps/details?id=com.example.app"
}
```
