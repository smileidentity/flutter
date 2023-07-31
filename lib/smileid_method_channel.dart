import 'package:flutter/foundation.dart';
import 'package:smileid_flutter/messages.g.dart';
import 'package:smileid_flutter/smileid_platform_interface.dart';

/// An implementation of [SmileidPlatform]
class SmileidUsage extends SmileidPlatform {
  @visibleForTesting
  final SmileIdApi _api = SmileIdApi();

  @override
  Future<String?> getPlatformVersion() {
    return _api.getPlatformVersion();
  }

  @override
  Future<void> initialize() {
    return _api.initialize();
  }

  @override
  Future<FlutterEnhancedKycAsyncResponse?> doEnhancedKycAsync(
      FlutterEnhancedKycRequest request) async {
    return _api.doEnhancedKycAsync(request);
  }
}
