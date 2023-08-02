import 'messages.g.dart';
import 'smile_id_platform_interface.dart';

class SmileID {

  Future<FlutterAuthenticationResponse?> authenticate(
      FlutterAuthenticationRequest request) {
    return SmileIDPlatform.instance.authenticate(request);
  }

  Future<void> initialize() {
    return SmileIDPlatform.instance.initialize();
  }

  Future<FlutterEnhancedKycAsyncResponse?> doEnhancedKycAsync(
      FlutterEnhancedKycRequest request) {
    return SmileIDPlatform.instance.doEnhancedKycAsync(request);
  }
}
