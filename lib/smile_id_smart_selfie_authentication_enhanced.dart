import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:smile_id/product_result_adapters.dart';
import 'package:smile_id/result_clients_interfaces.dart';

import 'smile_id_product_views_api.dart';
import 'smile_id_sdk_result.dart';
import 'smileid_messages.g.dart';

class SmileIDSmartSelfieAuthenticationEnhanced extends StatefulWidget {
  static const String viewType = "SmileIDSmartSelfieAuthenticationEnhanced";
  final Map<String, dynamic> creationParams;

  /// Called when the user successfully completes the smart selfie enrollment flow. The result is sealed class
  /// that is either a SmileIDSdkResultSuccess<DocumentCaptureResult> or a SmileIDSdkResultError
  final Function(SmileIDSdkResult<SmartSelfieCaptureResult>) onResult;

  const SmileIDSmartSelfieAuthenticationEnhanced._({
    required this.creationParams,
    required this.onResult,
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
    required Function(SmileIDSdkResult<SmartSelfieCaptureResult>) onResult,
  }) {
    return SmileIDSmartSelfieAuthenticationEnhanced._(
      onResult: onResult,
      creationParams: {
        "userId": userId,
        "allowNewEnroll": allowNewEnroll,
        "showAttribution": showAttribution,
        "showInstructions": showInstructions,
        "skipApiSubmission": skipApiSubmission,
        "extraPartnerParams": extraPartnerParams,
      },
    );
  }

  @override
  State<SmileIDSmartSelfieAuthenticationEnhanced> createState() =>
      _SmileIDSmartSelfieAuthenticationEnhancedState();
}

class _SmileIDSmartSelfieAuthenticationEnhancedState
    extends State<SmileIDSmartSelfieAuthenticationEnhanced>
    implements SmartSelfieCaptureResultClient {
  late SmileIDProductViewsResultApi api;

  @override
  void initState() {
    super.initState();
    api = SmartSelfieAuthenticationEnhancedProductToSelfieCaptureResultAdapter(
        this);
  }

  @override
  void dispose() {
    super.dispose();
    api.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return PlatformViewLink(
          viewType: SmileIDSmartSelfieAuthenticationEnhanced.viewType,
          surfaceFactory: (context, controller) {
            return AndroidViewSurface(
              controller: controller as AndroidViewController,
              hitTestBehavior: PlatformViewHitTestBehavior.opaque,
              gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(
                    EagerGestureRecognizer.new)
              },
            );
          },
          onCreatePlatformView: (params) {
            return PlatformViewsService.initExpensiveAndroidView(
              id: params.id,
              viewType: SmileIDSmartSelfieAuthenticationEnhanced.viewType,
              layoutDirection: Directionality.of(context),
              creationParams: widget.creationParams,
              creationParamsCodec: const StandardMessageCodec(),
              onFocus: () {
                params.onFocusChanged(true);
              },
            )
              ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
              ..create();
          },
        );
      case TargetPlatform.iOS:
        return UiKitView(
          viewType: SmileIDSmartSelfieAuthenticationEnhanced.viewType,
          creationParams: widget.creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        );
      default:
        throw UnsupportedError("Unsupported platform");
    }
  }

  @override
  void onResult(SmileIDSdkResult<SmartSelfieCaptureResult> result) {
    widget.onResult(result);
  }
}
