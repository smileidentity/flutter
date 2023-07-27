import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'smileid_method_channel.dart';
import 'package:smileid/kyc.dart';

abstract class SmileidPlatform extends PlatformInterface {
  /// Constructs a SmileidPlatform.
  SmileidPlatform() : super(token: _token);

  static final Object _token = Object();

  static SmileidPlatform _instance = MethodChannelSmileid();

  /// The default instance of [SmileidPlatform] to use.
  ///
  /// Defaults to [MethodChannelSmileid].
  static SmileidPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SmileidPlatform] when
  /// they register themselves.
  static set instance(SmileidPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<EnhancedKycAsyncResponse> doEnhancedKycAsync(EnhancedKycRequest request) {
    throw UnimplementedError('doEnhancedKycAsync() has not been implemented.');
  }
}
