/// Utility class for comparing semantic versions
class VersionComparator {
  /// Compare two version strings using semantic versioning
  /// Returns:
  /// - negative number if version1 < version2
  /// - 0 if version1 == version2
  /// - positive number if version1 > version2
  static int compare(String version1, String version2) {
    final v1Parts = _parseVersion(version1);
    final v2Parts = _parseVersion(version2);

    // Compare major, minor, patch
    for (int i = 0; i < 3; i++) {
      final v1Part = i < v1Parts.length ? v1Parts[i] : 0;
      final v2Part = i < v2Parts.length ? v2Parts[i] : 0;

      if (v1Part != v2Part) {
        return v1Part.compareTo(v2Part);
      }
    }

    return 0;
  }

  /// Check if version1 is greater than version2
  static bool isGreaterThan(String version1, String version2) {
    return compare(version1, version2) > 0;
  }

  /// Check if version1 is less than version2
  static bool isLessThan(String version1, String version2) {
    return compare(version1, version2) < 0;
  }

  /// Check if version1 equals version2
  static bool isEqual(String version1, String version2) {
    return compare(version1, version2) == 0;
  }

  /// Check if version1 is greater than or equal to version2
  static bool isGreaterThanOrEqual(String version1, String version2) {
    return compare(version1, version2) >= 0;
  }

  /// Check if version1 is less than or equal to version2
  static bool isLessThanOrEqual(String version1, String version2) {
    return compare(version1, version2) <= 0;
  }

  /// Check if an update is available (latestVersion > currentVersion)
  static bool isUpdateAvailable(String currentVersion, String latestVersion) {
    return isGreaterThan(latestVersion, currentVersion);
  }

  /// Parse version string into numeric parts
  static List<int> _parseVersion(String version) {
    // Remove 'v' prefix if present
    String cleanVersion =
        version.toLowerCase().startsWith('v') ? version.substring(1) : version;

    // Split by dots and parse each part
    final parts = cleanVersion.split('.');
    final numericParts = <int>[];

    for (final part in parts) {
      // Extract numeric part (ignore pre-release identifiers)
      final numericPart = part.split(RegExp(r'[^0-9]')).first;
      numericParts.add(int.tryParse(numericPart) ?? 0);
    }

    // Ensure we have at least 3 parts (major.minor.patch)
    while (numericParts.length < 3) {
      numericParts.add(0);
    }

    return numericParts;
  }

  /// Validate if a version string is in valid semantic versioning format
  static bool isValidVersion(String version) {
    if (version.isEmpty) return false;

    try {
      // Remove 'v' prefix if present
      String cleanVersion = version.toLowerCase().startsWith('v')
          ? version.substring(1)
          : version;

      // Check for invalid patterns
      if (cleanVersion.isEmpty ||
          cleanVersion.startsWith('.') ||
          cleanVersion.endsWith('.') ||
          cleanVersion.contains('..')) {
        return false;
      }

      // Split by dots and validate each part
      final parts = cleanVersion.split('.');
      if (parts.isEmpty) return false;

      for (final part in parts) {
        // Extract numeric part (ignore pre-release identifiers)
        final numericPart = part.split(RegExp(r'[^0-9]')).first;
        if (numericPart.isEmpty || int.tryParse(numericPart) == null) {
          return false;
        }
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Normalize version string to standard format (major.minor.patch)
  static String normalize(String version) {
    final parts = _parseVersion(version);
    return '${parts[0]}.${parts[1]}.${parts[2]}';
  }
}
