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
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<FlutterEnhancedKycAsyncResponse?> doEnhancedKycAsync(
      FlutterEnhancedKycRequest request) {
    // TODO: implement doEnhancedKycAsync
    throw UnimplementedError();
  }

  @override
  Future<void> initialize() {
    // TODO: implement initialize
    throw UnimplementedError();
  }
}

void main() {
  final SmileIDPlatform initialPlatform = SmileIDPlatform.instance;

  test('$SmileIDUsage is the default instance', () {
    expect(initialPlatform, isInstanceOf<SmileIDUsage>());
  });

  test('getPlatformVersion', () async {
    SmileID smileidPlugin = SmileID();
    MockSmileIDPlatform fakePlatform = MockSmileIDPlatform();
    SmileIDPlatform.instance = fakePlatform;

    expect(await smileidPlugin.getPlatformVersion(), '42');
  });
}
