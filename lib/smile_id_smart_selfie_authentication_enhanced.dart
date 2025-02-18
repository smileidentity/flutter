import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

@Deprecated(
  'Due to the expensive nature of platform views, migrate to the more efficient smartSelfieAuthenticationEnhanced function in the SmileID sdk. This widget will be removed in future versions',
)
class SmileIDSmartSelfieAuthenticationEnhanced extends StatelessWidget {
  static const String viewType = "SmileIDSmartSelfieAuthenticationEnhanced";
  final Map<String, dynamic> creationParams;

  /// Called when the user successfully completes the smart selfie enrollment flow. The result is a
  /// JSON string.
  final Function(String) onSuccess;
  final Function(String) onError;

  const SmileIDSmartSelfieAuthenticationEnhanced._({
    required this.creationParams,
    required this.onSuccess,
    required this.onError,
  });

  factory SmileIDSmartSelfieAuthenticationEnhanced({
    Key? key,
    // userId can't actually be null in the native SDK but we delegate their creation to
    // the native platform code, since that's where the random ID creation happens
    String? userId,
    bool allowNewEnroll = false,
    bool showAttribution = true,
    bool showInstructions = true,
    bool skipApiSubmission = false,
    Map<String, String>? extraPartnerParams,
    required Function(String resultJson) onSuccess,
    required Function(String errorMessage) onError,
  }) {
    return SmileIDSmartSelfieAuthenticationEnhanced._(
      onSuccess: onSuccess,
      onError: onError,
      creationParams: {
        "userId": userId,
        "allowNewEnroll": allowNewEnroll,
        "showAttribution": showAttribution,
        "showInstructions": showInstructions,
        "skipApiSubmission" : skipApiSubmission,
        "extraPartnerParams" : extraPartnerParams,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return SafeArea(
          child: PlatformViewLink(
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
              onFocus: () {
                params.onFocusChanged(true);
              },
            )
              ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
              ..addOnPlatformViewCreatedListener(_onPlatformViewCreated)
              ..create();
            },
          ),
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
    final channel = MethodChannel("${viewType}_$id");
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
