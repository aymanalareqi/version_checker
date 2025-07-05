import 'package:flutter/material.dart';

/// Configuration class for customizing dialog appearance and behavior.
///
/// The [DialogConfig] class provides comprehensive customization options
/// for all dialog types in the version_checker plugin, including update
/// dialogs, force update dialogs, and error dialogs.
///
/// This class allows you to customize:
/// - Text content (title, message, button labels)
/// - Visual styling (colors, fonts, borders, elevation)
/// - Icon appearance (custom icons, colors, sizes)
/// - Dialog shape (border radius, custom shapes)
/// - Behavior (dismissibility, button visibility)
/// - Layout (padding, custom content, custom actions)
///
/// Example usage:
/// ```dart
/// final customConfig = DialogConfig(
///   title: 'Update Available',
///   message: 'A new version is available with exciting features!',
///   positiveButtonText: 'Update Now',
///   negativeButtonText: 'Maybe Later',
///   icon: Icons.cloud_download,
///   iconColor: Colors.blue,
///   iconSize: 72,
///   titleStyle: TextStyle(
///     fontSize: 20,
///     fontWeight: FontWeight.bold,
///     color: Colors.blue,
///   ),
///   messageStyle: TextStyle(
///     fontSize: 16,
///     color: Colors.grey[700],
///   ),
///   positiveButtonStyle: ElevatedButton.styleFrom(
///     backgroundColor: Colors.blue,
///     foregroundColor: Colors.white,
///   ),
///   backgroundColor: Colors.white,
///   shape: RoundedRectangleBorder(
///     borderRadius: BorderRadius.circular(16),
///   ),
///   elevation: 8,
///   barrierDismissible: true,
///   showNegativeButton: true,
/// );
/// ```
///
/// Pre-configured instances are available for common use cases:
/// - [DialogConfig.updateAvailable] - Standard update dialog
/// - [DialogConfig.forceUpdate] - Mandatory update dialog
/// - [DialogConfig.error] - Error dialog with retry functionality
///
/// @since 1.0.0
class DialogConfig {
  /// Dialog title text
  final String? title;

  /// Dialog message text
  final String? message;

  /// Positive button text (e.g., "Update", "OK")
  final String? positiveButtonText;

  /// Negative button text (e.g., "Later", "Cancel")
  final String? negativeButtonText;

  /// Whether to show the negative button
  final bool showNegativeButton;

  /// Dialog background color
  final Color? backgroundColor;

  /// Title text style
  final TextStyle? titleStyle;

  /// Message text style
  final TextStyle? messageStyle;

  /// Positive button style
  final ButtonStyle? positiveButtonStyle;

  /// Negative button style
  final ButtonStyle? negativeButtonStyle;

  /// Dialog border radius
  ///
  /// Note: This property is deprecated in favor of [shape].
  /// Use [shape] with [RoundedRectangleBorder] for border radius customization.
  @Deprecated(
      'Use shape property instead for more flexible dialog shape customization')
  final BorderRadius? borderRadius;

  /// Dialog elevation
  final double? elevation;

  /// Whether the dialog is dismissible
  final bool barrierDismissible;

  /// Custom dialog padding
  final EdgeInsets? padding;

  /// Custom content widget (overrides title and message)
  final Widget? customContent;

  /// Custom actions (overrides default buttons)
  final List<Widget>? customActions;

  /// Custom icon for the dialog
  ///
  /// If not provided, default icons will be used:
  /// - Update dialogs: [Icons.system_update]
  /// - Force update dialogs: [Icons.warning_amber_rounded]
  /// - Error dialogs: [Icons.error_outline]
  ///
  /// Example:
  /// ```dart
  /// DialogConfig(
  ///   icon: Icons.cloud_download,
  ///   iconColor: Colors.blue,
  ///   iconSize: 72,
  /// )
  /// ```
  final IconData? icon;

  /// Color for the dialog icon
  ///
  /// If not provided, default colors will be used:
  /// - Update dialogs: [Colors.blue[600]]
  /// - Force update dialogs: [Colors.orange[600]]
  /// - Error dialogs: [Colors.red[600]]
  final Color? iconColor;

  /// Size of the dialog icon in logical pixels
  ///
  /// Defaults to 64.0 if not specified.
  final double? iconSize;

  /// Custom shape for the dialog container
  ///
  /// This property provides more flexibility than [borderRadius] and allows
  /// for custom dialog shapes including rounded rectangles, circles, or
  /// completely custom shapes.
  ///
  /// Example:
  /// ```dart
  /// DialogConfig(
  ///   shape: RoundedRectangleBorder(
  ///     borderRadius: BorderRadius.circular(16),
  ///     side: BorderSide(color: Colors.blue, width: 2),
  ///   ),
  /// )
  /// ```
  ///
  /// If both [shape] and [borderRadius] are provided, [shape] takes precedence.
  final ShapeBorder? shape;

  // Text Customization Properties

  /// Custom text for displaying current version
  ///
  /// Supports placeholder substitution with variables like {currentVersion}.
  /// Default: "Current: {currentVersion}"
  ///
  /// Example:
  /// ```dart
  /// DialogConfig(
  ///   currentVersionText: 'Your version: {currentVersion}',
  /// )
  /// ```
  final String? currentVersionText;

  /// Custom text for displaying latest version
  ///
  /// Supports placeholder substitution with variables like {latestVersion}.
  /// Default: "Latest: {latestVersion}"
  ///
  /// Example:
  /// ```dart
  /// DialogConfig(
  ///   latestVersionText: 'New version: {latestVersion}',
  /// )
  /// ```
  final String? latestVersionText;

  /// Custom text for update available message
  ///
  /// Supports placeholder substitution with variables like {currentVersion}, {latestVersion}.
  /// Default: "A new version is available!"
  ///
  /// Example:
  /// ```dart
  /// DialogConfig(
  ///   updateAvailableText: 'Update from {currentVersion} to {latestVersion}',
  /// )
  /// ```
  final String? updateAvailableText;

  /// Custom text for mandatory update message
  ///
  /// Supports placeholder substitution with variables like {latestVersion}.
  /// Default: "This version is no longer supported."
  ///
  /// Example:
  /// ```dart
  /// DialogConfig(
  ///   forceUpdateText: 'Please update to {latestVersion} to continue.',
  /// )
  /// ```
  final String? forceUpdateText;

  /// Custom text for error scenarios
  ///
  /// Supports placeholder substitution with variables like {error}.
  /// Default: "Unable to check for updates"
  ///
  /// Example:
  /// ```dart
  /// DialogConfig(
  ///   errorText: 'Update check failed: {error}',
  /// )
  /// ```
  final String? errorText;

  /// Custom title for release notes section
  ///
  /// Default: "What's New:"
  ///
  /// Example:
  /// ```dart
  /// DialogConfig(
  ///   releaseNotesTitle: 'New Features:',
  /// )
  /// ```
  final String? releaseNotesTitle;

  /// Custom text for download size display
  ///
  /// Supports placeholder substitution with variables like {downloadSize}.
  /// Default: "Download size: {downloadSize}"
  ///
  /// Example:
  /// ```dart
  /// DialogConfig(
  ///   downloadSizeText: 'Size: {downloadSize}',
  /// )
  /// ```
  final String? downloadSizeText;

  /// Custom text for last checked timestamp
  ///
  /// Supports placeholder substitution with variables like {lastChecked}.
  /// Default: "Last checked: {lastChecked}"
  ///
  /// Example:
  /// ```dart
  /// DialogConfig(
  ///   lastCheckedText: 'Checked: {lastChecked}',
  /// )
  /// ```
  final String? lastCheckedText;

  /// Custom text for force update requirement message
  ///
  /// Supports placeholder substitution with variables like {latestVersion}.
  /// Default: "Please update to version {latestVersion} to continue using the app."
  ///
  /// Example:
  /// ```dart
  /// DialogConfig(
  ///   forceUpdateRequirementText: 'Version {latestVersion} is required.',
  /// )
  /// ```
  final String? forceUpdateRequirementText;

  /// Custom text for error details label
  ///
  /// Default: "Error Details:"
  ///
  /// Example:
  /// ```dart
  /// DialogConfig(
  ///   errorDetailsText: 'Technical Details:',
  /// )
  /// ```
  final String? errorDetailsText;

  /// Custom text for connection error message
  ///
  /// Default: "Please check your internet connection and try again."
  ///
  /// Example:
  /// ```dart
  /// DialogConfig(
  ///   connectionErrorText: 'Check your network and retry.',
  /// )
  /// ```
  final String? connectionErrorText;

  /// Custom placeholders for text substitution
  ///
  /// Additional key-value pairs for custom placeholder replacement.
  /// These will be applied to all text properties that support placeholders.
  ///
  /// Example:
  /// ```dart
  /// DialogConfig(
  ///   customPlaceholders: {
  ///     'appName': 'MyApp',
  ///     'supportEmail': 'support@myapp.com',
  ///   },
  ///   updateAvailableText: 'New {appName} version available!',
  /// )
  /// ```
  final Map<String, String>? customPlaceholders;

  const DialogConfig({
    this.title,
    this.message,
    this.positiveButtonText,
    this.negativeButtonText,
    this.showNegativeButton = true,
    this.backgroundColor,
    this.titleStyle,
    this.messageStyle,
    this.positiveButtonStyle,
    this.negativeButtonStyle,
    this.borderRadius,
    this.elevation,
    this.barrierDismissible = true,
    this.padding,
    this.customContent,
    this.customActions,
    this.icon,
    this.iconColor,
    this.iconSize,
    this.shape,
    // Text customization properties
    this.currentVersionText,
    this.latestVersionText,
    this.updateAvailableText,
    this.forceUpdateText,
    this.errorText,
    this.releaseNotesTitle,
    this.downloadSizeText,
    this.lastCheckedText,
    this.forceUpdateRequirementText,
    this.errorDetailsText,
    this.connectionErrorText,
    this.customPlaceholders,
  });

  /// Create a copy with modified fields
  DialogConfig copyWith({
    String? title,
    String? message,
    String? positiveButtonText,
    String? negativeButtonText,
    bool? showNegativeButton,
    Color? backgroundColor,
    TextStyle? titleStyle,
    TextStyle? messageStyle,
    ButtonStyle? positiveButtonStyle,
    ButtonStyle? negativeButtonStyle,
    @Deprecated(
        'Use shape property instead for more flexible dialog shape customization')
    BorderRadius? borderRadius,
    double? elevation,
    bool? barrierDismissible,
    EdgeInsets? padding,
    Widget? customContent,
    List<Widget>? customActions,
    IconData? icon,
    Color? iconColor,
    double? iconSize,
    ShapeBorder? shape,
    // Text customization properties
    String? currentVersionText,
    String? latestVersionText,
    String? updateAvailableText,
    String? forceUpdateText,
    String? errorText,
    String? releaseNotesTitle,
    String? downloadSizeText,
    String? lastCheckedText,
    String? forceUpdateRequirementText,
    String? errorDetailsText,
    String? connectionErrorText,
    Map<String, String>? customPlaceholders,
  }) {
    return DialogConfig(
      title: title ?? this.title,
      message: message ?? this.message,
      positiveButtonText: positiveButtonText ?? this.positiveButtonText,
      negativeButtonText: negativeButtonText ?? this.negativeButtonText,
      showNegativeButton: showNegativeButton ?? this.showNegativeButton,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      titleStyle: titleStyle ?? this.titleStyle,
      messageStyle: messageStyle ?? this.messageStyle,
      positiveButtonStyle: positiveButtonStyle ?? this.positiveButtonStyle,
      negativeButtonStyle: negativeButtonStyle ?? this.negativeButtonStyle,
      // ignore: deprecated_member_use_from_same_package
      borderRadius: borderRadius ?? this.borderRadius,
      elevation: elevation ?? this.elevation,
      barrierDismissible: barrierDismissible ?? this.barrierDismissible,
      padding: padding ?? this.padding,
      customContent: customContent ?? this.customContent,
      customActions: customActions ?? this.customActions,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
      iconSize: iconSize ?? this.iconSize,
      shape: shape ?? this.shape,
      // Text customization properties
      currentVersionText: currentVersionText ?? this.currentVersionText,
      latestVersionText: latestVersionText ?? this.latestVersionText,
      updateAvailableText: updateAvailableText ?? this.updateAvailableText,
      forceUpdateText: forceUpdateText ?? this.forceUpdateText,
      errorText: errorText ?? this.errorText,
      releaseNotesTitle: releaseNotesTitle ?? this.releaseNotesTitle,
      downloadSizeText: downloadSizeText ?? this.downloadSizeText,
      lastCheckedText: lastCheckedText ?? this.lastCheckedText,
      forceUpdateRequirementText:
          forceUpdateRequirementText ?? this.forceUpdateRequirementText,
      errorDetailsText: errorDetailsText ?? this.errorDetailsText,
      connectionErrorText: connectionErrorText ?? this.connectionErrorText,
      customPlaceholders: customPlaceholders ?? this.customPlaceholders,
    );
  }

  /// Default configuration for update available dialog
  static const updateAvailable = DialogConfig(
    title: 'Update Available',
    message:
        'A new version of the app is available. Would you like to update now?',
    positiveButtonText: 'Update',
    negativeButtonText: 'Later',
    showNegativeButton: true,
    barrierDismissible: true,
  );

  /// Default configuration for forced update dialog
  static const forceUpdate = DialogConfig(
    title: 'Update Required',
    message:
        'This version is no longer supported. Please update to continue using the app.',
    positiveButtonText: 'Update Now',
    showNegativeButton: false,
    barrierDismissible: false,
  );

  /// Default configuration for error dialog
  static const error = DialogConfig(
    title: 'Error',
    message: 'Unable to check for updates. Please try again later.',
    positiveButtonText: 'OK',
    showNegativeButton: false,
    barrierDismissible: true,
  );
}
