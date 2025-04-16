import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:smile_id/product_result_adapters.dart';
import 'package:smile_id/result_clients_interfaces.dart';
import 'package:smile_id/smile_id_product_views_api.dart';
import 'package:smile_id/smile_id_sdk_result.dart';
import 'package:smile_id/smileid_messages.g.dart';

class SmileIDBiometricKYC extends StatefulWidget {
  static const String viewType = "SmileIDBiometricKYC";
  final Map<String, dynamic> creationParams;

  /// Called when the user successfully completes the smart selfie enrollment flow. The result is sealed class
  /// that is either a SmileIDSdkResultSuccess<BiometricKYCCaptureResult> or a SmileIDSdkResultError
  final Function(SmileIDSdkResult<BiometricKYCCaptureResult>) onResult;

  const SmileIDBiometricKYC._({
    required this.creationParams,
    required this.onResult,
  });

  factory SmileIDBiometricKYC({
    Key? key,
    // userId and jobId can't actually be null in the native SDK but we delegate their creation to
    // the native platform code, since that's where the random ID creation happens
    required String? country,
    String? idType,
    String? idNumber,
    String? firstName,
    String? middleName,
    String? lastName,
    String? dob,
    String? bankCode,
    bool? entered,
    String? userId,
    String? jobId,
    String? consentGrantedDate,
    bool personalDetailsConsentGranted = false,
    bool contactInformationConsentGranted = false,
    bool documentInformationConsentGranted = false,
    bool allowNewEnroll = false,
    bool allowAgentMode = false,
    bool showAttribution = true,
    bool showInstructions = true,
    bool useStrictMode = false,
    Map<String, String>? extraPartnerParams,
    required Function(SmileIDSdkResult<BiometricKYCCaptureResult>) onResult,
  }) {
    return SmileIDBiometricKYC._(
      onResult: onResult,
      creationParams: {
        "country": country,
        "idType": idType,
        "idNumber": idNumber,
        "firstName": firstName,
        "middleName": middleName,
        "lastName": lastName,
        "dob": dob,
        "bankCode": bankCode,
        "entered": entered,
        "userId": userId,
        "jobId": jobId,
        "consentGrantedDate": consentGrantedDate,
        "personalDetailsConsentGranted": personalDetailsConsentGranted,
        "contactInfoConsentGranted": contactInformationConsentGranted,
        "documentInfoConsentGranted": documentInformationConsentGranted,
        "allowNewEnroll": allowNewEnroll,
        "allowAgentMode": allowAgentMode,
        "showAttribution": showAttribution,
        "showInstructions": showInstructions,
        "useStrictMode": useStrictMode,
        "extraPartnerParams": extraPartnerParams,
      },
    );
  }

  @override
  State<SmileIDBiometricKYC> createState() => _SmileIDBiometricKYCState();
}

class _SmileIDBiometricKYCState extends State<SmileIDBiometricKYC>
    implements BiometricKYCCaptureResultClient {
  late SmileIDProductViewsResultApi api;

  @override
  void initState() {
    super.initState();
    api = BiometricKycAdapter(this);
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
          viewType: SmileIDBiometricKYC.viewType,
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
              viewType: SmileIDBiometricKYC.viewType,
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
          viewType: SmileIDBiometricKYC.viewType,
          creationParams: widget.creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        );
      default:
        throw UnsupportedError("Unsupported platform");
    }
  }

  @override
  void onResult(SmileIDSdkResult<BiometricKYCCaptureResult> result) {
    widget.onResult(result);
  }
}
