import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:version_checker/src/models/dialog_config.dart';
import 'package:version_checker/src/models/version_check_response.dart';
import 'package:version_checker/src/widgets/error_dialog.dart';

void main() {
  group('ErrorDialog', () {
    late VersionCheckResponse mockErrorResponse;
    late DialogConfig mockConfig;

    setUp(() {
      mockErrorResponse = VersionCheckResponse(
        success: false,
        currentVersion: '1.0.0',
        platform: 'ios',
        updateAvailable: false,
        forceUpdate: false,
        error: 'Network connection failed',
      );

      mockConfig = DialogConfig.error;
    });

    testWidgets('should display error dialog with correct content',
        (tester) async {
      bool dismissPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorDialog(
              error: mockErrorResponse.error!,
              config: mockConfig,
              onDismiss: () => dismissPressed = true,
            ),
          ),
        ),
      );

      // Verify dialog title
      expect(find.text('Error'), findsOneWidget);

      // Verify error message
      expect(find.text('Network connection failed'), findsOneWidget);

      // Verify buttons (only OK button for DialogConfig.error)
      expect(find.text('OK'), findsOneWidget);

      // Test OK button (should call onDismiss since no onRetry)
      await tester.tap(find.text('OK'));
      await tester.pump();
      expect(dismissPressed, true);
    });

    testWidgets('should apply custom styling from config', (tester) async {
      final customConfig = DialogConfig(
        title: 'Connection Error',
        positiveButtonText: 'Try Again',
        negativeButtonText: 'Cancel',
        titleStyle: const TextStyle(fontSize: 20, color: Colors.red),
        messageStyle: const TextStyle(fontSize: 14, color: Colors.black54),
        positiveButtonStyle:
            ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        negativeButtonStyle: TextButton.styleFrom(foregroundColor: Colors.grey),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorDialog(
              error: mockErrorResponse.error!,
              config: customConfig,
              onRetry: () {},
              onDismiss: () {},
            ),
          ),
        ),
      );

      // Verify custom title
      expect(find.text('Connection Error'), findsOneWidget);

      // Verify custom button texts
      expect(find.text('Try Again'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      // Verify icon is displayed
      expect(find.byIcon(Icons.error_outline), findsOneWidget);

      // Verify styling is applied
      final titleWidget = tester.widget<Text>(find.text('Connection Error'));
      expect(titleWidget.style?.fontSize, 20);
      expect(titleWidget.style?.color, Colors.red);
    });

    testWidgets('should show error icon by default', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorDialog(
              error: mockErrorResponse.error!,
              config: mockConfig,
              onRetry: () {},
              onDismiss: () {},
            ),
          ),
        ),
      );

      // Verify error icon is shown by default
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('should handle missing error message', (tester) async {
      final responseWithoutError = VersionCheckResponse(
        success: false,
        currentVersion: '1.0.0',
        platform: 'ios',
        updateAvailable: false,
        forceUpdate: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorDialog(
              error: responseWithoutError.error ?? 'Unknown error',
              config: mockConfig,
              onRetry: () {},
              onDismiss: () {},
            ),
          ),
        ),
      );

      // Should show generic error message when specific error is null
      expect(find.text('Unable to check for updates'), findsOneWidget);
      expect(find.text('Unknown error'), findsOneWidget);
    });

    testWidgets('should be dismissible by default', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => ErrorDialog(
                    error: mockErrorResponse.error!,
                    config: mockConfig,
                    onRetry: () {},
                    onDismiss: () {},
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
      expect(find.text('Error'), findsOneWidget);

      // Try to dismiss by tapping outside (barrier)
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      // Dialog should be dismissed
      expect(find.text('Error'), findsNothing);
    });

    testWidgets('should handle long error messages', (tester) async {
      final responseWithLongError = VersionCheckResponse(
        success: false,
        currentVersion: '1.0.0',
        platform: 'ios',
        updateAvailable: false,
        forceUpdate: false,
        error:
            'This is a very long error message that should be displayed properly in the dialog without causing overflow issues or layout problems. It should wrap nicely and be readable.',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorDialog(
              error: responseWithLongError.error!,
              config: mockConfig,
              onRetry: () {},
              onDismiss: () {},
            ),
          ),
        ),
      );

      // Should display the long error message
      expect(find.textContaining('This is a very long error message'),
          findsOneWidget);

      // Should still show the dialog structure
      expect(find.text('Error'), findsOneWidget);
      expect(find.text('Retry'),
          findsOneWidget); // Should show Retry since onRetry is provided
    });

    testWidgets('should handle different error types', (tester) async {
      final networkError = VersionCheckResponse(
        success: false,
        currentVersion: '1.0.0',
        platform: 'ios',
        updateAvailable: false,
        forceUpdate: false,
        error: 'Network timeout',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorDialog(
              error: networkError.error!,
              config: mockConfig,
              onRetry: () {},
              onDismiss: () {},
            ),
          ),
        ),
      );

      expect(find.text('Network timeout'), findsOneWidget);
    });

    testWidgets('should allow retry functionality', (tester) async {
      int retryCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorDialog(
              error: mockErrorResponse.error!,
              config: mockConfig,
              onRetry: () => retryCount++,
              onDismiss: () {},
            ),
          ),
        ),
      );

      // Test retry button functionality
      await tester.tap(find.text('Retry'), warnIfMissed: false);
      await tester.pump();
      expect(retryCount, 1);
    });

    testWidgets('should show appropriate button styling', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorDialog(
              error: mockErrorResponse.error!,
              config: mockConfig,
              onRetry: () {},
              onDismiss: () {},
            ),
          ),
        ),
      );

      // Find the retry button (should be ElevatedButton for prominence)
      final retryButton = find.text('Retry');
      expect(retryButton, findsOneWidget);

      // Verify button type - retry button should be ElevatedButton
      expect(
        find.ancestor(
          of: retryButton,
          matching: find.byType(ElevatedButton),
        ),
        findsOneWidget,
      );
    });
  });
}
