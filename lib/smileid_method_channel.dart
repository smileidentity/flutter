import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'smileid_platform_interface.dart';

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
}
