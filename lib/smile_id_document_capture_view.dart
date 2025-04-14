import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:smile_id/product_result_adapters.dart';
import 'package:smile_id/result_clients_interfaces.dart';
import 'package:smile_id/smileid_messages.g.dart';

import 'smile_id_product_views_api.dart';
import 'smile_id_sdk_result.dart';

class SmileIDDocumentCaptureView extends StatefulWidget {
  static const String viewType = "SmileIDDocumentCaptureView";
  final Map<String, dynamic> creationParams;

  /// Called when the user successfully completes the smart selfie enrollment flow. The result is sealed class
  /// that is either a SmileIDSdkResultSuccess<DocumentCaptureResult> or a SmileIDSdkResultError
  final Function(SmileIDSdkResult<DocumentCaptureResult>) onResult;

  const SmileIDDocumentCaptureView._({
    required this.creationParams,
    required this.onResult,
  });

  factory SmileIDDocumentCaptureView({
    Key? key,
    bool isDocumentFrontSide = true,
    bool showInstructions = true,
    bool showAttribution = true,
    bool allowGalleryUpload = true,
    bool showConfirmationDialog = true,
    double? idAspectRatio,
    required Function(SmileIDSdkResult<DocumentCaptureResult>) onResult,
  }) {
    return SmileIDDocumentCaptureView._(
      onResult: onResult,
      creationParams: {
        "isDocumentFrontSide": isDocumentFrontSide,
        "showInstructions": showInstructions,
        "showAttribution": showAttribution,
        "allowGalleryUpload": allowGalleryUpload,
        "showConfirmationDialog": showConfirmationDialog,
        "idAspectRatio": idAspectRatio,
      },
    );
  }

  @override
  State<SmileIDDocumentCaptureView> createState() =>
      _SmileIDDocumentCaptureViewState();
}

class _SmileIDDocumentCaptureViewState extends State<SmileIDDocumentCaptureView>
    implements DocumentCaptureResultClient {
  late SmileIDProductViewsResultApi api;

  @override
  void initState() {
    super.initState();
    api = DocumentCaptureProductToDocumentCaptureResultAdapter(this);
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
          viewType: SmileIDDocumentCaptureView.viewType,
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
              viewType: SmileIDDocumentCaptureView.viewType,
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
          viewType: SmileIDDocumentCaptureView.viewType,
          creationParams: widget.creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        );
      default:
        throw UnsupportedError("Unsupported platform");
    }
  }

  @override
  void onResult(SmileIDSdkResult<DocumentCaptureResult> result) {
    widget.onResult(result);
  }
}
