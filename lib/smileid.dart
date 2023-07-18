
import 'smileid_platform_interface.dart';

class Smileid {

  Future<String?> getPlatformVersion() {
    return SmileidPlatform.instance.getPlatformVersion();
  }
}
