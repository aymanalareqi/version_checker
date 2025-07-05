import 'dialog_config.dart';

/// Configuration for the version checker plugin
class VersionCheckerConfig {
  /// API endpoint URL for version checking
  final String apiUrl;
  
  /// Request timeout in seconds
  final int timeoutSeconds;
  
  /// Whether to cache responses
  final bool enableCaching;
  
  /// Cache duration in minutes
  final int cacheDurationMinutes;
  
  /// Preferred locale for API responses
  final String? locale;
  
  /// Whether to show dialogs automatically
  final bool showDialogs;
  
  /// Configuration for update available dialog
  final DialogConfig updateDialogConfig;
  
  /// Configuration for forced update dialog
  final DialogConfig forceUpdateDialogConfig;
  
  /// Configuration for error dialog
  final DialogConfig errorDialogConfig;
  
  /// Custom headers for API requests
  final Map<String, String>? customHeaders;
  
  /// Whether to include build number in requests
  final bool includeBuildNumber;
  
  /// Custom user agent for requests
  final String? userAgent;

  const VersionCheckerConfig({
    required this.apiUrl,
    this.timeoutSeconds = 30,
    this.enableCaching = true,
    this.cacheDurationMinutes = 5,
    this.locale,
    this.showDialogs = true,
    this.updateDialogConfig = DialogConfig.updateAvailable,
    this.forceUpdateDialogConfig = DialogConfig.forceUpdate,
    this.errorDialogConfig = DialogConfig.error,
    this.customHeaders,
    this.includeBuildNumber = true,
    this.userAgent,
  });

  /// Create a copy with modified fields
  VersionCheckerConfig copyWith({
    String? apiUrl,
    int? timeoutSeconds,
    bool? enableCaching,
    int? cacheDurationMinutes,
    String? locale,
    bool? showDialogs,
    DialogConfig? updateDialogConfig,
    DialogConfig? forceUpdateDialogConfig,
    DialogConfig? errorDialogConfig,
    Map<String, String>? customHeaders,
    bool? includeBuildNumber,
    String? userAgent,
  }) {
    return VersionCheckerConfig(
      apiUrl: apiUrl ?? this.apiUrl,
      timeoutSeconds: timeoutSeconds ?? this.timeoutSeconds,
      enableCaching: enableCaching ?? this.enableCaching,
      cacheDurationMinutes: cacheDurationMinutes ?? this.cacheDurationMinutes,
      locale: locale ?? this.locale,
      showDialogs: showDialogs ?? this.showDialogs,
      updateDialogConfig: updateDialogConfig ?? this.updateDialogConfig,
      forceUpdateDialogConfig: forceUpdateDialogConfig ?? this.forceUpdateDialogConfig,
      errorDialogConfig: errorDialogConfig ?? this.errorDialogConfig,
      customHeaders: customHeaders ?? this.customHeaders,
      includeBuildNumber: includeBuildNumber ?? this.includeBuildNumber,
      userAgent: userAgent ?? this.userAgent,
    );
  }

  /// Default configuration with the test API endpoint
  static const defaultConfig = VersionCheckerConfig(
    apiUrl: 'https://salawati.smart-fingers.com/api/version/check',
    timeoutSeconds: 30,
    enableCaching: true,
    cacheDurationMinutes: 5,
    showDialogs: true,
    includeBuildNumber: true,
  );

  @override
  String toString() {
    return 'VersionCheckerConfig(apiUrl: $apiUrl, timeoutSeconds: $timeoutSeconds, enableCaching: $enableCaching, showDialogs: $showDialogs)';
  }
}
