import 'package:flutter/material.dart';
import '../models/dialog_config.dart';

/// Dialog widget for showing error messages
class ErrorDialog extends StatelessWidget {
  final String error;
  final DialogConfig config;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;

  const ErrorDialog({
    super.key,
    required this.error,
    required this.config,
    this.onRetry,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: config.backgroundColor,
      elevation: config.elevation,
      shape: _getDialogShape(),
      contentPadding: config.padding ?? const EdgeInsets.all(24.0),
      content: config.customContent ?? _buildDefaultContent(context),
      actions: config.customActions ?? _buildDefaultActions(context),
    );
  }

  /// Get the dialog shape, prioritizing [shape] over [borderRadius]
  ShapeBorder? _getDialogShape() {
    if (config.shape != null) {
      return config.shape;
    }
    // ignore: deprecated_member_use_from_same_package
    if (config.borderRadius != null) {
      // ignore: deprecated_member_use_from_same_package
      return RoundedRectangleBorder(borderRadius: config.borderRadius!);
    }
    return null;
  }

  Widget _buildDefaultContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Error icon
        Icon(
          config.icon ?? Icons.error_outline,
          size: config.iconSize ?? 64,
          color: config.iconColor ?? Colors.red[600],
        ),
        const SizedBox(height: 16),
        if (config.title != null) ...[
          Text(
            config.title!,
            style: config.titleStyle ??
                Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.red[700],
                    ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
        ],
        if (config.message != null) ...[
          Text(
            config.message!,
            style:
                config.messageStyle ?? Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
        ],
        _buildErrorMessage(context),
      ],
    );
  }

  Widget _buildErrorMessage(BuildContext context) {
    return Column(
      children: [
        Text(
          'Unable to check for updates',
          style: config.messageStyle ??
              Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Error Details:',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.red[700],
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                error,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.red[600],
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Please check your internet connection and try again.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  List<Widget> _buildDefaultActions(BuildContext context) {
    final actions = <Widget>[];

    // Add negative button if configured
    if (config.showNegativeButton && config.negativeButtonText != null) {
      actions.add(
        TextButton(
          style: config.negativeButtonStyle,
          onPressed: () {
            Navigator.of(context).pop();
            onDismiss?.call();
          },
          child: Text(config.negativeButtonText!),
        ),
      );
    }

    // Add positive button (retry or dismiss)
    actions.add(
      ElevatedButton(
        style: config.positiveButtonStyle ??
            ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
        onPressed: () {
          Navigator.of(context).pop();
          if (onRetry != null) {
            onRetry?.call();
          } else {
            onDismiss?.call();
          }
        },
        child: Text(_getPositiveButtonText()),
      ),
    );

    return actions;
  }

  String _getPositiveButtonText() {
    // If onRetry is provided and config is the default error config, show "Retry"
    if (onRetry != null && config == DialogConfig.error) {
      return 'Retry';
    }
    // Otherwise, use the configured text or default to appropriate text
    return config.positiveButtonText ?? (onRetry != null ? 'Retry' : 'OK');
  }

  /// Show the error dialog
  static Future<void> show(
    BuildContext context, {
    required String error,
    DialogConfig config = DialogConfig.error,
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: config.barrierDismissible,
      builder: (context) => ErrorDialog(
        error: error,
        config: config,
        onRetry: onRetry,
        onDismiss: onDismiss,
      ),
    ).then((_) => onDismiss?.call());
  }
}
