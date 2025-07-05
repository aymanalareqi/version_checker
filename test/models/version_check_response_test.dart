import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:version_checker/src/models/version_check_response.dart';

void main() {
  group('VersionCheckResponse', () {
    test('should create successful response with all fields', () {
      final response = VersionCheckResponse(
        success: true,
        currentVersion: '1.0.0',
        platform: 'ios',
        updateAvailable: true,
        latestVersion: '1.1.0',
        forceUpdate: false,
        downloadUrl: 'https://apps.apple.com/app/example',
        releaseNotes: 'Bug fixes and improvements',
        platformLabel: 'iOS',
      );

      expect(response.success, true);
      expect(response.currentVersion, '1.0.0');
      expect(response.platform, 'ios');
      expect(response.updateAvailable, true);
      expect(response.latestVersion, '1.1.0');
      expect(response.forceUpdate, false);
      expect(response.downloadUrl, 'https://apps.apple.com/app/example');
      expect(response.releaseNotes, 'Bug fixes and improvements');
      expect(response.platformLabel, 'iOS');
      expect(response.error, isNull);
    });

    test('should create error response', () {
      final response = VersionCheckResponse(
        success: false,
        currentVersion: '1.0.0',
        platform: 'android',
        updateAvailable: false,
        forceUpdate: false,
        error: 'Network error',
      );

      expect(response.success, false);
      expect(response.currentVersion, '1.0.0');
      expect(response.platform, 'android');
      expect(response.updateAvailable, false);
      expect(response.forceUpdate, false);
      expect(response.error, 'Network error');
      expect(response.latestVersion, isNull);
      expect(response.downloadUrl, isNull);
      expect(response.releaseNotes, isNull);
    });

    test('should serialize to JSON correctly', () {
      final response = VersionCheckResponse(
        success: true,
        currentVersion: '1.0.0',
        platform: 'ios',
        updateAvailable: true,
        latestVersion: '1.1.0',
        forceUpdate: true,
        downloadUrl: 'https://apps.apple.com/app/example',
        releaseNotes: 'Critical security update',
        platformLabel: 'iOS',
      );

      final json = response.toJson();
      expect(json['success'], true);
      expect(json['current_version'], '1.0.0');
      expect(json['platform'], 'ios');
      expect(json['update_available'], true);
      expect(json['latest_version'], '1.1.0');
      expect(json['force_update'], true);
      expect(json['download_url'], 'https://apps.apple.com/app/example');
      expect(json['release_notes'], 'Critical security update');
      expect(json['platform_label'], 'iOS');
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'success': true,
        'current_version': '2.0.0',
        'platform': 'android',
        'update_available': true,
        'latest_version': '2.1.0',
        'force_update': false,
        'download_url': 'https://play.google.com/store/apps/details?id=example',
        'release_notes': 'New features added',
        'platform_label': 'Android',
      };

      final response = VersionCheckResponse.fromJson(json);
      expect(response.success, true);
      expect(response.currentVersion, '2.0.0');
      expect(response.platform, 'android');
      expect(response.updateAvailable, true);
      expect(response.latestVersion, '2.1.0');
      expect(response.forceUpdate, false);
      expect(response.downloadUrl,
          'https://play.google.com/store/apps/details?id=example');
      expect(response.releaseNotes, 'New features added');
      expect(response.platformLabel, 'Android');
    });

    test('should handle missing optional fields in JSON', () {
      final json = {
        'success': true,
        'current_version': '1.0.0',
        'platform': 'ios',
        'update_available': false,
        'force_update': false,
      };

      final response = VersionCheckResponse.fromJson(json);
      expect(response.success, true);
      expect(response.currentVersion, '1.0.0');
      expect(response.platform, 'ios');
      expect(response.updateAvailable, false);
      expect(response.forceUpdate, false);
      expect(response.latestVersion, isNull);
      expect(response.downloadUrl, isNull);
      expect(response.releaseNotes, isNull);
      expect(response.platformLabel, isNull);
      expect(response.error, isNull);
    });

    test('should handle localized release notes as Map', () {
      final json = {
        'success': true,
        'current_version': '1.0.0',
        'platform': 'ios',
        'update_available': true,
        'latest_version': '1.1.0',
        'force_update': false,
        'release_notes': {
          'en': 'Bug fixes and improvements',
          'es': 'Corrección de errores y mejoras',
          'fr': 'Corrections de bugs et améliorations',
        },
      };

      final response = VersionCheckResponse.fromJson(json);
      expect(response.releaseNotes, isA<Map<String, dynamic>>());

      // Test getLocalizedReleaseNotes with different locales
      expect(response.getLocalizedReleaseNotes('en'),
          'Bug fixes and improvements');
      expect(response.getLocalizedReleaseNotes('es'),
          'Corrección de errores y mejoras');
      expect(response.getLocalizedReleaseNotes('fr'),
          'Corrections de bugs et améliorations');
      expect(response.getLocalizedReleaseNotes('de'),
          isNull); // Non-existent locale
    });

    test('should handle release notes as String', () {
      final response = VersionCheckResponse(
        success: true,
        currentVersion: '1.0.0',
        platform: 'ios',
        updateAvailable: false,
        forceUpdate: false,
        releaseNotes: 'Simple release notes',
      );

      expect(response.getLocalizedReleaseNotes(), 'Simple release notes');
      expect(response.getLocalizedReleaseNotes('en'), 'Simple release notes');
      expect(response.getLocalizedReleaseNotes('es'), 'Simple release notes');
    });

    test(
        'should return null for getLocalizedReleaseNotes when releaseNotes is null',
        () {
      final response = VersionCheckResponse(
        success: true,
        currentVersion: '1.0.0',
        platform: 'ios',
        updateAvailable: false,
        forceUpdate: false,
      );

      expect(response.getLocalizedReleaseNotes(), isNull);
      expect(response.getLocalizedReleaseNotes('en'), isNull);
    });

    test('should handle JSON serialization round trip', () {
      final originalResponse = VersionCheckResponse(
        success: true,
        currentVersion: '1.0.0',
        platform: 'ios',
        updateAvailable: true,
        latestVersion: '1.1.0',
        forceUpdate: true,
        downloadUrl: 'https://apps.apple.com/app/example',
        releaseNotes: 'Test release notes',
        platformLabel: 'iOS',
      );

      final json = originalResponse.toJson();
      final jsonString = jsonEncode(json);
      final decodedJson = jsonDecode(jsonString) as Map<String, dynamic>;
      final deserializedResponse = VersionCheckResponse.fromJson(decodedJson);

      expect(deserializedResponse.success, originalResponse.success);
      expect(
          deserializedResponse.currentVersion, originalResponse.currentVersion);
      expect(deserializedResponse.platform, originalResponse.platform);
      expect(deserializedResponse.updateAvailable,
          originalResponse.updateAvailable);
      expect(
          deserializedResponse.latestVersion, originalResponse.latestVersion);
      expect(deserializedResponse.forceUpdate, originalResponse.forceUpdate);
      expect(deserializedResponse.downloadUrl, originalResponse.downloadUrl);
      expect(deserializedResponse.releaseNotes, originalResponse.releaseNotes);
      expect(
          deserializedResponse.platformLabel, originalResponse.platformLabel);
    });

    test('should support equality comparison', () {
      final response1 = VersionCheckResponse(
        success: true,
        currentVersion: '1.0.0',
        platform: 'ios',
        updateAvailable: true,
        forceUpdate: false,
        latestVersion: '1.1.0',
      );

      final response2 = VersionCheckResponse(
        success: true,
        currentVersion: '1.0.0',
        platform: 'ios',
        updateAvailable: true,
        forceUpdate: false,
        latestVersion: '1.1.0',
      );

      final response3 = VersionCheckResponse(
        success: true,
        currentVersion: '1.0.0',
        platform: 'android',
        updateAvailable: true,
        forceUpdate: false,
        latestVersion: '1.1.0',
      );

      expect(response1, equals(response2));
      expect(response1, isNot(equals(response3)));
    });

    test('should have meaningful toString', () {
      final response = VersionCheckResponse(
        success: true,
        currentVersion: '1.0.0',
        platform: 'ios',
        updateAvailable: true,
        forceUpdate: false,
        latestVersion: '1.1.0',
      );

      final string = response.toString();
      expect(string, contains('VersionCheckResponse'));
      expect(string, contains('success: true'));
      expect(string, contains('1.0.0'));
      expect(string, contains('ios'));
      expect(string, contains('1.1.0'));
    });
  });
}
