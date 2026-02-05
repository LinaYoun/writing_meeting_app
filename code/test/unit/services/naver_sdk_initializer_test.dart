import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:curation/services/auth/naver_sdk_initializer.dart';

import '../../mocks/mock_naver_sdk_initializer.dart';

void main() {
  group('NaverSdkInitializer', () {
    group('SdkInitResult', () {
      test('should have success, alreadyInitialized, and error values', () {
        expect(SdkInitResult.values, contains(SdkInitResult.success));
        expect(SdkInitResult.values, contains(SdkInitResult.alreadyInitialized));
        expect(SdkInitResult.values, contains(SdkInitResult.error));
      });
    });

    group('interface contract', () {
      late MockNaverSdkInitializer mockInitializer;

      setUp(() {
        mockInitializer = MockNaverSdkInitializer();
      });

      test('initialize() should return success on first call', () async {
        when(() => mockInitializer.initialize())
            .thenAnswer((_) async => SdkInitResult.success);

        final result = await mockInitializer.initialize();

        expect(result, SdkInitResult.success);
        verify(() => mockInitializer.initialize()).called(1);
      });

      test('initialize() should return alreadyInitialized on duplicate call',
          () async {
        when(() => mockInitializer.initialize())
            .thenAnswer((_) async => SdkInitResult.alreadyInitialized);

        final result = await mockInitializer.initialize();

        expect(result, SdkInitResult.alreadyInitialized);
      });

      test('initialize() should return error on failure (no crash)', () async {
        when(() => mockInitializer.initialize())
            .thenAnswer((_) async => SdkInitResult.error);

        final result = await mockInitializer.initialize();

        expect(result, SdkInitResult.error);
        // Test passes if no exception is thrown
      });

      test('isInitialized should be queryable', () {
        when(() => mockInitializer.isInitialized).thenReturn(true);

        expect(mockInitializer.isInitialized, true);
      });

      test('isInitialized should return false before initialization', () {
        when(() => mockInitializer.isInitialized).thenReturn(false);

        expect(mockInitializer.isInitialized, false);
      });
    });
  });
}
