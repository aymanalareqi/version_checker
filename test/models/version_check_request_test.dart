import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:version_checker/src/models/version_check_request.dart';

void main() {
  group('VersionCheckRequest', () {
    test('should create instance with required parameters', () {
      const request = VersionCheckRequest(
        platform: 'ios',
        currentVersion: '1.0.0',
        buildNumber: '123',
      );

      expect(request.platform, 'ios');
      expect(request.currentVersion, '1.0.0');
      expect(request.buildNumber, '123');
      expect(request.locale, isNull);
    });

    test('should create instance with all parameters', () {
      const request = VersionCheckRequest(
        platform: 'android',
        currentVersion: '2.1.0',
        buildNumber: '456',
        locale: 'en',
      );

      expect(request.platform, 'android');
      expect(request.currentVersion, '2.1.0');
      expect(request.buildNumber, '456');
      expect(request.locale, 'en');
    });

    test('should serialize to JSON correctly', () {
      const request = VersionCheckRequest(
        platform: 'ios',
        currentVersion: '1.0.0',
        buildNumber: '123',
        locale: 'en',
      );

      final json = request.toJson();
      expect(json, {
        'platform': 'ios',
        'current_version': '1.0.0',
        'build_number': '123',
        'locale': 'en',
      });
    });

    test('should serialize to JSON without locale when null', () {
      const request = VersionCheckRequest(
        platform: 'android',
        currentVersion: '2.0.0',
        buildNumber: '789',
      );

      final json = request.toJson();
      expect(json, {
        'platform': 'android',
        'current_version': '2.0.0',
        'build_number': '789',
      });
      expect(json.containsKey('locale'), false);
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'platform': 'ios',
        'current_version': '1.5.0',
        'build_number': '999',
        'locale': 'es',
      };

      final request = VersionCheckRequest.fromJson(json);
      expect(request.platform, 'ios');
      expect(request.currentVersion, '1.5.0');
      expect(request.buildNumber, '999');
      expect(request.locale, 'es');
    });

    test('should deserialize from JSON without locale', () {
      final json = {
        'platform': 'android',
        'current_version': '3.0.0',
        'build_number': '111',
      };

      final request = VersionCheckRequest.fromJson(json);
      expect(request.platform, 'android');
      expect(request.currentVersion, '3.0.0');
      expect(request.buildNumber, '111');
      expect(request.locale, isNull);
    });

    test('should handle JSON serialization round trip', () {
      const originalRequest = VersionCheckRequest(
        platform: 'ios',
        currentVersion: '1.0.0',
        buildNumber: '123',
        locale: 'fr',
      );

      final json = originalRequest.toJson();
      final jsonString = jsonEncode(json);
      final decodedJson = jsonDecode(jsonString) as Map<String, dynamic>;
      final deserializedRequest = VersionCheckRequest.fromJson(decodedJson);

      expect(deserializedRequest.platform, originalRequest.platform);
      expect(
          deserializedRequest.currentVersion, originalRequest.currentVersion);
      expect(deserializedRequest.buildNumber, originalRequest.buildNumber);
      expect(deserializedRequest.locale, originalRequest.locale);
    });

    test('should support equality comparison', () {
      const request1 = VersionCheckRequest(
        platform: 'ios',
        currentVersion: '1.0.0',
        buildNumber: '123',
        locale: 'en',
      );

      const request2 = VersionCheckRequest(
        platform: 'ios',
        currentVersion: '1.0.0',
        buildNumber: '123',
        locale: 'en',
      );

      const request3 = VersionCheckRequest(
        platform: 'android',
        currentVersion: '1.0.0',
        buildNumber: '123',
        locale: 'en',
      );

      expect(request1, equals(request2));
      expect(request1, isNot(equals(request3)));
    });

    test('should have consistent hashCode', () {
      const request1 = VersionCheckRequest(
        platform: 'ios',
        currentVersion: '1.0.0',
        buildNumber: '123',
        locale: 'en',
      );

      const request2 = VersionCheckRequest(
        platform: 'ios',
        currentVersion: '1.0.0',
        buildNumber: '123',
        locale: 'en',
      );

      expect(request1.hashCode, equals(request2.hashCode));
    });

    test('should have meaningful toString', () {
      const request = VersionCheckRequest(
        platform: 'ios',
        currentVersion: '1.0.0',
        buildNumber: '123',
        locale: 'en',
      );

      final string = request.toString();
      expect(string, contains('VersionCheckRequest'));
      expect(string, contains('ios'));
      expect(string, contains('1.0.0'));
      expect(string, contains('123'));
      expect(string, contains('en'));
    });
  });
}
