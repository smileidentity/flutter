import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'messages.g.dart';
import 'smile_id_service.dart';

class SmileID {
  @visibleForTesting
  static SmileIDApi platformInterface = SmileIDApi();
  static SmileIDService api = SmileIDService(platformInterface);

  static void initialize() {
    platformInterface.initialize();
  }

  static void setEnvironment({required bool useSandbox}) {
    platformInterface.setEnvironment(useSandbox);
  }

  static void setCallbackUrl({required Uri callbackUrl}) {
    platformInterface.setCallbackUrl(callbackUrl.toString());
  }
}
