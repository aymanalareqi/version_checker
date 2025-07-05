import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/version_check_request.dart';
import '../models/version_check_response.dart';
import '../models/version_checker_config.dart';
import '../utils/version_comparator.dart';

/// Service class for handling version checking operations
class VersionCheckerService {
  final VersionCheckerConfig config;
  final http.Client? _httpClient;

  VersionCheckerService(this.config, {http.Client? httpClient})
      : _httpClient = httpClient;

  /// Check for app updates
  Future<VersionCheckResponse> checkForUpdates({
    required String currentVersion,
    required String platform,
    String? buildNumber,
    String? locale,
  }) async {
    try {
      // Check cache first if enabled
      if (config.enableCaching) {
        final cachedResponse = await _getCachedResponse(
          currentVersion,
          platform,
          buildNumber,
          locale,
        );
        if (cachedResponse != null) {
          return cachedResponse;
        }
      }

      // Create request
      final request = VersionCheckRequest(
        platform: platform,
        currentVersion: currentVersion,
        buildNumber: config.includeBuildNumber ? buildNumber : null,
        locale: locale ?? config.locale,
      );

      // Make API call
      final response = await _makeApiCall(request);

      // Cache response if enabled
      if (config.enableCaching && response.success) {
        await _cacheResponse(
            response, currentVersion, platform, buildNumber, locale);
      }

      return response;
    } catch (e) {
      return VersionCheckResponse(
        success: false,
        currentVersion: currentVersion,
        platform: platform,
        updateAvailable: false,
        forceUpdate: false,
        error: e.toString(),
      );
    }
  }

  /// Make HTTP request to version check API
  Future<VersionCheckResponse> _makeApiCall(VersionCheckRequest request) async {
    final uri = Uri.parse(config.apiUrl);
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (config.userAgent != null) 'User-Agent': config.userAgent!,
      ...?config.customHeaders,
    };

    final client = _httpClient ?? http.Client();
    final response = await client
        .post(
          uri,
          headers: headers,
          body: jsonEncode(request.toJson()),
        )
        .timeout(Duration(seconds: config.timeoutSeconds));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      return VersionCheckResponse.fromJson(jsonData);
    } else {
      throw HttpException(
        'API request failed with status ${response.statusCode}: ${response.body}',
      );
    }
  }

  /// Get cached response if available and not expired
  Future<VersionCheckResponse?> _getCachedResponse(
    String currentVersion,
    String platform,
    String? buildNumber,
    String? locale,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey =
          _getCacheKey(currentVersion, platform, buildNumber, locale);

      final cachedData = prefs.getString(cacheKey);
      final cacheTime = prefs.getInt('${cacheKey}_time');

      if (cachedData != null && cacheTime != null) {
        final now = DateTime.now().millisecondsSinceEpoch;
        final cacheAge = now - cacheTime;
        final maxAge =
            config.cacheDurationMinutes * 60 * 1000; // Convert to milliseconds

        if (cacheAge < maxAge) {
          final jsonData = jsonDecode(cachedData) as Map<String, dynamic>;
          return VersionCheckResponse.fromJson(jsonData);
        } else {
          // Remove expired cache
          await prefs.remove(cacheKey);
          await prefs.remove('${cacheKey}_time');
        }
      }
    } catch (e) {
      // Ignore cache errors and proceed with API call
    }

    return null;
  }

  /// Cache response for future use
  Future<void> _cacheResponse(
    VersionCheckResponse response,
    String currentVersion,
    String platform,
    String? buildNumber,
    String? locale,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey =
          _getCacheKey(currentVersion, platform, buildNumber, locale);

      await prefs.setString(cacheKey, jsonEncode(response.toJson()));
      await prefs.setInt(
          '${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      // Ignore cache errors
    }
  }

  /// Generate cache key for the request
  String _getCacheKey(
    String currentVersion,
    String platform,
    String? buildNumber,
    String? locale,
  ) {
    return 'version_check_${platform}_${currentVersion}_${buildNumber ?? ''}_${locale ?? ''}';
  }

  /// Clear all cached responses
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys =
          prefs.getKeys().where((key) => key.startsWith('version_check_'));

      for (final key in keys) {
        await prefs.remove(key);
      }
    } catch (e) {
      // Ignore cache errors
    }
  }

  /// Check if update is available by comparing versions
  bool isUpdateAvailable(String currentVersion, String? latestVersion) {
    if (latestVersion == null) return false;
    return VersionComparator.isUpdateAvailable(currentVersion, latestVersion);
  }
}
