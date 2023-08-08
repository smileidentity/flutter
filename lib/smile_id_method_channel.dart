import 'package:flutter/foundation.dart';
import 'package:smile_id_flutter/messages.g.dart';
import 'package:smile_id_flutter/smile_id_platform_interface.dart';

/// An implementation of [SmileIDPlatform]
class SmileIDUsage extends SmileIDPlatform {
  @visibleForTesting
  final SmileIDApi _api = SmileIDApi();

  @override
  void initialize() {
    _api.initialize();
  }

  @override
  Future<FlutterAuthenticationResponse?> authenticate(
      FlutterAuthenticationRequest request) async {
    return _api.authenticate(request);
  }

  @override
  Future<FlutterEnhancedKycAsyncResponse?> doEnhancedKycAsync(
      FlutterEnhancedKycRequest request) async {
    return _api.doEnhancedKycAsync(request);
  }
}
