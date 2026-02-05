import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:curation/models/auth/naver_tokens.dart';
import 'package:curation/services/auth/secure_token_repository.dart';
import '../../mocks/mock_secure_storage.dart';

void main() {
  late MockFlutterSecureStorage mockStorage;
  late SecureTokenRepository repository;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    repository = SecureTokenRepository(storage: mockStorage);
  });

  group('SecureTokenRepository', () {
    group('saveTokens', () {
      test('should save tokens to secure storage', () async {
        final tokens = NaverTokens(
          accessToken: 'access_token_123',
          refreshToken: 'refresh_token_456',
          expiresAt: DateTime(2025, 12, 31),
          tokenType: 'Bearer',
        );

        when(() => mockStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        )).thenAnswer((_) async {});

        await repository.saveTokens(tokens);

        verify(() => mockStorage.write(
          key: SecureTokenRepository.tokensKey,
          value: jsonEncode(tokens.toJson()),
        )).called(1);
      });
    });

    group('getTokens', () {
      test('should return tokens when they exist in storage', () async {
        final tokensJson = {
          'accessToken': 'access_token_123',
          'refreshToken': 'refresh_token_456',
          'expiresAt': '2025-12-31T00:00:00.000',
          'tokenType': 'Bearer',
        };

        when(() => mockStorage.read(key: any(named: 'key')))
            .thenAnswer((_) async => jsonEncode(tokensJson));

        final result = await repository.getTokens();

        expect(result, isNotNull);
        expect(result!.accessToken, 'access_token_123');
        expect(result.refreshToken, 'refresh_token_456');
        expect(result.tokenType, 'Bearer');
        verify(() => mockStorage.read(key: SecureTokenRepository.tokensKey))
            .called(1);
      });

      test('should return null when no tokens exist', () async {
        when(() => mockStorage.read(key: any(named: 'key')))
            .thenAnswer((_) async => null);

        final result = await repository.getTokens();

        expect(result, isNull);
      });

      test('should return null when stored data is invalid JSON', () async {
        when(() => mockStorage.read(key: any(named: 'key')))
            .thenAnswer((_) async => 'invalid json');

        final result = await repository.getTokens();

        expect(result, isNull);
      });
    });

    group('deleteTokens', () {
      test('should delete tokens from secure storage', () async {
        when(() => mockStorage.delete(key: any(named: 'key')))
            .thenAnswer((_) async {});

        await repository.deleteTokens();

        verify(() => mockStorage.delete(key: SecureTokenRepository.tokensKey))
            .called(1);
      });
    });

    group('hasTokens', () {
      test('should return true when tokens exist', () async {
        when(() => mockStorage.containsKey(key: any(named: 'key')))
            .thenAnswer((_) async => true);

        final result = await repository.hasTokens();

        expect(result, true);
      });

      test('should return false when tokens do not exist', () async {
        when(() => mockStorage.containsKey(key: any(named: 'key')))
            .thenAnswer((_) async => false);

        final result = await repository.hasTokens();

        expect(result, false);
      });
    });
  });
}
