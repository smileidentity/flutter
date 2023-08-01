import 'messages.g.dart';
import 'smile_id_platform_interface.dart';

class SmileID {
  Future<String?> getPlatformVersion() {
    return SmileIDPlatform.instance.getPlatformVersion();
  }

  Future<void> initialize() {
    return SmileIDPlatform.instance.initialize();
  }

  Future<FlutterEnhancedKycAsyncResponse?> doEnhancedKycAsync(
      FlutterEnhancedKycRequest request) {
    return SmileIDPlatform.instance.doEnhancedKycAsync(request);
  }
}
