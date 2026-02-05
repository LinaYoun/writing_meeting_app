import 'package:flutter/foundation.dart';

/// 보안 로깅 유틸리티
///
/// 릴리즈 빌드에서 민감한 정보가 로그에 노출되지 않도록
/// kDebugMode 가드를 적용합니다.
class SecureLogger {
  SecureLogger._();

  /// 디버그 모드에서만 로그를 출력합니다.
  ///
  /// [tag] 로그 태그 (예: 'NaverLogin', 'AuthProvider')
  /// [message] 로그 메시지
  static void log(String tag, String message) {
    if (kDebugMode) {
      debugPrint('[$tag] $message');
    }
  }

  /// 에러 로그를 출력합니다.
  ///
  /// [tag] 로그 태그
  /// [message] 에러 메시지
  static void logError(String tag, String message) {
    if (kDebugMode) {
      debugPrint('[ERROR][$tag] $message');
    }
  }

  /// 민감한 데이터를 마스킹합니다.
  ///
  /// 8자 이상인 경우 앞 3자와 뒤 3자만 보여주고 나머지는 ***로 대체합니다.
  /// 8자 미만인 경우 전체를 ***로 대체합니다.
  ///
  /// [value] 마스킹할 문자열
  /// 반환값: 마스킹된 문자열
  static String maskSensitive(String value) {
    if (value.length < 8) {
      return '***';
    }
    return '${value.substring(0, 3)}***${value.substring(value.length - 3)}';
  }
}
