import 'kyc.dart';
import 'smileid_platform_interface.dart';

class Smileid {

  Future<String?> getPlatformVersion() {
    return SmileidPlatform.instance.getPlatformVersion();
  }

  Future<EnhancedKycAsyncResponse> doEnhancedKycAsync(
      EnhancedKycRequest request) {
    return SmileidPlatform.instance.doEnhancedKycAsync(request);
  }
}
