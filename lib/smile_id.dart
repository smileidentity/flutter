import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'messages.g.dart';

class SmileID {
  @visibleForTesting
  static SmileIDApi platformInterface = SmileIDApi();

  static void initialize() {
    platformInterface.initialize();
  }

  static void setEnvironment(bool useSandbox) {
    platformInterface.setEnvironment(useSandbox);
  }

  static void setCallbackUrl(Uri callbackUrl) {
    platformInterface.setCallbackUrl(callbackUrl.toString());
  }

  static Future<FlutterAuthenticationResponse?> authenticate(FlutterAuthenticationRequest request) {
    return platformInterface.authenticate(request);
  }

  static Future<FlutterEnhancedKycAsyncResponse?> doEnhancedKycAsync(
      FlutterEnhancedKycRequest request) {
    return platformInterface.doEnhancedKycAsync(request);
  }

// TODO: move authentication and doEnhancedKycAsync to an "api" object to mirror native API
}
