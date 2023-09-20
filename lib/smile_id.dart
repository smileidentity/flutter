import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
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

  // TODO: move authentication and doEnhancedKycAsync to an "api" object to mirror native API
}

class SmileIDDocumentVerification extends StatelessWidget {
  static const String viewType = "SmileIDDocumentVerification";
  final Map<String, dynamic> creationParams;

  /// Called when the user successfully completes the document verification flow. The result is a
  /// JSON string.
  final Function(String) onSuccess;
  final Function(String) onError;

  const SmileIDDocumentVerification._({
    required this.creationParams,
    required this.onSuccess,
    required this.onError,
  });

  factory SmileIDDocumentVerification({
    Key? key,
    required String countryCode,
    String? documentType,
    double? idAspectRatio,
    bool captureBothSides = true,
    String? bypassSelfieCaptureWithFile,
    // userId and jobId can't actually be null in the native SDK but we delegate their creation to
    // the native platform code, since that's where the random ID creation happens
    String? userId,
    String? jobId,
    bool showAttribution = true,
    bool allowGalleryUpload = false,
    bool showInstructions = true,
    required Function(String resultJson) onSuccess,
    required Function(String errorMessage) onError,
  }) {
    return SmileIDDocumentVerification._(
      onSuccess: onSuccess,
      onError: onError,
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
        return PlatformViewLink(
            viewType: viewType,
            surfaceFactory: (context, controller) {
              return AndroidViewSurface(
                controller: controller as AndroidViewController,
                hitTestBehavior: PlatformViewHitTestBehavior.opaque,
                gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{
                  Factory<OneSequenceGestureRecognizer>(EagerGestureRecognizer.new)
                },
              );
            },
            onCreatePlatformView: (params) {
              return PlatformViewsService.initExpensiveAndroidView(
                id: params.id,
                viewType: viewType,
                layoutDirection: Directionality.of(context),
                creationParams: creationParams,
                creationParamsCodec: const StandardMessageCodec(),
                onFocus: () {params.onFocusChanged(true);},
              )
                  ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
                  ..create();
            },
        );
      case TargetPlatform.iOS:
        return UiKitView(
            viewType: viewType,
            creationParams: creationParams,
            creationParamsCodec: const StandardMessageCodec(),
            onPlatformViewCreated: _onPlatformViewCreated,
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
      case "onSuccess":
        onSuccess(call.arguments);
      case "onError":
        onError(call.arguments);
      default:
        throw MissingPluginException();
    }
  }
}
