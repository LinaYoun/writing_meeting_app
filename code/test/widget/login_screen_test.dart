import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:curation/models/auth/user.dart';
import 'package:curation/providers/auth/auth_provider.dart';
import 'package:curation/screens/login_screen.dart';
import 'package:curation/services/auth/naver_login_service.dart';
import 'package:curation/services/auth/secure_token_repository.dart';

class MockNaverLoginService extends Mock implements NaverLoginService {}

class MockSecureTokenRepository extends Mock implements SecureTokenRepository {}

void main() {
  late MockNaverLoginService mockLoginService;
  late MockSecureTokenRepository mockTokenRepository;

  setUp(() {
    mockLoginService = MockNaverLoginService();
    mockTokenRepository = MockSecureTokenRepository();
  });

  Widget createTestWidget({
    void Function(User user)? onLoginSuccess,
  }) {
    return ProviderScope(
      overrides: [
        naverLoginServiceProvider.overrideWithValue(mockLoginService),
        secureTokenRepositoryProvider.overrideWithValue(mockTokenRepository),
      ],
      child: MaterialApp(
        home: LoginScreen(
          onLoginSuccess: onLoginSuccess ?? (_) {},
        ),
      ),
    );
  }

  group('LoginScreen', () {
    testWidgets('should display app logo and login button', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Curation'), findsOneWidget);
      expect(find.text('네이버 로그인'), findsOneWidget);
    });

    testWidgets('should display welcome message', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('에세이의 세계에 오신 것을 환영합니다'), findsOneWidget);
    });

    testWidgets('should show loading when login is in progress',
        (tester) async {
      final completer = Completer<AuthLoginResult>();

      when(() => mockTokenRepository.deleteTokens()).thenAnswer((_) async {});
      when(() => mockLoginService.login())
          .thenAnswer((_) => completer.future);

      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('네이버 로그인'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Complete the login to clean up
      completer.complete(AuthLoginResult.canceled());
      await tester.pumpAndSettle();
    });

    testWidgets('should show error message on login failure', (tester) async {
      when(() => mockTokenRepository.deleteTokens()).thenAnswer((_) async {});
      when(() => mockLoginService.login())
          .thenAnswer((_) async => AuthLoginResult.error('로그인에 실패했습니다'));

      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('네이버 로그인'));
      await tester.pumpAndSettle();

      expect(find.text('로그인에 실패했습니다'), findsOneWidget);
    });
  });
}
