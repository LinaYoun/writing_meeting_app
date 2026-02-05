import 'package:flutter_test/flutter_test.dart';
import 'package:curation/models/auth/naver_tokens.dart';

void main() {
  group('NaverTokens', () {
    group('construction', () {
      test('should create tokens with all required fields', () {
        final tokens = NaverTokens(
          accessToken: 'access_token_123',
          refreshToken: 'refresh_token_456',
          expiresAt: DateTime(2025, 12, 31, 23, 59, 59),
          tokenType: 'Bearer',
        );

        expect(tokens.accessToken, 'access_token_123');
        expect(tokens.refreshToken, 'refresh_token_456');
        expect(tokens.expiresAt, DateTime(2025, 12, 31, 23, 59, 59));
        expect(tokens.tokenType, 'Bearer');
      });
    });

    group('isExpired', () {
      test('should return true when token is expired', () {
        final tokens = NaverTokens(
          accessToken: 'access_token',
          refreshToken: 'refresh_token',
          expiresAt: DateTime.now().subtract(const Duration(hours: 1)),
          tokenType: 'Bearer',
        );

        expect(tokens.isExpired, true);
      });

      test('should return false when token is not expired', () {
        final tokens = NaverTokens(
          accessToken: 'access_token',
          refreshToken: 'refresh_token',
          expiresAt: DateTime.now().add(const Duration(hours: 1)),
          tokenType: 'Bearer',
        );

        expect(tokens.isExpired, false);
      });

      test('should return true when token expires in less than 5 minutes (buffer)', () {
        final tokens = NaverTokens(
          accessToken: 'access_token',
          refreshToken: 'refresh_token',
          expiresAt: DateTime.now().add(const Duration(minutes: 3)),
          tokenType: 'Bearer',
        );

        expect(tokens.isExpired, true);
      });
    });

    group('JSON serialization', () {
      test('should serialize to JSON correctly', () {
        final expiresAt = DateTime(2025, 12, 31, 23, 59, 59);
        final tokens = NaverTokens(
          accessToken: 'access_token_123',
          refreshToken: 'refresh_token_456',
          expiresAt: expiresAt,
          tokenType: 'Bearer',
        );

        final json = tokens.toJson();

        expect(json['accessToken'], 'access_token_123');
        expect(json['refreshToken'], 'refresh_token_456');
        expect(json['expiresAt'], expiresAt.toIso8601String());
        expect(json['tokenType'], 'Bearer');
      });

      test('should deserialize from JSON correctly', () {
        final json = {
          'accessToken': 'access_token_123',
          'refreshToken': 'refresh_token_456',
          'expiresAt': '2025-12-31T23:59:59.000',
          'tokenType': 'Bearer',
        };

        final tokens = NaverTokens.fromJson(json);

        expect(tokens.accessToken, 'access_token_123');
        expect(tokens.refreshToken, 'refresh_token_456');
        expect(tokens.expiresAt, DateTime(2025, 12, 31, 23, 59, 59));
        expect(tokens.tokenType, 'Bearer');
      });

      test('should round-trip correctly (toJson -> fromJson)', () {
        final original = NaverTokens(
          accessToken: 'access_token_123',
          refreshToken: 'refresh_token_456',
          expiresAt: DateTime(2025, 12, 31, 23, 59, 59),
          tokenType: 'Bearer',
        );

        final json = original.toJson();
        final restored = NaverTokens.fromJson(json);

        expect(restored.accessToken, original.accessToken);
        expect(restored.refreshToken, original.refreshToken);
        expect(restored.expiresAt, original.expiresAt);
        expect(restored.tokenType, original.tokenType);
      });
    });

    group('copyWith', () {
      test('should create a copy with updated accessToken', () {
        final tokens = NaverTokens(
          accessToken: 'old_access_token',
          refreshToken: 'refresh_token',
          expiresAt: DateTime(2025, 12, 31),
          tokenType: 'Bearer',
        );

        final updated = tokens.copyWith(accessToken: 'new_access_token');

        expect(updated.accessToken, 'new_access_token');
        expect(updated.refreshToken, 'refresh_token');
        expect(updated.expiresAt, DateTime(2025, 12, 31));
        expect(updated.tokenType, 'Bearer');
      });

      test('should preserve all fields when no arguments provided', () {
        final tokens = NaverTokens(
          accessToken: 'access_token',
          refreshToken: 'refresh_token',
          expiresAt: DateTime(2025, 12, 31),
          tokenType: 'Bearer',
        );

        final copy = tokens.copyWith();

        expect(copy.accessToken, tokens.accessToken);
        expect(copy.refreshToken, tokens.refreshToken);
        expect(copy.expiresAt, tokens.expiresAt);
        expect(copy.tokenType, tokens.tokenType);
      });
    });
  });
}
