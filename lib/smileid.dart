import 'messages.g.dart';
import 'smileid_platform_interface.dart';

class Smileid {
  Future<String?> getPlatformVersion() {
    return SmileidPlatform.instance.getPlatformVersion();
  }

  Future<void> initialize() {
    return SmileidPlatform.instance.initialize();
  }

  Future<FlutterEnhancedKycAsyncResponse?> doEnhancedKycAsync(
      FlutterEnhancedKycRequest request) {
    return SmileidPlatform.instance.doEnhancedKycAsync(request);
  }
}
