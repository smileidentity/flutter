import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:smile_id_flutter/messages.g.dart';
import 'smile_id_method_channel.dart';

abstract class SmileIDPlatform extends PlatformInterface {
  /// Constructs a SmileIDPlatform.
  SmileIDPlatform() : super(token: _token);

  static final Object _token = Object();

  static SmileIDPlatform _instance = SmileIDUsage();

  /// The default instance of [SmileIDPlatform] to use.
  ///
  /// Defaults to [SmileIDUsage].
  static SmileIDPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SmileIDPlatform] when
  /// they register themselves.
  static set instance(SmileIDPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> initialize() {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  Future<FlutterEnhancedKycAsyncResponse?> doEnhancedKycAsync(
      FlutterEnhancedKycRequest request) async {
    throw UnimplementedError('doEnhancedKycAsync() has not been implemented.');
  }
}
