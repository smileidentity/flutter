import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:smile_id_flutter/messages.g.dart';
import 'package:smile_id_flutter/smile_id.dart';
import 'package:smile_id_flutter/smile_id_method_channel.dart';
import 'package:smile_id_flutter/smile_id_platform_interface.dart';

class MockSmileIDPlatform
    with MockPlatformInterfaceMixin
    implements SmileIDPlatform {
  @override
  void initialize() {
    // TODO: implement initialize
    throw UnimplementedError();
  }

  @override
  Future<FlutterEnhancedKycAsyncResponse?> doEnhancedKycAsync(
      FlutterEnhancedKycRequest request) {
    // TODO: implement doEnhancedKycAsync
    throw UnimplementedError();
  }

  @override
  Future<FlutterAuthenticationResponse?> authenticate(FlutterAuthenticationRequest request) {
    // TODO: implement authenticate
    throw UnimplementedError();
  }
}

void main() {
  final SmileIDPlatform initialPlatform = SmileIDPlatform.instance;

  test('$SmileIDUsage is the default instance', () {
    expect(initialPlatform, isInstanceOf<SmileIDUsage>());
  });
}
