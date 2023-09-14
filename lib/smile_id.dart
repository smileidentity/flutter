import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'messages.g.dart';

class SmileID {
  @visibleForTesting
  static SmileIDApi platformInterface = SmileIDApi();

  static void initialize() {
    platformInterface.initialize();
  }

  static Future<FlutterAuthenticationResponse?> authenticate(FlutterAuthenticationRequest request) {
    return platformInterface.authenticate(request);
  }

  static Future<FlutterEnhancedKycAsyncResponse?> doEnhancedKycAsync(
      FlutterEnhancedKycRequest request) {
    return platformInterface.doEnhancedKycAsync(request);
  }
}

class SmileIDDocumentVerification extends StatelessWidget {
  static const String viewType = "SmileIDDocumentVerification";
  final Function(String) onResult;
  // todo: separate out creation params into independent keys
  final Map<String, dynamic> creationParams;
  const SmileIDDocumentVerification({
    super.key,
    required this.creationParams,
    required this.onResult,
  });


  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return AndroidView(
            viewType: viewType,
            creationParams: creationParams,
            creationParamsCodec: const StandardMessageCodec(),
            onPlatformViewCreated: _onPlatformViewCreated,
            gestureRecognizers: const {
              Factory<OneSequenceGestureRecognizer>(EagerGestureRecognizer.new),
            }
        );
      case TargetPlatform.iOS:
        return UiKitView(
            viewType: viewType,
            onPlatformViewCreated: _onPlatformViewCreated
        );
      default:
        throw UnsupportedError("Unsupported platform");
    }
  }

  void _onPlatformViewCreated(int id) {
    final channel = MethodChannel("${viewType}_$id", const StandardMethodCodec());
    channel.setMethodCallHandler(_handleMethodCall);
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case "onResult":
        onResult(call.arguments);
      default:
        throw MissingPluginException();
    }
  }
}
