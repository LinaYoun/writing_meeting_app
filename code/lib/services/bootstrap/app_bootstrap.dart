import 'package:flutter/widgets.dart';

import '../../config/naver_config.dart';
import '../auth/naver_sdk_initializer.dart';
import '../auth/naver_sdk_initializer_impl.dart';

/// 앱 부트스트랩 서비스
///
/// 앱 시작 시 필요한 초기화 작업을 수행합니다.
/// SDK 초기화 실패 시에도 앱이 정상적으로 시작되도록
/// graceful degradation을 적용합니다.
class AppBootstrap {
  final NaverSdkInitializer? _sdkInitializer;
  bool _sdkInitializationFailed = false;

  AppBootstrap({NaverSdkInitializer? sdkInitializer})
      : _sdkInitializer = sdkInitializer ?? _createDefaultInitializer();

  static NaverSdkInitializer? _createDefaultInitializer() {
    final config = NaverConfig.sdkConfig;
    if (config == null) {
      return null;
    }
    return NaverSdkInitializerImpl(config: config);
  }

  /// SDK 초기화 실패 여부
  ///
  /// 이 값이 true인 경우 로그인 기능을 비활성화하거나
  /// 사용자에게 알림을 표시하는 데 사용할 수 있습니다.
  bool get sdkInitializationFailed => _sdkInitializationFailed;

  /// 앱 초기화 수행
  ///
  /// 이 메서드는 절대 예외를 던지지 않습니다.
  /// 모든 초기화 실패는 내부에서 처리되어
  /// 앱이 항상 시작될 수 있도록 보장합니다.
  Future<void> initialize() async {
    // Flutter 바인딩 초기화
    WidgetsFlutterBinding.ensureInitialized();

    // SDK 초기화 (실패해도 앱은 계속 실행)
    if (_sdkInitializer == null) {
      _sdkInitializationFailed = true;
      debugPrint('Naver SDK config not found - login will be unavailable');
      return;
    }

    try {
      final result = await _sdkInitializer.initialize();

      if (result == SdkInitResult.error) {
        _sdkInitializationFailed = true;
        debugPrint('Naver SDK initialization failed - login may be unavailable');
      }
    } catch (e) {
      // 예상치 못한 예외도 안전하게 처리
      _sdkInitializationFailed = true;
      debugPrint('Unexpected error during SDK initialization');
    }
  }
}
