import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:curation/models/auth/auth_state.dart';
import 'package:curation/models/auth/naver_tokens.dart';
import 'package:curation/models/auth/user.dart';
import 'package:curation/providers/auth/auth_provider.dart';
import 'package:curation/services/auth/naver_login_service.dart';
import 'package:curation/services/auth/secure_token_repository.dart';
import '../../mocks/mock_naver_login_service.dart';

class MockSecureTokenRepository extends Mock implements SecureTokenRepository {}

class FakeNaverTokens extends Fake implements NaverTokens {}

void main() {
  late MockNaverLoginService mockLoginService;
  late MockSecureTokenRepository mockTokenRepository;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(FakeNaverTokens());
  });

  setUp(() {
    mockLoginService = MockNaverLoginService();
    mockTokenRepository = MockSecureTokenRepository();
    container = ProviderContainer(
      overrides: [
        naverLoginServiceProvider.overrideWithValue(mockLoginService),
        secureTokenRepositoryProvider.overrideWithValue(mockTokenRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AuthNotifier', () {
    group('initial state', () {
      test('should start with initial state', () {
        final state = container.read(authProvider);
        expect(state.status, AuthStatus.initial);
        expect(state.user, isNull);
      });
    });

    group('login', () {
      test('should update state to loading then authenticated on success',
          () async {
        final tokens = NaverTokens(
          accessToken: 'access_token',
          refreshToken: 'refresh_token',
          expiresAt: DateTime.now().add(const Duration(hours: 1)),
          tokenType: 'Bearer',
        );
        final user = User(
          id: 'user_123',
          name: '홍길동',
          email: 'hong@naver.com',
        );

        when(() => mockTokenRepository.deleteTokens()).thenAnswer((_) async {});
        when(() => mockLoginService.login()).thenAnswer(
            (_) async => AuthLoginResult.success(tokens: tokens, user: user));
        when(() => mockTokenRepository.saveTokens(any()))
            .thenAnswer((_) async {});

        final states = <AuthState>[];
        container.listen(authProvider, (previous, next) {
          states.add(next);
        }, fireImmediately: true);

        await container.read(authProvider.notifier).login();

        expect(states.length, greaterThanOrEqualTo(2));
        expect(states.any((s) => s.status == AuthStatus.loading), true);
        expect(container.read(authProvider).status, AuthStatus.authenticated);
        expect(container.read(authProvider).user, user);
        verify(() => mockTokenRepository.saveTokens(tokens)).called(1);
      });

      test('should update state to unauthenticated on cancel', () async {
        when(() => mockTokenRepository.deleteTokens()).thenAnswer((_) async {});
        when(() => mockLoginService.login())
            .thenAnswer((_) async => AuthLoginResult.canceled());

        await container.read(authProvider.notifier).login();

        expect(container.read(authProvider).status, AuthStatus.unauthenticated);
        verifyNever(() => mockTokenRepository.saveTokens(any()));
      });

      test('should update state to error on failure', () async {
        when(() => mockTokenRepository.deleteTokens()).thenAnswer((_) async {});
        when(() => mockLoginService.login())
            .thenAnswer((_) async => AuthLoginResult.error('로그인 실패'));

        await container.read(authProvider.notifier).login();

        expect(container.read(authProvider).status, AuthStatus.error);
        expect(container.read(authProvider).errorMessage, '로그인 실패');
        verifyNever(() => mockTokenRepository.saveTokens(any()));
      });
    });

    group('logout', () {
      test('should clear user and tokens on logout', () async {
        // First, set up authenticated state
        final tokens = NaverTokens(
          accessToken: 'access_token',
          refreshToken: 'refresh_token',
          expiresAt: DateTime.now().add(const Duration(hours: 1)),
          tokenType: 'Bearer',
        );
        final user = User(
          id: 'user_123',
          name: '홍길동',
          email: 'hong@naver.com',
        );

        when(() => mockTokenRepository.deleteTokens()).thenAnswer((_) async {});
        when(() => mockLoginService.login()).thenAnswer(
            (_) async => AuthLoginResult.success(tokens: tokens, user: user));
        when(() => mockTokenRepository.saveTokens(any()))
            .thenAnswer((_) async {});

        await container.read(authProvider.notifier).login();
        expect(container.read(authProvider).isAuthenticated, true);

        // Now test logout
        when(() => mockLoginService.logout()).thenAnswer((_) async {});

        await container.read(authProvider.notifier).logout();

        expect(container.read(authProvider).status, AuthStatus.unauthenticated);
        expect(container.read(authProvider).user, isNull);
        verify(() => mockLoginService.logout()).called(1);
        // deleteTokens called once during login (clear stale) and once during logout
        verify(() => mockTokenRepository.deleteTokens()).called(2);
      });
    });

    group('checkAuthStatus', () {
      test('should restore authenticated state when valid tokens exist',
          () async {
        final tokens = NaverTokens(
          accessToken: 'access_token',
          refreshToken: 'refresh_token',
          expiresAt: DateTime.now().add(const Duration(hours: 1)),
          tokenType: 'Bearer',
        );
        final user = User(
          id: 'user_123',
          name: '홍길동',
          email: 'hong@naver.com',
        );

        when(() => mockTokenRepository.getTokens())
            .thenAnswer((_) async => tokens);
        when(() => mockLoginService.getCurrentUser())
            .thenAnswer((_) async => user);

        await container.read(authProvider.notifier).checkAuthStatus();

        expect(container.read(authProvider).status, AuthStatus.authenticated);
        expect(container.read(authProvider).user, user);
      });

      test('should set unauthenticated when no tokens exist', () async {
        when(() => mockTokenRepository.getTokens())
            .thenAnswer((_) async => null);

        await container.read(authProvider.notifier).checkAuthStatus();

        expect(container.read(authProvider).status, AuthStatus.unauthenticated);
      });

      test('should refresh token when expired and set authenticated', () async {
        final expiredTokens = NaverTokens(
          accessToken: 'old_access_token',
          refreshToken: 'refresh_token',
          expiresAt: DateTime.now().subtract(const Duration(hours: 1)),
          tokenType: 'Bearer',
        );
        final newTokens = NaverTokens(
          accessToken: 'new_access_token',
          refreshToken: 'new_refresh_token',
          expiresAt: DateTime.now().add(const Duration(hours: 1)),
          tokenType: 'Bearer',
        );
        final user = User(
          id: 'user_123',
          name: '홍길동',
          email: 'hong@naver.com',
        );

        when(() => mockTokenRepository.getTokens())
            .thenAnswer((_) async => expiredTokens);
        when(() => mockLoginService.refreshToken(any()))
            .thenAnswer((_) async => newTokens);
        when(() => mockTokenRepository.saveTokens(any()))
            .thenAnswer((_) async {});
        when(() => mockLoginService.getCurrentUser())
            .thenAnswer((_) async => user);

        await container.read(authProvider.notifier).checkAuthStatus();

        expect(container.read(authProvider).status, AuthStatus.authenticated);
        verify(() => mockLoginService.refreshToken(expiredTokens.refreshToken))
            .called(1);
        verify(() => mockTokenRepository.saveTokens(newTokens)).called(1);
      });

      test('should set unauthenticated when token refresh fails', () async {
        final expiredTokens = NaverTokens(
          accessToken: 'old_access_token',
          refreshToken: 'refresh_token',
          expiresAt: DateTime.now().subtract(const Duration(hours: 1)),
          tokenType: 'Bearer',
        );

        when(() => mockTokenRepository.getTokens())
            .thenAnswer((_) async => expiredTokens);
        when(() => mockLoginService.refreshToken(any()))
            .thenAnswer((_) async => null);
        when(() => mockTokenRepository.deleteTokens()).thenAnswer((_) async {});

        await container.read(authProvider.notifier).checkAuthStatus();

        expect(container.read(authProvider).status, AuthStatus.unauthenticated);
        verify(() => mockTokenRepository.deleteTokens()).called(1);
      });
    });
  });
}
