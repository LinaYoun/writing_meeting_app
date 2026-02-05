import 'package:flutter/foundation.dart';

import 'naver_sdk_initializer.dart';

/// Naver SDK 초기화 서비스 구현체
///
/// flutter_naver_login v2.1.1에서는 SDK 초기화가 자동으로 처리됩니다.
/// 이 클래스는 기존 인터페이스와의 호환성을 유지하면서
/// 초기화 상태를 관리합니다.
class NaverSdkInitializerImpl implements NaverSdkInitializer {
  final NaverSdkConfig _config;
  bool _isInitialized = false;

  NaverSdkInitializerImpl({required NaverSdkConfig config}) : _config = config;

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<SdkInitResult> initialize() async {
    // 중복 초기화 방지
    if (_isInitialized) {
      return SdkInitResult.alreadyInitialized;
    }

    try {
      // flutter_naver_login v2.1.1에서는 SDK 초기화가 자동으로 처리됩니다.
      // 네이티브 SDK 설정은 Android의 AndroidManifest.xml과
      // iOS의 Info.plist에서 처리됩니다.
      //
      // 필요한 설정:
      // Android: AndroidManifest.xml에 client_id, client_secret, client_name 메타데이터
      // iOS: Info.plist에 NidConsumerKey, NidConsumerSecret, NidServiceName
      debugPrint('[NaverSDK] auto-initialized (v2.1.1)');
      debugPrint('[NaverSDK] clientId length: ${_config.clientId.length}');
      debugPrint('[NaverSDK] clientSecret length: ${_config.clientSecret.length}');
      debugPrint('[NaverSDK] clientName: ${_config.clientName}');
      _isInitialized = true;
      return SdkInitResult.success;
    } catch (e) {
      debugPrint('Naver SDK initialization check failed');
      return SdkInitResult.error;
    }
  }
}
