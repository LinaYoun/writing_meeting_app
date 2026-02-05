/// SDK 초기화 결과
enum SdkInitResult {
  /// 초기화 성공
  success,

  /// 이미 초기화됨 (중복 초기화 방지)
  alreadyInitialized,

  /// 초기화 실패
  error,
}

/// Naver SDK 설정
///
/// Naver Developer Console에서 발급받은 클라이언트 정보입니다.
/// 보안상 이 값들은 하드코딩하지 않고 환경 변수나 설정 파일에서
/// 가져오는 것을 권장합니다.
class NaverSdkConfig {
  final String clientId;
  final String clientSecret;
  final String clientName;

  const NaverSdkConfig({
    required this.clientId,
    required this.clientSecret,
    required this.clientName,
  });
}

/// Naver SDK 초기화 서비스 추상 인터페이스
///
/// SDK 초기화를 추상화하여 테스트 가능성을 확보하고
/// 의존성 주입 패턴을 적용합니다.
abstract class NaverSdkInitializer {
  /// SDK 초기화 실행
  ///
  /// Returns:
  /// - [SdkInitResult.success] - 초기화 성공
  /// - [SdkInitResult.alreadyInitialized] - 이미 초기화됨
  /// - [SdkInitResult.error] - 초기화 실패 (앱 크래시 없음)
  Future<SdkInitResult> initialize();

  /// 초기화 완료 여부
  bool get isInitialized;
}
