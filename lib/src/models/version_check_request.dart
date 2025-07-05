/// Request model for version checking API
class VersionCheckRequest {
  /// Platform identifier: "ios" or "android"
  final String platform;
  
  /// Current app version (semantic versioning)
  final String currentVersion;
  
  /// Build number for additional version tracking (optional)
  final String? buildNumber;
  
  /// Preferred locale for localized content (optional)
  final String? locale;

  const VersionCheckRequest({
    required this.platform,
    required this.currentVersion,
    this.buildNumber,
    this.locale,
  });

  /// Create a VersionCheckRequest from JSON
  factory VersionCheckRequest.fromJson(Map<String, dynamic> json) {
    return VersionCheckRequest(
      platform: json['platform'] as String,
      currentVersion: json['current_version'] as String,
      buildNumber: json['build_number'] as String?,
      locale: json['locale'] as String?,
    );
  }

  /// Convert VersionCheckRequest to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'platform': platform,
      'current_version': currentVersion,
    };
    
    if (buildNumber != null) {
      data['build_number'] = buildNumber;
    }
    
    if (locale != null) {
      data['locale'] = locale;
    }
    
    return data;
  }

  /// Create a copy with modified fields
  VersionCheckRequest copyWith({
    String? platform,
    String? currentVersion,
    String? buildNumber,
    String? locale,
  }) {
    return VersionCheckRequest(
      platform: platform ?? this.platform,
      currentVersion: currentVersion ?? this.currentVersion,
      buildNumber: buildNumber ?? this.buildNumber,
      locale: locale ?? this.locale,
    );
  }

  @override
  String toString() {
    return 'VersionCheckRequest(platform: $platform, currentVersion: $currentVersion, buildNumber: $buildNumber, locale: $locale)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VersionCheckRequest &&
        other.platform == platform &&
        other.currentVersion == currentVersion &&
        other.buildNumber == buildNumber &&
        other.locale == locale;
  }

  @override
  int get hashCode {
    return platform.hashCode ^
        currentVersion.hashCode ^
        buildNumber.hashCode ^
        locale.hashCode;
  }
}
