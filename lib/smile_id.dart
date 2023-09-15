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
  final Map<String, dynamic> creationParams;
  final Function(String) onResult;

  const SmileIDDocumentVerification._({required this.creationParams, required this.onResult});

  factory SmileIDDocumentVerification({
    Key? key,
    required String countryCode,
    String? documentType,
    double? idAspectRatio,
    bool captureBothSides = false,
    String? bypassSelfieCaptureWithFile,
    // userId and jobId can't actually be null in the native SDK but we delegate their creation to
    // the native platform code, since that's where the random ID creation happens
    String? userId,
    String? jobId,
    bool showAttribution = true,
    bool allowGalleryUpload = false,
    bool showInstructions = true,
    required Function(String) onResult,
  }) {
    return SmileIDDocumentVerification._(
      onResult: onResult,
      creationParams: {
        "countryCode": countryCode,
        "documentType": documentType,
        "idAspectRatio": idAspectRatio,
        "captureBothSides": captureBothSides,
        "bypassSelfieCaptureWithFile": bypassSelfieCaptureWithFile,
        "userId": userId,
        "jobId": jobId,
        "showAttribution": showAttribution,
        "allowGalleryUpload": allowGalleryUpload,
        "showInstructions": showInstructions,
      },
    );
  }

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
            onPlatformViewCreated: _onPlatformViewCreated,
            creationParams: creationParams,
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
