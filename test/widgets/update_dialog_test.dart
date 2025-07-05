import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:version_checker/src/models/dialog_config.dart';
import 'package:version_checker/src/models/version_check_response.dart';
import 'package:version_checker/src/widgets/update_dialog.dart';

void main() {
  group('UpdateDialog', () {
    late VersionCheckResponse mockResponse;
    late DialogConfig mockConfig;

    setUp(() {
      mockResponse = VersionCheckResponse(
        success: true,
        currentVersion: '1.0.0',
        platform: 'ios',
        updateAvailable: true,
        latestVersion: '1.1.0',
        forceUpdate: false,
        downloadUrl: 'https://apps.apple.com/app/example',
        releaseNotes: 'Bug fixes and improvements',
      );

      mockConfig = DialogConfig.updateAvailable;
    });

    testWidgets('should display update dialog with correct content',
        (tester) async {
      bool updatePressed = false;
      bool laterPressed = false; // ignore: unused_local_variable

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UpdateDialog(
              response: mockResponse,
              config: mockConfig,
              onUpdate: () => updatePressed = true,
              onLater: () => laterPressed = true,
            ),
          ),
        ),
      );

      // Verify dialog title
      expect(find.text('Update Available'), findsOneWidget);

      // Verify version information
      expect(find.textContaining('1.1.0'), findsOneWidget);
      expect(find.textContaining('1.0.0'), findsOneWidget);

      // Verify release notes
      expect(find.text('Bug fixes and improvements'), findsOneWidget);

      // Verify buttons
      expect(find.text('Update'), findsOneWidget);
      expect(find.text('Later'), findsOneWidget);

      // Test update button
      await tester.tap(find.text('Update'));
      await tester.pump();
      expect(updatePressed, true);
    });

    testWidgets('should handle later button tap', (tester) async {
      bool laterPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UpdateDialog(
              response: mockResponse,
              config: mockConfig,
              onLater: () => laterPressed = true,
            ),
          ),
        ),
      );

      // Test later button
      await tester.tap(find.text('Later'), warnIfMissed: false);
      await tester.pump();
      expect(laterPressed, true);
    });

    testWidgets('should handle missing release notes', (tester) async {
      final responseWithoutNotes = VersionCheckResponse(
        success: true,
        currentVersion: '1.0.0',
        platform: 'ios',
        updateAvailable: true,
        latestVersion: '1.1.0',
        forceUpdate: false,
        downloadUrl: 'https://apps.apple.com/app/example',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UpdateDialog(
              response: responseWithoutNotes,
              config: mockConfig,
              onUpdate: () {},
              onLater: () {},
            ),
          ),
        ),
      );

      // Should not show release notes section when null
      expect(find.text('What\'s New:'), findsNothing);
    });

    testWidgets('should apply custom styling from config', (tester) async {
      final customConfig = DialogConfig(
        title: 'Custom Update Title',
        positiveButtonText: 'Download Now',
        negativeButtonText: 'Skip',
        titleStyle: const TextStyle(fontSize: 24, color: Colors.red),
        messageStyle: const TextStyle(fontSize: 16, color: Colors.blue),
        positiveButtonStyle:
            ElevatedButton.styleFrom(backgroundColor: Colors.green),
        negativeButtonStyle:
            TextButton.styleFrom(foregroundColor: Colors.orange),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UpdateDialog(
              response: mockResponse,
              config: customConfig,
              onUpdate: () {},
              onLater: () {},
            ),
          ),
        ),
      );

      // Verify custom title
      expect(find.text('Custom Update Title'), findsOneWidget);

      // Verify custom button texts
      expect(find.text('Download Now'), findsOneWidget);
      expect(find.text('Skip'), findsOneWidget);

      // Verify styling is applied (check for styled widgets)
      final titleWidget = tester.widget<Text>(find.text('Custom Update Title'));
      expect(titleWidget.style?.fontSize, 24);
      expect(titleWidget.style?.color, Colors.red);
    });

    testWidgets('should handle localized release notes', (tester) async {
      final responseWithLocalizedNotes = VersionCheckResponse(
        success: true,
        currentVersion: '1.0.0',
        platform: 'ios',
        updateAvailable: true,
        latestVersion: '1.1.0',
        forceUpdate: false,
        downloadUrl: 'https://apps.apple.com/app/example',
        releaseNotes: {
          'en': 'Bug fixes and improvements',
          'es': 'Corrección de errores y mejoras',
        },
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UpdateDialog(
              response: responseWithLocalizedNotes,
              config: mockConfig,
              onUpdate: () {},
              onLater: () {},
            ),
          ),
        ),
      );

      // Should show English release notes by default
      expect(find.text('Bug fixes and improvements'), findsOneWidget);
    });

    testWidgets('should be dismissible by default', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => UpdateDialog(
                    response: mockResponse,
                    config: mockConfig,
                    onUpdate: () {},
                    onLater: () {},
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
      expect(find.text('Update Available'), findsOneWidget);

      // Try to dismiss by tapping outside (barrier)
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      // Dialog should be dismissed
      expect(find.text('Update Available'), findsNothing);
    });

    testWidgets('should handle empty version strings gracefully',
        (tester) async {
      final responseWithEmptyVersions = VersionCheckResponse(
        success: true,
        currentVersion: '',
        platform: 'ios',
        updateAvailable: true,
        latestVersion: '',
        forceUpdate: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UpdateDialog(
              response: responseWithEmptyVersions,
              config: mockConfig,
              onUpdate: () {},
              onLater: () {},
            ),
          ),
        ),
      );

      // Should still render without crashing
      expect(find.text('Update Available'), findsOneWidget);
      expect(find.text('Update'), findsOneWidget);
      expect(find.text('Later'), findsOneWidget);
    });

    testWidgets('should show icon when provided in config', (tester) async {
      final configWithIcon = DialogConfig(
        title: 'Update Available',
        positiveButtonText: 'Update',
        negativeButtonText: 'Later',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UpdateDialog(
              response: mockResponse,
              config: configWithIcon,
              onUpdate: () {},
              onLater: () {},
            ),
          ),
        ),
      );

      // Verify icon is displayed
      expect(find.byIcon(Icons.system_update), findsOneWidget);
    });
  });
}
