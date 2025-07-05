/// Response model for version checking API
class VersionCheckResponse {
  /// Whether the request was successful
  final bool success;

  /// Current version that was checked
  final String currentVersion;

  /// Platform that was checked
  final String platform;

  /// Human-readable platform label
  final String? platformLabel;

  /// Whether an update is available
  final bool updateAvailable;

  /// Latest available version
  final String? latestVersion;

  /// Whether the update is forced/mandatory
  final bool forceUpdate;

  /// Whether this is a beta version
  final bool? isBeta;

  /// Download URL for the update
  final String? downloadUrl;

  /// Release date of the latest version
  final DateTime? releaseDate;

  /// Release notes (can be String or Map<String, String> depending on locale)
  final dynamic releaseNotes;

  /// Additional metadata
  final Map<String, dynamic>? metadata;

  /// When the check was performed
  final DateTime? checkedAt;

  /// Message for no update scenarios
  final String? message;

  /// Error message if success is false
  final String? error;

  const VersionCheckResponse({
    required this.success,
    required this.currentVersion,
    required this.platform,
    this.platformLabel,
    required this.updateAvailable,
    this.latestVersion,
    required this.forceUpdate,
    this.isBeta,
    this.downloadUrl,
    this.releaseDate,
    this.releaseNotes,
    this.metadata,
    this.checkedAt,
    this.message,
    this.error,
  });

  /// Create a VersionCheckResponse from JSON
  factory VersionCheckResponse.fromJson(Map<String, dynamic> json) {
    return VersionCheckResponse(
      success: json['success'] as bool? ?? false,
      currentVersion: json['current_version'] as String? ?? '',
      platform: json['platform'] as String? ?? '',
      platformLabel: json['platform_label'] as String?,
      updateAvailable: json['update_available'] as bool? ?? false,
      latestVersion: json['latest_version'] as String?,
      forceUpdate: json['force_update'] as bool? ?? false,
      isBeta: json['is_beta'] as bool?,
      downloadUrl: json['download_url'] as String?,
      releaseDate: json['release_date'] != null
          ? DateTime.tryParse(json['release_date'] as String)
          : null,
      releaseNotes: json['release_notes'],
      metadata: json['metadata'] as Map<String, dynamic>?,
      checkedAt: json['checked_at'] != null
          ? DateTime.tryParse(json['checked_at'] as String)
          : null,
      message: json['message'] as String?,
      error: json['error'] as String?,
    );
  }

  /// Convert VersionCheckResponse to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'success': success,
      'current_version': currentVersion,
      'platform': platform,
      'update_available': updateAvailable,
      'force_update': forceUpdate,
    };

    if (platformLabel != null) data['platform_label'] = platformLabel;
    if (latestVersion != null) data['latest_version'] = latestVersion;
    if (isBeta != null) data['is_beta'] = isBeta;
    if (downloadUrl != null) data['download_url'] = downloadUrl;
    if (releaseDate != null)
      data['release_date'] = releaseDate!.toIso8601String();
    if (releaseNotes != null) data['release_notes'] = releaseNotes;
    if (metadata != null) data['metadata'] = metadata;
    if (checkedAt != null) data['checked_at'] = checkedAt!.toIso8601String();
    if (message != null) data['message'] = message;
    if (error != null) data['error'] = error;

    return data;
  }

  /// Get localized release notes
  String? getLocalizedReleaseNotes([String? preferredLocale]) {
    if (releaseNotes == null) return null;

    if (releaseNotes is String) {
      return releaseNotes as String;
    }

    if (releaseNotes is Map<String, dynamic>) {
      final notesMap = releaseNotes as Map<String, dynamic>;

      // If preferred locale is specified, only return it if it exists
      if (preferredLocale != null) {
        return notesMap.containsKey(preferredLocale)
            ? notesMap[preferredLocale] as String?
            : null;
      }

      // If no preferred locale, try common locales
      for (final locale in ['en', 'ar', 'fr', 'es']) {
        if (notesMap.containsKey(locale)) {
          return notesMap[locale] as String?;
        }
      }

      // Return first available as last resort
      if (notesMap.isNotEmpty) {
        return notesMap.values.first as String?;
      }
    }

    return null;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! VersionCheckResponse) return false;

    return success == other.success &&
        currentVersion == other.currentVersion &&
        platform == other.platform &&
        platformLabel == other.platformLabel &&
        updateAvailable == other.updateAvailable &&
        latestVersion == other.latestVersion &&
        forceUpdate == other.forceUpdate &&
        isBeta == other.isBeta &&
        downloadUrl == other.downloadUrl &&
        releaseDate == other.releaseDate &&
        releaseNotes == other.releaseNotes &&
        metadata == other.metadata &&
        checkedAt == other.checkedAt &&
        message == other.message &&
        error == other.error;
  }

  @override
  int get hashCode {
    return Object.hash(
      success,
      currentVersion,
      platform,
      platformLabel,
      updateAvailable,
      latestVersion,
      forceUpdate,
      isBeta,
      downloadUrl,
      releaseDate,
      releaseNotes,
      metadata,
      checkedAt,
      message,
      error,
    );
  }

  @override
  String toString() {
    return 'VersionCheckResponse(success: $success, updateAvailable: $updateAvailable, currentVersion: $currentVersion, platform: $platform, latestVersion: $latestVersion, forceUpdate: $forceUpdate)';
  }
}
