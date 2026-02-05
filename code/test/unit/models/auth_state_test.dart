import 'package:flutter_test/flutter_test.dart';
import 'package:curation/models/auth/auth_state.dart';
import 'package:curation/models/auth/user.dart';

void main() {
  group('AuthStatus', () {
    test('should have all expected values', () {
      expect(AuthStatus.values, contains(AuthStatus.initial));
      expect(AuthStatus.values, contains(AuthStatus.loading));
      expect(AuthStatus.values, contains(AuthStatus.authenticated));
      expect(AuthStatus.values, contains(AuthStatus.unauthenticated));
      expect(AuthStatus.values, contains(AuthStatus.error));
    });
  });

  group('AuthState', () {
    group('initial factory', () {
      test('should create initial state', () {
        final state = AuthState.initial();

        expect(state.status, AuthStatus.initial);
        expect(state.user, isNull);
        expect(state.errorMessage, isNull);
      });
    });

    group('loading factory', () {
      test('should create loading state', () {
        final state = AuthState.loading();

        expect(state.status, AuthStatus.loading);
        expect(state.user, isNull);
        expect(state.errorMessage, isNull);
      });
    });

    group('authenticated factory', () {
      test('should create authenticated state with user', () {
        final user = User(
          id: 'user_123',
          name: '홍길동',
          email: 'hong@naver.com',
        );
        final state = AuthState.authenticated(user);

        expect(state.status, AuthStatus.authenticated);
        expect(state.user, user);
        expect(state.errorMessage, isNull);
      });
    });

    group('unauthenticated factory', () {
      test('should create unauthenticated state', () {
        final state = AuthState.unauthenticated();

        expect(state.status, AuthStatus.unauthenticated);
        expect(state.user, isNull);
        expect(state.errorMessage, isNull);
      });
    });

    group('error factory', () {
      test('should create error state with message', () {
        final state = AuthState.error('로그인에 실패했습니다.');

        expect(state.status, AuthStatus.error);
        expect(state.user, isNull);
        expect(state.errorMessage, '로그인에 실패했습니다.');
      });
    });

    group('isAuthenticated', () {
      test('should return true when status is authenticated', () {
        final user = User(
          id: 'user_123',
          name: '홍길동',
          email: 'hong@naver.com',
        );
        final state = AuthState.authenticated(user);

        expect(state.isAuthenticated, true);
      });

      test('should return false when status is not authenticated', () {
        expect(AuthState.initial().isAuthenticated, false);
        expect(AuthState.loading().isAuthenticated, false);
        expect(AuthState.unauthenticated().isAuthenticated, false);
        expect(AuthState.error('error').isAuthenticated, false);
      });
    });

    group('isLoading', () {
      test('should return true when status is loading', () {
        final state = AuthState.loading();

        expect(state.isLoading, true);
      });

      test('should return false when status is not loading', () {
        expect(AuthState.initial().isLoading, false);
        expect(AuthState.unauthenticated().isLoading, false);
        expect(AuthState.error('error').isLoading, false);
      });
    });

    group('hasError', () {
      test('should return true when status is error', () {
        final state = AuthState.error('error message');

        expect(state.hasError, true);
      });

      test('should return false when status is not error', () {
        expect(AuthState.initial().hasError, false);
        expect(AuthState.loading().hasError, false);
        expect(AuthState.unauthenticated().hasError, false);
      });
    });

    group('copyWith', () {
      test('should create a copy with updated status', () {
        final user = User(
          id: 'user_123',
          name: '홍길동',
          email: 'hong@naver.com',
        );
        final state = AuthState.authenticated(user);
        final updated = state.copyWith(status: AuthStatus.loading);

        expect(updated.status, AuthStatus.loading);
        expect(updated.user, user);
      });

      test('should preserve all fields when no arguments provided', () {
        final user = User(
          id: 'user_123',
          name: '홍길동',
          email: 'hong@naver.com',
        );
        final state = AuthState(
          status: AuthStatus.authenticated,
          user: user,
          errorMessage: null,
        );
        final copy = state.copyWith();

        expect(copy.status, state.status);
        expect(copy.user, state.user);
        expect(copy.errorMessage, state.errorMessage);
      });
    });
  });
}
