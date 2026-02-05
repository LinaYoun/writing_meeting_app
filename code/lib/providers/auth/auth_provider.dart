import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/auth/auth_state.dart';
import '../../services/auth/naver_login_service.dart';
import '../../services/auth/naver_login_service_impl.dart';
import '../../services/auth/secure_token_repository.dart';
import '../../utils/secure_logger.dart';

// Service providers for dependency injection (can be overridden in tests)
final naverLoginServiceProvider = Provider<NaverLoginService>((ref) {
  return NaverLoginServiceImpl();
});

final secureTokenRepositoryProvider = Provider<SecureTokenRepository>((ref) {
  return SecureTokenRepository();
});

class AuthNotifier extends Notifier<AuthState> {
  late final NaverLoginService _loginService;
  late final SecureTokenRepository _tokenRepository;
  bool _isLoginInProgress = false;

  @override
  AuthState build() {
    _loginService = ref.watch(naverLoginServiceProvider);
    _tokenRepository = ref.watch(secureTokenRepositoryProvider);
    return AuthState.initial();
  }

  Future<void> login() async {
    // Prevent concurrent login attempts
    if (_isLoginInProgress) {
      SecureLogger.log('AuthNotifier', 'Login already in progress, ignoring');
      return;
    }

    _isLoginInProgress = true;
    state = AuthState.loading();

    try {
      // Clear any stale tokens before new login attempt
      await _tokenRepository.deleteTokens();

      final result = await _loginService.login();

      if (result.isSuccess) {
        await _tokenRepository.saveTokens(result.tokens!);
        state = AuthState.authenticated(result.user!);
      } else if (result.isCanceled) {
        state = AuthState.unauthenticated();
      } else {
        state = AuthState.error(result.errorMessage ?? '로그인에 실패했습니다.');
      }
    } finally {
      _isLoginInProgress = false;
    }
  }

  Future<void> logout() async {
    await _loginService.logout();
    await _tokenRepository.deleteTokens();
    state = AuthState.unauthenticated();
  }

  Future<void> checkAuthStatus() async {
    state = AuthState.loading();

    final tokens = await _tokenRepository.getTokens();

    if (tokens == null) {
      state = AuthState.unauthenticated();
      return;
    }

    if (tokens.isExpired) {
      final newTokens = await _loginService.refreshToken(tokens.refreshToken);
      if (newTokens == null) {
        await _tokenRepository.deleteTokens();
        state = AuthState.unauthenticated();
        return;
      }
      await _tokenRepository.saveTokens(newTokens);
    }

    final user = await _loginService.getCurrentUser();
    if (user != null) {
      state = AuthState.authenticated(user);
    } else {
      state = AuthState.unauthenticated();
    }
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
