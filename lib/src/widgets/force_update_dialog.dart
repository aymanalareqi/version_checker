import 'package:flutter/material.dart';
import '../models/dialog_config.dart';
import '../models/version_check_response.dart';
import '../utils/text_formatter.dart';

/// Dialog widget for showing forced update notifications
class ForceUpdateDialog extends StatelessWidget {
  final VersionCheckResponse response;
  final DialogConfig config;
  final VoidCallback? onUpdate;

  const ForceUpdateDialog({
    super.key,
    required this.response,
    required this.config,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => config.barrierDismissible,
      child: AlertDialog(
        backgroundColor: config.backgroundColor,
        elevation: config.elevation,
        shape: _getDialogShape(),
        contentPadding: config.padding ?? const EdgeInsets.all(24.0),
        content: config.customContent ?? _buildDefaultContent(context),
        actions: config.customActions ?? _buildDefaultActions(context),
      ),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Warning icon
        Center(
          child: Icon(
            config.icon ?? Icons.warning_amber_rounded,
            size: config.iconSize ?? 64,
            color: config.iconColor ?? Colors.orange[600],
          ),
        ),
        const SizedBox(height: 16),
        if (config.title != null) ...[
          Center(
            child: Text(
              config.title!,
              style: config.titleStyle ??
                  Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.red[700],
                      ),
              textAlign: TextAlign.center,
            ),
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
        _buildVersionInfo(context),
        if (response.releaseNotes != null) ...[
          const SizedBox(height: 16),
          _buildReleaseNotes(context),
        ],
      ],
    );
  }

  Widget _buildVersionInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          TextFormatter.formatForceUpdateText(
            config.forceUpdateText,
            response,
            customPlaceholders: config.customPlaceholders,
          ),
          style: config.messageStyle ??
              Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          TextFormatter.format(
            config.forceUpdateRequirementText ??
                'Please update to version {latestVersion} to continue using the app.',
            response: response,
            customPlaceholders: config.customPlaceholders,
          ),
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red[200]!),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                TextFormatter.formatCurrentVersionText(
                  config.currentVersionText,
                  response,
                  customPlaceholders: config.customPlaceholders,
                ),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.red[700],
                    ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.arrow_forward, size: 16, color: Colors.red[700]),
              const SizedBox(width: 16),
              Text(
                TextFormatter.format(
                  config.latestVersionText ?? 'Required: {latestVersion}',
                  response: response,
                  customPlaceholders: config.customPlaceholders,
                ),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.red[700],
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReleaseNotes(BuildContext context) {
    final notes = response.getLocalizedReleaseNotes();
    if (notes == null || notes.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          TextFormatter.format(
            config.releaseNotesTitle ?? 'Update Details:',
            customPlaceholders: config.customPlaceholders,
          ),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue[200]!),
          ),
          child: Text(
            notes,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildDefaultActions(BuildContext context) {
    return [
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: config.positiveButtonStyle ??
              ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
          onPressed: () {
            Navigator.of(context).pop();
            onUpdate?.call();
          },
          child: Text(
            config.positiveButtonText ?? 'Update Now',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ];
  }

  /// Show the force update dialog
  static Future<void> show(
    BuildContext context, {
    required VersionCheckResponse response,
    DialogConfig config = DialogConfig.forceUpdate,
    VoidCallback? onUpdate,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: config.barrierDismissible,
      builder: (context) => ForceUpdateDialog(
        response: response,
        config: config,
        onUpdate: onUpdate,
      ),
    );
  }
}
