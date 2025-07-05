import 'package:flutter/material.dart';
import '../models/dialog_config.dart';
import '../models/version_check_response.dart';
import '../utils/text_formatter.dart';

/// Dialog widget for showing update available notifications
class UpdateDialog extends StatelessWidget {
  final VersionCheckResponse response;
  final DialogConfig config;
  final VoidCallback? onUpdate;
  final VoidCallback? onLater;
  final VoidCallback? onDismiss;

  const UpdateDialog({
    super.key,
    required this.response,
    required this.config,
    this.onUpdate,
    this.onLater,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: config.backgroundColor,
      elevation: config.elevation,
      shape: config.borderRadius != null
          ? RoundedRectangleBorder(borderRadius: config.borderRadius!)
          : null,
      contentPadding: config.padding ?? const EdgeInsets.all(24.0),
      content: config.customContent ?? _buildDefaultContent(context),
      actions: config.customActions ?? _buildDefaultActions(context),
    );
  }

  Widget _buildDefaultContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Update icon
        Center(
          child: Icon(
            Icons.system_update,
            size: 64,
            color: Colors.blue[600],
          ),
        ),
        const SizedBox(height: 16),
        if (config.title != null) ...[
          Text(
            config.title!,
            style: config.titleStyle ??
                Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
          ),
          const SizedBox(height: 16),
        ],
        if (config.message != null) ...[
          Text(
            config.message!,
            style:
                config.messageStyle ?? Theme.of(context).textTheme.bodyMedium,
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          TextFormatter.formatUpdateAvailableText(
            config.updateAvailableText,
            response,
            customPlaceholders: config.customPlaceholders,
          ),
          style: config.messageStyle ?? Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              TextFormatter.formatCurrentVersionText(
                config.currentVersionText,
                response,
                customPlaceholders: config.customPlaceholders,
              ),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(width: 16),
            Text(
              TextFormatter.formatLatestVersionText(
                config.latestVersionText,
                response,
                customPlaceholders: config.customPlaceholders,
              ),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.green[600],
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
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
          TextFormatter.formatReleaseNotesTitle(
            config.releaseNotesTitle,
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
            color: config.backgroundColor?.withOpacity(0.1) ?? Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
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
    final actions = <Widget>[];

    if (config.showNegativeButton) {
      actions.add(
        TextButton(
          style: config.negativeButtonStyle,
          onPressed: () {
            Navigator.of(context).pop();
            onLater?.call();
          },
          child: Text(config.negativeButtonText ?? 'Later'),
        ),
      );
    }

    actions.add(
      ElevatedButton(
        style: config.positiveButtonStyle ??
            ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
        onPressed: () {
          Navigator.of(context).pop();
          onUpdate?.call();
        },
        child: Text(config.positiveButtonText ?? 'Update'),
      ),
    );

    return actions;
  }

  /// Show the update dialog
  static Future<void> show(
    BuildContext context, {
    required VersionCheckResponse response,
    DialogConfig config = DialogConfig.updateAvailable,
    VoidCallback? onUpdate,
    VoidCallback? onLater,
    VoidCallback? onDismiss,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: config.barrierDismissible,
      builder: (context) => UpdateDialog(
        response: response,
        config: config,
        onUpdate: onUpdate,
        onLater: onLater,
        onDismiss: onDismiss,
      ),
    ).then((_) => onDismiss?.call());
  }
}
