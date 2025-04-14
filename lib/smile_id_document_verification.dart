import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:smile_id/product_result_adapters.dart';
import 'package:smile_id/result_clients_interfaces.dart';
import 'package:smile_id/smile_id_product_views_api.dart';
import 'package:smile_id/smileid_messages.g.dart';

import 'smile_id_sdk_result.dart';

class SmileIDDocumentVerification extends StatefulWidget {
  static const String viewType = "SmileIDDocumentVerification";
  final Map<String, dynamic> creationParams;

  /// Called when the user successfully completes the smart selfie enrollment flow. The result is sealed class
  /// that is either a SmileIDSdkResultSuccess<DocumentCaptureResult> or a SmileIDSdkResultError
  final Function(SmileIDSdkResult<DocumentCaptureResult>) onResult;

  const SmileIDDocumentVerification._({
    required this.creationParams,
    required this.onResult,
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
    bool allowNewEnroll = false,
    bool showAttribution = true,
    bool allowGalleryUpload = false,
    bool allowAgentMode = false,
    bool showInstructions = true,
    bool skipApiSubmission = false,
    bool useStrictMode = false,
    Map<String, String>? extraPartnerParams,
    required Function(SmileIDSdkResult<DocumentCaptureResult>) onResult,
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
        "allowNewEnroll": allowNewEnroll,
        "showAttribution": showAttribution,
        "allowAgentMode": allowAgentMode,
        "allowGalleryUpload": allowGalleryUpload,
        "showInstructions": showInstructions,
        "skipApiSubmission": skipApiSubmission,
        "useStrictMode": useStrictMode,
        "extraPartnerParams": extraPartnerParams,
      },
    );
  }

  @override
  State<SmileIDDocumentVerification> createState() =>
      _SmileIDDocumentVerificationState();
}

class _SmileIDDocumentVerificationState
    extends State<SmileIDDocumentVerification>
    implements DocumentCaptureResultClient {
  late SmileIDProductViewsResultApi api;

  @override
  void initState() {
    super.initState();
    api = DocumentVerificationProductToDocumentCaptureResultAdapter(this);
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
          viewType: SmileIDDocumentVerification.viewType,
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
              viewType: SmileIDDocumentVerification.viewType,
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
          viewType: SmileIDDocumentVerification.viewType,
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
