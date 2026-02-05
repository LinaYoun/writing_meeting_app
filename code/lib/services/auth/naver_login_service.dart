import '../../models/auth/user.dart';
import '../../models/auth/naver_tokens.dart';

enum AuthLoginResultStatus {
  success,
  canceled,
  error,
}

class AuthLoginResult {
  final AuthLoginResultStatus status;
  final NaverTokens? tokens;
  final User? user;
  final String? errorMessage;

  const AuthLoginResult._({
    required this.status,
    this.tokens,
    this.user,
    this.errorMessage,
  });

  factory AuthLoginResult.success({
    required NaverTokens tokens,
    required User user,
  }) {
    return AuthLoginResult._(
      status: AuthLoginResultStatus.success,
      tokens: tokens,
      user: user,
    );
  }

  factory AuthLoginResult.canceled() {
    return const AuthLoginResult._(
      status: AuthLoginResultStatus.canceled,
    );
  }

  factory AuthLoginResult.error(String message) {
    return AuthLoginResult._(
      status: AuthLoginResultStatus.error,
      errorMessage: message,
    );
  }

  bool get isSuccess => status == AuthLoginResultStatus.success;
  bool get isCanceled => status == AuthLoginResultStatus.canceled;
  bool get isError => status == AuthLoginResultStatus.error;
}

abstract class NaverLoginService {
  Future<AuthLoginResult> login();
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<NaverTokens?> refreshToken(String refreshToken);
}
