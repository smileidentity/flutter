import 'messages.g.dart';
import 'smile_id_platform_interface.dart';

class SmileID {
  void initialize() {
    SmileIDPlatform.instance.initialize();
  }

  Future<FlutterAuthenticationResponse?> authenticate(FlutterAuthenticationRequest request) {
    return SmileIDPlatform.instance.authenticate(request);
  }

  Future<FlutterEnhancedKycAsyncResponse?> doEnhancedKycAsync(FlutterEnhancedKycRequest request) {
    return SmileIDPlatform.instance.doEnhancedKycAsync(request);
  }
}
