import 'package:flutter_test/flutter_test.dart';
import 'package:smileid/smileid.dart';
import 'package:smileid/smileid_platform_interface.dart';
import 'package:smileid/smileid_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSmileidPlatform
    with MockPlatformInterfaceMixin
    implements SmileidPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SmileidPlatform initialPlatform = SmileidPlatform.instance;

  test('$MethodChannelSmileid is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSmileid>());
  });

  test('getPlatformVersion', () async {
    Smileid smileidPlugin = Smileid();
    MockSmileidPlatform fakePlatform = MockSmileidPlatform();
    SmileidPlatform.instance = fakePlatform;

    expect(await smileidPlugin.getPlatformVersion(), '42');
  });
}
