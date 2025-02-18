import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

@Deprecated(
  'Due to the expensive nature of platform views, migrate to the more efficient biometricKYC function in the SmileID sdk. This widget will be removed in future versions',
)
class SmileIDBiometricKYC extends StatelessWidget {
  static const String viewType = "SmileIDBiometricKYC";
  final Map<String, dynamic> creationParams;

  /// Called when the user successfully completes the biometric kyc flow. The result is a
  /// JSON string.
  final Function(String) onSuccess;
  final Function(String) onError;

  const SmileIDBiometricKYC._({
    required this.creationParams,
    required this.onSuccess,
    required this.onError,
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
    required Function(String resultJson) onSuccess,
    required Function(String errorMessage) onError,
  }) {
    return SmileIDBiometricKYC._(
      onSuccess: onSuccess,
      onError: onError,
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
