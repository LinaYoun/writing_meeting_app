import 'package:flutter/foundation.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_naver_login/interface/types/naver_login_status.dart';

import '../../models/auth/naver_tokens.dart';
import '../../models/auth/user.dart';
import 'naver_login_service.dart';

class NaverLoginServiceImpl implements NaverLoginService {
  @override
  Future<AuthLoginResult> login() async {
    try {
      debugPrint('[NaverLogin] Starting login...');

      final result = await FlutterNaverLogin.logIn();
      debugPrint('[NaverLogin] Login result status: ${result.status}');

      if (result.status == NaverLoginStatus.loggedIn) {
        debugPrint('[NaverLogin] Login successful, fetching tokens...');
        final account = result.account;
        // In v2.1.1, accessToken is included in the login result
        final tokenResult =
            result.accessToken ?? await FlutterNaverLogin.getCurrentAccessToken();

        final tokens = NaverTokens(
          accessToken: tokenResult.accessToken,
          refreshToken: tokenResult.refreshToken,
          expiresAt: _parseExpiresAt(tokenResult.expiresAt),
          tokenType: tokenResult.tokenType,
        );

        final user = User(
          id: account?.id ?? '',
          name: (account?.name?.isNotEmpty ?? false)
              ? account!.name!
              : (account?.nickname ?? ''),
          email: account?.email ?? '',
          profileImageUrl: (account?.profileImage?.isNotEmpty ?? false)
              ? account!.profileImage
              : null,
        );

        debugPrint('[NaverLogin] User authenticated: ${user.name}');
        return AuthLoginResult.success(tokens: tokens, user: user);
      } else if (result.status == NaverLoginStatus.loggedOut) {
        // User cancelled or logged out
        debugPrint('[NaverLogin] Login cancelled by user');
        return AuthLoginResult.canceled();
      } else {
        debugPrint('[NaverLogin] Login failed: ${result.errorMessage}');
        return AuthLoginResult.error(
          (result.errorMessage?.isNotEmpty ?? false)
              ? result.errorMessage!
              : '로그인에 실패했습니다.',
        );
      }
    } catch (e) {
      debugPrint('[NaverLogin] Login error: $e');
      return AuthLoginResult.error('로그인 중 오류가 발생했습니다: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await FlutterNaverLogin.logOut();
    } catch (e) {
      // Silently ignore logout errors
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final account = await FlutterNaverLogin.getCurrentAccount();
      if (account.id?.isEmpty ?? true) return null;

      return User(
        id: account.id ?? '',
        name: (account.name?.isNotEmpty ?? false)
            ? account.name!
            : (account.nickname ?? ''),
        email: account.email ?? '',
        profileImageUrl: (account.profileImage?.isNotEmpty ?? false)
            ? account.profileImage
            : null,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<NaverTokens?> refreshToken(String refreshToken) async {
    try {
      final tokenResult =
          await FlutterNaverLogin.refreshAccessTokenWithRefreshToken();

      if (tokenResult.isValid()) {
        return NaverTokens(
          accessToken: tokenResult.accessToken,
          refreshToken: tokenResult.refreshToken,
          expiresAt: _parseExpiresAt(tokenResult.expiresAt),
          tokenType: tokenResult.tokenType,
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  DateTime _parseExpiresAt(String expiresAt) {
    // In v2.1.1, expiresAt may be ISO 8601 format or Unix timestamp
    try {
      // Try ISO 8601 format first
      final parsed = DateTime.tryParse(expiresAt);
      if (parsed != null) return parsed;

      // Fallback: try Unix timestamp in seconds
      final timestamp = int.tryParse(expiresAt);
      if (timestamp != null) {
        return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      }

      // Fallback: 1 hour from now
      return DateTime.now().add(const Duration(hours: 1));
    } catch (e) {
      // Fallback: 1 hour from now
      return DateTime.now().add(const Duration(hours: 1));
    }
  }
}
