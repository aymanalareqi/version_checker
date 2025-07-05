import 'package:flutter_test/flutter_test.dart';
import 'package:version_checker/src/utils/version_comparator.dart';

void main() {
  group('VersionComparator', () {
    group('compare', () {
      test('should return 0 for equal versions', () {
        expect(VersionComparator.compare('1.2.3', '1.2.3'), 0);
        expect(VersionComparator.compare('1.0.0', '1.0'), 0);
        expect(VersionComparator.compare('2.1', '2.1.0'), 0);
      });

      test('should return positive for newer first version', () {
        expect(VersionComparator.compare('1.2.4', '1.2.3'), greaterThan(0));
        expect(VersionComparator.compare('1.3.0', '1.2.9'), greaterThan(0));
        expect(VersionComparator.compare('2.0.0', '1.9.9'), greaterThan(0));
      });

      test('should return negative for older first version', () {
        expect(VersionComparator.compare('1.2.3', '1.2.4'), lessThan(0));
        expect(VersionComparator.compare('1.2.9', '1.3.0'), lessThan(0));
        expect(VersionComparator.compare('1.9.9', '2.0.0'), lessThan(0));
      });

      test('should handle versions with different lengths', () {
        expect(VersionComparator.compare('1.2', '1.2.0'), 0);
        expect(VersionComparator.compare('1.2', '1.2.1'), lessThan(0));
        expect(VersionComparator.compare('1.2.1', '1.2'), greaterThan(0));
      });

      test('should ignore build numbers and pre-release tags', () {
        expect(VersionComparator.compare('1.2.3+456', '1.2.3+789'), 0);
        expect(VersionComparator.compare('1.2.3-beta', '1.2.3-alpha'), 0);
        expect(VersionComparator.compare('1.2.3-beta.1+456', '1.2.3'), 0);
      });

      test('should handle v prefix', () {
        expect(VersionComparator.compare('v1.2.3', '1.2.3'), 0);
        expect(VersionComparator.compare('V1.2.3', '1.2.3'), 0);
        expect(VersionComparator.compare('v1.2.4', 'v1.2.3'), greaterThan(0));
      });
    });

    group('isGreaterThan', () {
      test('should return true for newer versions', () {
        expect(VersionComparator.isGreaterThan('1.2.4', '1.2.3'), true);
        expect(VersionComparator.isGreaterThan('2.0.0', '1.9.9'), true);
        expect(VersionComparator.isGreaterThan('1.3.0', '1.2.9'), true);
      });

      test('should return false for equal or older versions', () {
        expect(VersionComparator.isGreaterThan('1.2.3', '1.2.3'), false);
        expect(VersionComparator.isGreaterThan('1.2.3', '1.2.4'), false);
        expect(VersionComparator.isGreaterThan('1.9.9', '2.0.0'), false);
      });
    });

    group('isLessThan', () {
      test('should return true for older versions', () {
        expect(VersionComparator.isLessThan('1.2.3', '1.2.4'), true);
        expect(VersionComparator.isLessThan('1.2.9', '1.3.0'), true);
        expect(VersionComparator.isLessThan('1.9.9', '2.0.0'), true);
      });

      test('should return false for equal or newer versions', () {
        expect(VersionComparator.isLessThan('1.2.3', '1.2.3'), false);
        expect(VersionComparator.isLessThan('1.2.4', '1.2.3'), false);
        expect(VersionComparator.isLessThan('2.0.0', '1.9.9'), false);
      });
    });

    group('isEqual', () {
      test('should return true for equal versions', () {
        expect(VersionComparator.isEqual('1.2.3', '1.2.3'), true);
        expect(VersionComparator.isEqual('1.0.0', '1.0'), true);
        expect(VersionComparator.isEqual('2.1', '2.1.0'), true);
      });

      test('should return false for different versions', () {
        expect(VersionComparator.isEqual('1.2.3', '1.2.4'), false);
        expect(VersionComparator.isEqual('1.2.4', '1.2.3'), false);
        expect(VersionComparator.isEqual('2.0.0', '1.9.9'), false);
      });
    });

    group('isGreaterThanOrEqual', () {
      test('should return true for newer or equal versions', () {
        expect(VersionComparator.isGreaterThanOrEqual('1.2.4', '1.2.3'), true);
        expect(VersionComparator.isGreaterThanOrEqual('1.2.3', '1.2.3'), true);
        expect(VersionComparator.isGreaterThanOrEqual('2.0.0', '1.9.9'), true);
      });

      test('should return false for older versions', () {
        expect(VersionComparator.isGreaterThanOrEqual('1.2.3', '1.2.4'), false);
        expect(VersionComparator.isGreaterThanOrEqual('1.9.9', '2.0.0'), false);
      });
    });

    group('isLessThanOrEqual', () {
      test('should return true for older or equal versions', () {
        expect(VersionComparator.isLessThanOrEqual('1.2.3', '1.2.4'), true);
        expect(VersionComparator.isLessThanOrEqual('1.2.3', '1.2.3'), true);
        expect(VersionComparator.isLessThanOrEqual('1.9.9', '2.0.0'), true);
      });

      test('should return false for newer versions', () {
        expect(VersionComparator.isLessThanOrEqual('1.2.4', '1.2.3'), false);
        expect(VersionComparator.isLessThanOrEqual('2.0.0', '1.9.9'), false);
      });
    });

    group('isUpdateAvailable', () {
      test('should return true when latest version is newer', () {
        expect(VersionComparator.isUpdateAvailable('1.2.3', '1.2.4'), true);
        expect(VersionComparator.isUpdateAvailable('1.9.9', '2.0.0'), true);
        expect(VersionComparator.isUpdateAvailable('1.2.9', '1.3.0'), true);
      });

      test('should return false when versions are equal or current is newer',
          () {
        expect(VersionComparator.isUpdateAvailable('1.2.3', '1.2.3'), false);
        expect(VersionComparator.isUpdateAvailable('1.2.4', '1.2.3'), false);
        expect(VersionComparator.isUpdateAvailable('2.0.0', '1.9.9'), false);
      });
    });

    group('isValidVersion', () {
      test('should return true for valid versions', () {
        expect(VersionComparator.isValidVersion('1.2.3'), true);
        expect(VersionComparator.isValidVersion('1.0.0'), true);
        expect(VersionComparator.isValidVersion('10.20.30'), true);
        expect(VersionComparator.isValidVersion('1.2.3+456'), true);
        expect(VersionComparator.isValidVersion('1.2.3-beta'), true);
        expect(VersionComparator.isValidVersion('1'), true);
        expect(VersionComparator.isValidVersion('1.2'), true);
      });

      test('should return false for invalid versions', () {
        expect(VersionComparator.isValidVersion(''), false);
        expect(VersionComparator.isValidVersion('abc'), false);
        expect(VersionComparator.isValidVersion('1.2.abc'), false);
        expect(VersionComparator.isValidVersion('1..2'), false);
        expect(VersionComparator.isValidVersion('.1.2'), false);
        expect(VersionComparator.isValidVersion('1.2.'), false);
      });
    });

    group('normalize', () {
      test('should normalize versions to standard format', () {
        expect(VersionComparator.normalize('1.2.3'), '1.2.3');
        expect(VersionComparator.normalize('1.2'), '1.2.0');
        expect(VersionComparator.normalize('1'), '1.0.0');
        expect(VersionComparator.normalize('v1.2.3'), '1.2.3');
        expect(VersionComparator.normalize('1.2.3-beta'), '1.2.3');
        expect(VersionComparator.normalize('1.2.3+456'), '1.2.3');
      });
    });
  });
}
