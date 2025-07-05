import '../models/version_check_response.dart';

/// Utility class for formatting text with placeholder substitution
///
/// This class provides functionality to replace placeholders in text strings
/// with dynamic values from version check responses and other context data.
///
/// Supported placeholders:
/// - `{currentVersion}` - Current app version
/// - `{latestVersion}` - Latest available version
/// - `{appName}` - Application name
/// - `{downloadSize}` - Download size (if available)
/// - `{releaseDate}` - Release date (if available)
/// - `{buildNumber}` - Build number (if available)
/// - `{versionCode}` - Version code (if available)
///
/// Example usage:
/// ```dart
/// final formatter = TextFormatter();
/// final text = formatter.format(
///   'Update from {currentVersion} to {latestVersion}',
///   response: versionResponse,
///   appName: 'MyApp',
/// );
/// ```
class TextFormatter {
  /// Format text by replacing placeholders with actual values
  ///
  /// [text] - The text template with placeholders
  /// [response] - Version check response containing version information
  /// [appName] - Application name for {appName} placeholder
  /// [downloadSize] - Download size for {downloadSize} placeholder
  /// [releaseDate] - Release date for {releaseDate} placeholder
  /// [buildNumber] - Build number for {buildNumber} placeholder
  /// [versionCode] - Version code for {versionCode} placeholder
  /// [customPlaceholders] - Additional custom placeholders
  static String format(
    String text, {
    VersionCheckResponse? response,
    String? appName,
    String? downloadSize,
    String? releaseDate,
    String? buildNumber,
    String? versionCode,
    Map<String, String>? customPlaceholders,
  }) {
    String result = text;

    // Replace version placeholders
    if (response != null) {
      result = result.replaceAll('{currentVersion}', response.currentVersion);
      result =
          result.replaceAll('{latestVersion}', response.latestVersion ?? '');
    }

    // Replace app information placeholders
    if (appName != null) {
      result = result.replaceAll('{appName}', appName);
    }

    if (downloadSize != null) {
      result = result.replaceAll('{downloadSize}', downloadSize);
    }

    if (releaseDate != null) {
      result = result.replaceAll('{releaseDate}', releaseDate);
    }

    if (buildNumber != null) {
      result = result.replaceAll('{buildNumber}', buildNumber);
    }

    if (versionCode != null) {
      result = result.replaceAll('{versionCode}', versionCode);
    }

    // Replace custom placeholders
    if (customPlaceholders != null) {
      customPlaceholders.forEach((key, value) {
        result = result.replaceAll('{$key}', value);
      });
    }

    return result;
  }

  /// Get formatted current version text
  static String formatCurrentVersionText(
    String? template,
    VersionCheckResponse response, {
    Map<String, String>? customPlaceholders,
  }) {
    final defaultTemplate = 'Current: {currentVersion}';
    return format(
      template ?? defaultTemplate,
      response: response,
      customPlaceholders: customPlaceholders,
    );
  }

  /// Get formatted latest version text
  static String formatLatestVersionText(
    String? template,
    VersionCheckResponse response, {
    Map<String, String>? customPlaceholders,
  }) {
    final defaultTemplate = 'Latest: {latestVersion}';
    return format(
      template ?? defaultTemplate,
      response: response,
      customPlaceholders: customPlaceholders,
    );
  }

  /// Get formatted update available text
  static String formatUpdateAvailableText(
    String? template,
    VersionCheckResponse response, {
    Map<String, String>? customPlaceholders,
  }) {
    final defaultTemplate = 'A new version is available!';
    return format(
      template ?? defaultTemplate,
      response: response,
      customPlaceholders: customPlaceholders,
    );
  }

  /// Get formatted force update text
  static String formatForceUpdateText(
    String? template,
    VersionCheckResponse response, {
    Map<String, String>? customPlaceholders,
  }) {
    final defaultTemplate = 'This version is no longer supported.';
    return format(
      template ?? defaultTemplate,
      response: response,
      customPlaceholders: customPlaceholders,
    );
  }

  /// Get formatted error text
  static String formatErrorText(
    String? template,
    String error, {
    Map<String, String>? customPlaceholders,
  }) {
    final defaultTemplate = 'Unable to check for updates';
    String result = template ?? defaultTemplate;

    // Add error placeholder support
    result = result.replaceAll('{error}', error);

    // Apply custom placeholders
    if (customPlaceholders != null) {
      customPlaceholders.forEach((key, value) {
        result = result.replaceAll('{$key}', value);
      });
    }

    return result;
  }

  /// Get formatted release notes title
  static String formatReleaseNotesTitle(
    String? template, {
    Map<String, String>? customPlaceholders,
  }) {
    final defaultTemplate = 'What\'s New:';
    return format(
      template ?? defaultTemplate,
      customPlaceholders: customPlaceholders,
    );
  }

  /// Get formatted download size text
  static String formatDownloadSizeText(
    String? template,
    String? downloadSize, {
    Map<String, String>? customPlaceholders,
  }) {
    if (downloadSize == null) return '';

    final defaultTemplate = 'Download size: {downloadSize}';
    return format(
      template ?? defaultTemplate,
      downloadSize: downloadSize,
      customPlaceholders: customPlaceholders,
    );
  }

  /// Get formatted last checked text
  static String formatLastCheckedText(
    String? template,
    DateTime? lastChecked, {
    Map<String, String>? customPlaceholders,
  }) {
    if (lastChecked == null) return '';

    final defaultTemplate = 'Last checked: {lastChecked}';
    final formattedDate = _formatDateTime(lastChecked);

    return format(
      template ?? defaultTemplate,
      customPlaceholders: {
        'lastChecked': formattedDate,
        ...?customPlaceholders,
      },
    );
  }

  /// Format DateTime to a readable string
  static String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  /// Validate if a text template has valid placeholders
  static bool isValidTemplate(String template) {
    // Check for unmatched braces
    int openBraces = 0;
    for (int i = 0; i < template.length; i++) {
      if (template[i] == '{') {
        openBraces++;
      } else if (template[i] == '}') {
        openBraces--;
        if (openBraces < 0) return false;
      }
    }
    return openBraces == 0;
  }

  /// Get all placeholders found in a text template
  static List<String> getPlaceholders(String template) {
    final placeholders = <String>[];
    final regex = RegExp(r'\{([^}]+)\}');
    final matches = regex.allMatches(template);

    for (final match in matches) {
      final placeholder = match.group(1);
      if (placeholder != null && !placeholders.contains(placeholder)) {
        placeholders.add(placeholder);
      }
    }

    return placeholders;
  }
}
