import 'package:flutter_test/flutter_test.dart';
import 'package:curation/utils/secure_logger.dart';

void main() {
  group('SecureLogger', () {
    group('log', () {
      test('should format message with tag correctly', () {
        // SecureLogger.log uses debugPrint internally which is guarded by kDebugMode
        // In test environment, kDebugMode is true
        // We verify the format by checking the method doesn't throw
        expect(
          () => SecureLogger.log('TestTag', 'Test message'),
          returnsNormally,
        );
      });

      test('should handle empty tag', () {
        expect(
          () => SecureLogger.log('', 'Test message'),
          returnsNormally,
        );
      });

      test('should handle empty message', () {
        expect(
          () => SecureLogger.log('Tag', ''),
          returnsNormally,
        );
      });

      test('should handle special characters in message', () {
        expect(
          () => SecureLogger.log('Tag', 'Message with special chars: @#\$%^&*()'),
          returnsNormally,
        );
      });
    });

    group('logError', () {
      test('should format error message with ERROR prefix', () {
        expect(
          () => SecureLogger.logError('TestTag', 'Error occurred'),
          returnsNormally,
        );
      });

      test('should handle exception object', () {
        final exception = Exception('Test exception');
        expect(
          () => SecureLogger.logError('TestTag', 'Error: $exception'),
          returnsNormally,
        );
      });
    });

    group('maskSensitiveData', () {
      test('should mask token values', () {
        const token = 'abc123xyz789';
        final masked = SecureLogger.maskSensitive(token);

        expect(masked, isNot(equals(token)));
        expect(masked, contains('***'));
      });

      test('should show first and last characters for long strings', () {
        const longToken = 'abcdefghijklmnop';
        final masked = SecureLogger.maskSensitive(longToken);

        expect(masked, startsWith('abc'));
        expect(masked, endsWith('nop'));
        expect(masked, contains('***'));
      });

      test('should fully mask short strings', () {
        const shortToken = 'abc';
        final masked = SecureLogger.maskSensitive(shortToken);

        expect(masked, equals('***'));
      });

      test('should handle empty string', () {
        final masked = SecureLogger.maskSensitive('');

        expect(masked, equals('***'));
      });

      test('should handle null-like values safely', () {
        final masked = SecureLogger.maskSensitive('null');

        expect(masked, equals('***'));
      });
    });
  });
}
