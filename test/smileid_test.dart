import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:smileid_flutter/messages.g.dart';
import 'package:smileid_flutter/smileid.dart';
import 'package:smileid_flutter/smileid_method_channel.dart';
import 'package:smileid_flutter/smileid_platform_interface.dart';

class MockSmileidPlatform
    with MockPlatformInterfaceMixin
    implements SmileidPlatform {
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
  final SmileidPlatform initialPlatform = SmileidPlatform.instance;

  test('$SmileidUsage is the default instance', () {
    expect(initialPlatform, isInstanceOf<SmileidUsage>());
  });

  test('getPlatformVersion', () async {
    Smileid smileidPlugin = Smileid();
    MockSmileidPlatform fakePlatform = MockSmileidPlatform();
    SmileidPlatform.instance = fakePlatform;

    expect(await smileidPlugin.getPlatformVersion(), '42');
  });
}
