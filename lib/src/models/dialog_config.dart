import 'package:flutter/material.dart';

/// Configuration for customizing dialog appearance and behavior
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
    BorderRadius? borderRadius,
    double? elevation,
    bool? barrierDismissible,
    EdgeInsets? padding,
    Widget? customContent,
    List<Widget>? customActions,
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
      borderRadius: borderRadius ?? this.borderRadius,
      elevation: elevation ?? this.elevation,
      barrierDismissible: barrierDismissible ?? this.barrierDismissible,
      padding: padding ?? this.padding,
      customContent: customContent ?? this.customContent,
      customActions: customActions ?? this.customActions,
    );
  }

  /// Default configuration for update available dialog
  static const updateAvailable = DialogConfig(
    title: 'Update Available',
    message: 'A new version of the app is available. Would you like to update now?',
    positiveButtonText: 'Update',
    negativeButtonText: 'Later',
    showNegativeButton: true,
    barrierDismissible: true,
  );

  /// Default configuration for forced update dialog
  static const forceUpdate = DialogConfig(
    title: 'Update Required',
    message: 'This version is no longer supported. Please update to continue using the app.',
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
