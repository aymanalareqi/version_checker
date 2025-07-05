import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Utility class for launching URLs with platform-specific handling
/// and comprehensive error management.
///
/// This class provides methods to:
/// - Launch app store URLs for iOS and Android
/// - Handle generic web URLs
/// - Provide user feedback during URL launching
/// - Handle errors gracefully with user-friendly messages
///
/// Example usage:
/// ```dart
/// await UrlLauncherHelper.launchUpdateUrl(
///   context: context,
///   downloadUrl: 'https://apps.apple.com/app/myapp/id123456789',
///   onSuccess: () => print('URL launched successfully'),
///   onError: (error) => print('Failed to launch: $error'),
/// );
/// ```
class UrlLauncherHelper {
  /// Launch an update URL with comprehensive error handling and user feedback.
  ///
  /// This method:
  /// 1. Validates the URL
  /// 2. Shows a loading indicator while launching
  /// 3. Handles platform-specific app store URLs
  /// 4. Provides success/error callbacks
  /// 5. Shows user-friendly error messages
  ///
  /// Parameters:
  /// - [context]: Build context for showing dialogs and snackbars
  /// - [downloadUrl]: The URL to launch (app store or web URL)
  /// - [onSuccess]: Optional callback called when URL launches successfully
  /// - [onError]: Optional callback called when URL launch fails
  /// - [showLoadingIndicator]: Whether to show loading indicator (default: true)
  /// - [showErrorDialog]: Whether to show error dialog on failure (default: true)
  static Future<bool> launchUpdateUrl({
    required BuildContext context,
    required String? downloadUrl,
    VoidCallback? onSuccess,
    Function(String error)? onError,
    bool showLoadingIndicator = true,
    bool showErrorDialog = true,
  }) async {
    if (downloadUrl == null || downloadUrl.isEmpty) {
      const error = 'No download URL provided';
      onError?.call(error);
      if (showErrorDialog && context.mounted) {
        _showErrorDialog(context, error);
      }
      return false;
    }

    // Show loading indicator if requested
    if (showLoadingIndicator && context.mounted) {
      _showLoadingSnackBar(context);
    }

    try {
      // Validate and parse the URL
      final uri = Uri.tryParse(downloadUrl);
      if (uri == null) {
        throw Exception('Invalid URL format: $downloadUrl');
      }

      // Check if the URL can be launched
      final canLaunch = await canLaunchUrl(uri);
      if (!canLaunch) {
        throw Exception('Cannot launch URL: $downloadUrl');
      }

      // Launch the URL with appropriate mode
      final launched = await launchUrl(
        uri,
        mode: getLaunchMode(downloadUrl),
        webViewConfiguration: const WebViewConfiguration(
          enableJavaScript: true,
          enableDomStorage: true,
        ),
      );

      if (launched) {
        onSuccess?.call();
        if (showLoadingIndicator && context.mounted) {
          _showSuccessSnackBar(context);
        }
        return true;
      } else {
        throw Exception('Failed to launch URL');
      }
    } catch (e) {
      final errorMessage = getErrorMessage(e, downloadUrl);
      onError?.call(errorMessage);

      if (context.mounted) {
        if (showLoadingIndicator) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }
        if (showErrorDialog) {
          _showErrorDialog(context, errorMessage);
        }
      }
      return false;
    }
  }

  /// Launch URL without UI feedback (for background operations)
  static Future<bool> launchUrlSilently(String? downloadUrl) async {
    if (downloadUrl == null || downloadUrl.isEmpty) {
      return false;
    }

    try {
      final uri = Uri.tryParse(downloadUrl);
      if (uri == null) return false;

      final canLaunch = await canLaunchUrl(uri);
      if (!canLaunch) return false;

      return await launchUrl(
        uri,
        mode: getLaunchMode(downloadUrl),
      );
    } catch (e) {
      return false;
    }
  }

  /// Determine the appropriate launch mode based on URL type
  @visibleForTesting
  static LaunchMode getLaunchMode(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return LaunchMode.externalApplication;

    // App store URLs should open in external app
    if (isAppStoreUrl(url)) {
      return LaunchMode.externalApplication;
    }

    // Web URLs can open in external browser
    if (uri.scheme == 'http' || uri.scheme == 'https') {
      return LaunchMode.externalApplication;
    }

    // Default to external application
    return LaunchMode.externalApplication;
  }

  /// Check if URL is an app store URL
  @visibleForTesting
  static bool isAppStoreUrl(String url) {
    final lowerUrl = url.toLowerCase();
    return lowerUrl.contains('apps.apple.com') ||
        lowerUrl.contains('itunes.apple.com') ||
        lowerUrl.contains('play.google.com') ||
        lowerUrl.contains('market.android.com');
  }

  /// Generate user-friendly error message
  @visibleForTesting
  static String getErrorMessage(dynamic error, String url) {
    final errorStr = error.toString().toLowerCase();

    if (errorStr.contains('invalid url') || errorStr.contains('malformed')) {
      return 'The download link appears to be invalid. Please contact support.';
    }

    if (errorStr.contains('cannot launch') ||
        errorStr.contains('not supported')) {
      if (isAppStoreUrl(url)) {
        return Platform.isIOS
            ? 'Unable to open App Store. Please check if the App Store app is available.'
            : 'Unable to open Google Play Store. Please check if the Play Store app is available.';
      }
      return 'Unable to open the download link. Please try again or contact support.';
    }

    if (errorStr.contains('network') || errorStr.contains('connection')) {
      return 'Network error. Please check your internet connection and try again.';
    }

    return 'Unable to open download link. Please try again or contact support.';
  }

  /// Show loading snackbar
  static void _showLoadingSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: 16),
            Text('Opening download link...'),
          ],
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Show success snackbar
  static void _showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 16),
            Text('Download link opened successfully'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Show error dialog
  static void _showErrorDialog(BuildContext context, String error) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unable to Open Download Link'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Get platform-specific app store URL
  static String? getPlatformStoreUrl({
    String? iosAppId,
    String? androidPackageName,
  }) {
    if (Platform.isIOS && iosAppId != null) {
      return 'https://apps.apple.com/app/id$iosAppId';
    } else if (Platform.isAndroid && androidPackageName != null) {
      return 'https://play.google.com/store/apps/details?id=$androidPackageName';
    }
    return null;
  }
}
