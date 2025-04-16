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

class SmileIDSmartSelfieCaptureView extends StatefulWidget {
  static const String viewType = "SmileIDSmartSelfieCaptureView";
  final Map<String, dynamic> creationParams;

  /// Called when the user successfully completes the smart selfie enrollment flow. The result is sealed class
  /// that is either a SmileIDSdkResultSuccess<SmartSelfieCaptureResult> or a SmileIDSdkResultError
  final Function(SmileIDSdkResult<SmartSelfieCaptureResult>) onResult;

  const SmileIDSmartSelfieCaptureView._({
    required this.creationParams,
    required this.onResult,
  });

  factory SmileIDSmartSelfieCaptureView({
    Key? key,
    bool showConfirmationDialog = true,
    bool showInstructions = true,
    bool showAttribution = true,
    bool allowAgentMode = true,
    bool useStrictMode = false,
    required Function(SmileIDSdkResult<SmartSelfieCaptureResult>) onResult,
  }) {
    return SmileIDSmartSelfieCaptureView._(
      onResult: onResult,
      creationParams: {
        "showConfirmationDialog": showConfirmationDialog,
        "showInstructions": showInstructions,
        "showAttribution": showAttribution,
        "allowAgentMode": allowAgentMode,
        "useStrictMode": useStrictMode,
      },
    );
  }

  @override
  State<SmileIDSmartSelfieCaptureView> createState() =>
      _SmileIDSmartSelfieCaptureViewState();
}

class _SmileIDSmartSelfieCaptureViewState
    extends State<SmileIDSmartSelfieCaptureView>
    implements SmartSelfieCaptureResultClient {
  late SmileIDProductViewsResultApi api;

  @override
  void initState() {
    super.initState();
    api = SmartSelfieCaptureAdapter(this);
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
        return SafeArea(
          child: PlatformViewLink(
          viewType: SmileIDSmartSelfieCaptureView.viewType,
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
              viewType: SmileIDSmartSelfieCaptureView.viewType,
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
          ),
        );
      case TargetPlatform.iOS:
        return UiKitView(
          viewType: SmileIDSmartSelfieCaptureView.viewType,
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
