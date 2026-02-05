import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:curation/services/auth/naver_sdk_initializer.dart';
import 'package:curation/services/bootstrap/app_bootstrap.dart';

import '../../mocks/mock_naver_sdk_initializer.dart';

void main() {
  // Ensure Flutter bindings are initialized for tests
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppBootstrap', () {
    late MockNaverSdkInitializer mockSdkInitializer;
    late AppBootstrap bootstrap;

    setUp(() {
      mockSdkInitializer = MockNaverSdkInitializer();
      bootstrap = AppBootstrap(sdkInitializer: mockSdkInitializer);
    });

    group('initialize', () {
      test('should call SDK initializer during bootstrap', () async {
        when(() => mockSdkInitializer.initialize())
            .thenAnswer((_) async => SdkInitResult.success);

        await bootstrap.initialize();

        verify(() => mockSdkInitializer.initialize()).called(1);
      });

      test('should complete successfully even when SDK initialization fails',
          () async {
        when(() => mockSdkInitializer.initialize())
            .thenAnswer((_) async => SdkInitResult.error);

        // Should not throw - graceful degradation
        await expectLater(bootstrap.initialize(), completes);

        verify(() => mockSdkInitializer.initialize()).called(1);
      });

      test('should handle alreadyInitialized result gracefully', () async {
        when(() => mockSdkInitializer.initialize())
            .thenAnswer((_) async => SdkInitResult.alreadyInitialized);

        await expectLater(bootstrap.initialize(), completes);

        verify(() => mockSdkInitializer.initialize()).called(1);
      });

      test('should handle exception from SDK initializer gracefully', () async {
        when(() => mockSdkInitializer.initialize())
            .thenThrow(Exception('Unexpected error'));

        // Should not crash the app
        await expectLater(bootstrap.initialize(), completes);
      });
    });

    group('sdkInitializationFailed', () {
      test('should be false when SDK initializes successfully', () async {
        when(() => mockSdkInitializer.initialize())
            .thenAnswer((_) async => SdkInitResult.success);

        await bootstrap.initialize();

        expect(bootstrap.sdkInitializationFailed, false);
      });

      test('should be true when SDK initialization fails', () async {
        when(() => mockSdkInitializer.initialize())
            .thenAnswer((_) async => SdkInitResult.error);

        await bootstrap.initialize();

        expect(bootstrap.sdkInitializationFailed, true);
      });

      test('should be false when SDK was already initialized', () async {
        when(() => mockSdkInitializer.initialize())
            .thenAnswer((_) async => SdkInitResult.alreadyInitialized);

        await bootstrap.initialize();

        expect(bootstrap.sdkInitializationFailed, false);
      });
    });
  });
}
