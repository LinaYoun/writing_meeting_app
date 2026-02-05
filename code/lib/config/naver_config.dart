import '../services/auth/naver_sdk_initializer.dart';

/// Naver SDK 설정
///
/// WARNING: 실제 프로덕션 환경에서는 이 값들을 하드코딩하지 마세요.
/// 대신 다음 방법 중 하나를 사용하세요:
/// 1. --dart-define 플래그로 빌드 시 주입
/// 2. .env 파일과 flutter_dotenv 패키지 사용
/// 3. 서버에서 동적으로 가져오기
///
/// 이 파일은 개발/테스트 용도의 기본값만 제공합니다.
class NaverConfig {
  // 빌드 시 주입되는 환경 변수 (--dart-define 사용)
  static const String _clientId = String.fromEnvironment(
    'NAVER_CLIENT_ID',
    defaultValue: '',
  );

  static const String _clientSecret = String.fromEnvironment(
    'NAVER_CLIENT_SECRET',
    defaultValue: '',
  );

  static const String _clientName = String.fromEnvironment(
    'NAVER_CLIENT_NAME',
    defaultValue: 'Curation',
  );

  /// SDK 설정 객체 생성
  ///
  /// clientId나 clientSecret이 비어있으면 null을 반환합니다.
  /// 이는 SDK 초기화를 건너뛰어야 함을 의미합니다.
  static NaverSdkConfig? get sdkConfig {
    if (_clientId.isEmpty || _clientSecret.isEmpty) {
      return null;
    }

    return NaverSdkConfig(
      clientId: _clientId,
      clientSecret: _clientSecret,
      clientName: _clientName,
    );
  }

  /// 설정이 유효한지 확인
  static bool get isConfigured => _clientId.isNotEmpty && _clientSecret.isNotEmpty;
}
