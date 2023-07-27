import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:smileid/smileid_platform_interface.dart';

import 'kyc.dart';

/// An implementation of [SmileidPlatform] that uses method channels.
class MethodChannelSmileid extends SmileidPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('smileid');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<EnhancedKycAsyncResponse> doEnhancedKycAsync(EnhancedKycRequest request) async {
    final response = await methodChannel.invokeMethod('doEnhancedKycAsync', request);
    return response;
  }
}
