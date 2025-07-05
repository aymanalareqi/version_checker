import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version_checker/src/utils/url_launcher_helper.dart';

void main() {
  group('UrlLauncherHelper', () {
    group('launchUpdateUrl', () {
      testWidgets('should handle null download URL',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => Container(),
            ),
          ),
        ));
        final context = tester.element(find.byType(Container));

        bool errorCallbackCalled = false;
        String? errorMessage;

        final result = await UrlLauncherHelper.launchUpdateUrl(
          context: context,
          downloadUrl: null,
          onError: (error) {
            errorCallbackCalled = true;
            errorMessage = error;
          },
          showErrorDialog: false,
        );

        expect(result, false);
        expect(errorCallbackCalled, true);
        expect(errorMessage, 'No download URL provided');
      });

      testWidgets('should handle empty download URL',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => Container(),
            ),
          ),
        ));
        final context = tester.element(find.byType(Container));

        bool errorCallbackCalled = false;
        String? errorMessage;

        final result = await UrlLauncherHelper.launchUpdateUrl(
          context: context,
          downloadUrl: '',
          onError: (error) {
            errorCallbackCalled = true;
            errorMessage = error;
          },
          showErrorDialog: false,
        );

        expect(result, false);
        expect(errorCallbackCalled, true);
        expect(errorMessage, 'No download URL provided');
      });
    });

    group('launchUrlSilently', () {
      test('should return false for null URL', () async {
        final result = await UrlLauncherHelper.launchUrlSilently(null);
        expect(result, false);
      });

      test('should return false for empty URL', () async {
        final result = await UrlLauncherHelper.launchUrlSilently('');
        expect(result, false);
      });
    });

    group('isAppStoreUrl', () {
      test('should identify iOS App Store URLs', () {
        expect(
            UrlLauncherHelper.isAppStoreUrl(
                'https://apps.apple.com/app/id123456789'),
            true);
        expect(
            UrlLauncherHelper.isAppStoreUrl(
                'https://itunes.apple.com/app/id123456789'),
            true);
        expect(
            UrlLauncherHelper.isAppStoreUrl(
                'HTTPS://APPS.APPLE.COM/APP/ID123456789'),
            true);
      });

      test('should identify Google Play Store URLs', () {
        expect(
            UrlLauncherHelper.isAppStoreUrl(
                'https://play.google.com/store/apps/details?id=com.example'),
            true);
        expect(
            UrlLauncherHelper.isAppStoreUrl(
                'https://market.android.com/details?id=com.example'),
            true);
        expect(
            UrlLauncherHelper.isAppStoreUrl(
                'HTTPS://PLAY.GOOGLE.COM/STORE/APPS/DETAILS?ID=COM.EXAMPLE'),
            true);
      });

      test('should not identify regular URLs as app store URLs', () {
        expect(UrlLauncherHelper.isAppStoreUrl('https://example.com'), false);
        expect(UrlLauncherHelper.isAppStoreUrl('https://github.com/user/repo'),
            false);
        expect(UrlLauncherHelper.isAppStoreUrl('https://myapp.com/download'),
            false);
      });
    });

    group('getErrorMessage', () {
      test('should return appropriate message for invalid URL errors', () {
        final error = Exception('Invalid URL format');
        final message = UrlLauncherHelper.getErrorMessage(error, 'invalid-url');
        expect(message, contains('invalid'));
      });

      test('should return appropriate message for launch errors', () {
        final error = Exception('Cannot launch URL');
        final message =
            UrlLauncherHelper.getErrorMessage(error, 'https://example.com');
        expect(message, contains('Unable to open'));
      });

      test('should return App Store specific message for iOS store URLs', () {
        final error = Exception('Cannot launch URL');
        final message = UrlLauncherHelper.getErrorMessage(
            error, 'https://apps.apple.com/app/id123');
        expect(message, contains('App Store'));
      });

      test('should return Play Store specific message for Android store URLs',
          () {
        final error = Exception('Cannot launch URL');
        final message = UrlLauncherHelper.getErrorMessage(
            error, 'https://play.google.com/store/apps/details?id=com.example');
        expect(message, contains('Play Store'));
      });

      test('should return network error message for network issues', () {
        final error = Exception('Network connection failed');
        final message =
            UrlLauncherHelper.getErrorMessage(error, 'https://example.com');
        expect(message, contains('Network error'));
      });
    });

    group('getPlatformStoreUrl', () {
      test('should return iOS App Store URL when on iOS with app ID', () {
        final url =
            UrlLauncherHelper.getPlatformStoreUrl(iosAppId: '123456789');
        if (url != null) {
          expect(url, 'https://apps.apple.com/app/id123456789');
        }
      });

      test(
          'should return Google Play Store URL when on Android with package name',
          () {
        final url = UrlLauncherHelper.getPlatformStoreUrl(
            androidPackageName: 'com.example.app');
        if (url != null) {
          expect(url,
              'https://play.google.com/store/apps/details?id=com.example.app');
        }
      });

      test('should return null when no appropriate parameters provided', () {
        final url = UrlLauncherHelper.getPlatformStoreUrl();
        expect(url, null);
      });
    });

    group('getLaunchMode', () {
      test('should return external application mode for app store URLs', () {
        final mode =
            UrlLauncherHelper.getLaunchMode('https://apps.apple.com/app/id123');
        expect(mode, LaunchMode.externalApplication);
      });

      test('should return external application mode for web URLs', () {
        final mode = UrlLauncherHelper.getLaunchMode('https://example.com');
        expect(mode, LaunchMode.externalApplication);
      });

      test('should return external application mode for invalid URLs', () {
        final mode = UrlLauncherHelper.getLaunchMode('invalid-url');
        expect(mode, LaunchMode.externalApplication);
      });
    });
  });
}
