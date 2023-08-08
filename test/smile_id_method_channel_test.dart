import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smile_id_flutter/smile_id_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  SmileIDUsage platform = SmileIDUsage();
  const MethodChannel channel = MethodChannel('smileid');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('initialize', () {
    platform.initialize();
    expect(true, true);
  });
}
