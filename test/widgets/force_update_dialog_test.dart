import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:version_checker/src/models/dialog_config.dart';
import 'package:version_checker/src/models/version_check_response.dart';
import 'package:version_checker/src/widgets/force_update_dialog.dart';

void main() {
  group('ForceUpdateDialog', () {
    late VersionCheckResponse mockResponse;
    late DialogConfig mockConfig;

    setUp(() {
      mockResponse = VersionCheckResponse(
        success: true,
        currentVersion: '1.0.0',
        platform: 'ios',
        updateAvailable: true,
        latestVersion: '2.0.0',
        forceUpdate: true,
        downloadUrl: 'https://apps.apple.com/app/example',
        releaseNotes: 'Critical security update required',
      );

      mockConfig = DialogConfig.forceUpdate;
    });

    testWidgets('should display force update dialog with correct content',
        (tester) async {
      bool updatePressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ForceUpdateDialog(
              response: mockResponse,
              config: mockConfig,
              onUpdate: () => updatePressed = true,
            ),
          ),
        ),
      );

      // Verify dialog title
      expect(find.text('Update Required'), findsOneWidget);

      // Verify version information
      expect(find.textContaining('2.0.0'), findsWidgets);
      expect(find.textContaining('1.0.0'), findsOneWidget);

      // Verify release notes
      expect(find.text('Critical security update required'), findsOneWidget);

      // Verify only update button (no later button for force update)
      expect(find.text('Update Now'), findsOneWidget);
      expect(find.text('Later'), findsNothing);

      // Test update button
      await tester.tap(find.text('Update Now'));
      await tester.pump();
      expect(updatePressed, true);
    });

    testWidgets('should not be dismissible', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => ForceUpdateDialog(
                    response: mockResponse,
                    config: mockConfig,
                    onUpdate: () {},
                  ),
                ),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      // Show the dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Verify dialog is shown
      expect(find.text('Update Required'), findsOneWidget);

      // Try to dismiss by tapping outside (barrier)
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      // Dialog should still be visible (not dismissible)
      expect(find.text('Update Required'), findsOneWidget);
    });

    testWidgets('should apply custom styling from config', (tester) async {
      final customConfig = DialogConfig(
        title: 'Critical Update Required',
        positiveButtonText: 'Install Now',
        titleStyle: const TextStyle(fontSize: 22, color: Colors.red),
        messageStyle: const TextStyle(fontSize: 14, color: Colors.black87),
        positiveButtonStyle:
            ElevatedButton.styleFrom(backgroundColor: Colors.red),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ForceUpdateDialog(
              response: mockResponse,
              config: customConfig,
              onUpdate: () {},
            ),
          ),
        ),
      );

      // Verify custom title
      expect(find.text('Critical Update Required'), findsOneWidget);

      // Verify custom button text
      expect(find.text('Install Now'), findsOneWidget);

      // Verify icon is displayed
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);

      // Verify styling is applied
      final titleWidget =
          tester.widget<Text>(find.text('Critical Update Required'));
      expect(titleWidget.style?.fontSize, 22);
      expect(titleWidget.style?.color, Colors.red);
    });

    testWidgets('should handle missing release notes', (tester) async {
      final responseWithoutNotes = VersionCheckResponse(
        success: true,
        currentVersion: '1.0.0',
        platform: 'ios',
        updateAvailable: true,
        latestVersion: '2.0.0',
        forceUpdate: true,
        downloadUrl: 'https://apps.apple.com/app/example',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ForceUpdateDialog(
              response: responseWithoutNotes,
              config: mockConfig,
              onUpdate: () {},
            ),
          ),
        ),
      );

      // Should not show release notes section when null
      expect(find.text('What\'s New:'), findsNothing);

      // But should still show the dialog
      expect(find.text('Update Required'), findsOneWidget);
      expect(find.text('Update Now'), findsOneWidget);
    });

    testWidgets('should show warning styling by default', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ForceUpdateDialog(
              response: mockResponse,
              config: mockConfig,
              onUpdate: () {},
            ),
          ),
        ),
      );

      // Verify warning icon is shown by default
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);

      // Verify dialog is displayed
      expect(find.text('Update Required'), findsOneWidget);
    });

    testWidgets('should handle localized release notes', (tester) async {
      final responseWithLocalizedNotes = VersionCheckResponse(
        success: true,
        currentVersion: '1.0.0',
        platform: 'ios',
        updateAvailable: true,
        latestVersion: '2.0.0',
        forceUpdate: true,
        downloadUrl: 'https://apps.apple.com/app/example',
        releaseNotes: {
          'en': 'Critical security update required',
          'es': 'Actualización de seguridad crítica requerida',
        },
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ForceUpdateDialog(
              response: responseWithLocalizedNotes,
              config: mockConfig,
              onUpdate: () {},
            ),
          ),
        ),
      );

      // Should show English release notes by default
      expect(find.text('Critical security update required'), findsOneWidget);
    });

    testWidgets('should handle empty version strings gracefully',
        (tester) async {
      final responseWithEmptyVersions = VersionCheckResponse(
        success: true,
        currentVersion: '',
        platform: 'ios',
        updateAvailable: true,
        latestVersion: '',
        forceUpdate: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ForceUpdateDialog(
              response: responseWithEmptyVersions,
              config: mockConfig,
              onUpdate: () {},
            ),
          ),
        ),
      );

      // Should still render without crashing
      expect(find.text('Update Required'), findsOneWidget);
      expect(find.text('Update Now'), findsOneWidget);
    });

    testWidgets('should show prominent update button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ForceUpdateDialog(
              response: mockResponse,
              config: mockConfig,
              onUpdate: () {},
            ),
          ),
        ),
      );

      // Find the update button
      final updateButton = find.text('Update Now');
      expect(updateButton, findsOneWidget);

      // Verify it's an ElevatedButton (more prominent than TextButton)
      final buttonWidget = tester.widget<ElevatedButton>(
        find.ancestor(
          of: updateButton,
          matching: find.byType(ElevatedButton),
        ),
      );
      expect(buttonWidget, isNotNull);
    });

    testWidgets('should display version comparison prominently',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ForceUpdateDialog(
              response: mockResponse,
              config: mockConfig,
              onUpdate: () {},
            ),
          ),
        ),
      );

      // Should show both current and latest versions
      expect(find.textContaining('1.0.0'), findsOneWidget);
      expect(find.textContaining('2.0.0'), findsWidgets);

      // Should indicate it's a required update
      expect(find.text('Update Required'), findsOneWidget);
    });
  });
}
