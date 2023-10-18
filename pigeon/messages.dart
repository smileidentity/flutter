import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/messages.g.dart',
  dartOptions: DartOptions(),
  kotlinOut: 'android/src/main/kotlin/com/smileidentity/flutter/Messages.g.kt',
  kotlinOptions: KotlinOptions(),
  swiftOut: 'ios/Classes/Messages.g.swift',
  swiftOptions: SwiftOptions(),
  dartPackageName: 'smileid',
))
enum FlutterJobType { enhancedKyc, documentVerification }

///  Custom values specific to partners can be placed in [extras]
class FlutterPartnerParams {
  final FlutterJobType? jobType;
  final String jobId;
  final String userId;
  Map<String?, String?>? extras;

  FlutterPartnerParams(this.jobType, this.jobId, this.userId);
}

/// The Auth Smile request. Auth Smile serves multiple purposes:
///
/// - It is used to fetch the signature needed for subsequent API requests
/// - It indicates the type of job that will being performed
/// - It is used to fetch consent information for the partner
///
/// [jobType] The type of job that will be performed
/// [country] The country code of the country where the job is being performed. This value is
/// required in order to get back consent information for the partner
/// [idType] The type of ID that will be used for the job. This value is required in order to
/// get back consent information for the partner
/// [updateEnrolledImage] Whether or not the enrolled image should be updated with image
/// submitted for this job
/// [jobId] The job ID to associate with the job. Most often, this will correspond to a unique
/// Job ID within your own system. If not provided, a random job ID will be generated
/// [userId] The user ID to associate with the job. Most often, this will correspond to a unique
/// User ID within your own system. If not provided, a random user ID will be generated

class FlutterAuthenticationRequest {
  final FlutterJobType jobType;
  final String? country;
  final String? idType;
  final bool? updateEnrolledImage;
  final String? jobId;
  final String? userId;

  FlutterAuthenticationRequest({
    required this.jobType,
    this.country,
    this.idType,
    this.updateEnrolledImage,
    this.jobId,
    this.userId,
  });
}

/// [consentInfo] is only populated when a country and ID type are provided in the
/// [FlutterAuthenticationRequest]. To get information about *all* countries and ID types instead,
///  [SmileIDService.getProductsConfig]
///
/// [timestamp] is *not* a [DateTime] because technically, any arbitrary value could have been
/// passed to it. This applies to all other timestamp fields in the SDK.

class FlutterAuthenticationResponse {
  final bool success;
  final String signature;
  final String timestamp;
  final FlutterPartnerParams partnerParams;
  final String? callbackUrl;
  final FlutterConsentInfo? consentInfo;

  FlutterAuthenticationResponse({
    required this.success,
    required this.signature,
    required this.timestamp,
    required this.partnerParams,
    this.callbackUrl,
    this.consentInfo,
  });
}

/// [canAccess] Whether or not the ID type is enabled for the partner
/// [consentRequired] Whether or not consent is required for the ID type
class FlutterConsentInfo {
  final bool canAccess;
  final bool consentRequired;

  FlutterConsentInfo({required this.canAccess, required this.consentRequired});
}

/// [timestamp] is *not* a [DateTime] because technically, any arbitrary value could have been
/// passed to it. This applies to all other timestamp fields in the SDK.
class FlutterEnhancedKycRequest {
  final String country;
  final String idType;
  final String idNumber;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? dob;
  final String? phoneNumber;
  final String? bankCode;
  final String? callbackUrl;
  final FlutterPartnerParams partnerParams;
  final String timestamp;
  final String signature;

  FlutterEnhancedKycRequest(
      {required this.country,
      required this.idType,
      required this.idNumber,
      this.firstName,
      this.middleName,
      this.lastName,
      this.dob,
      this.phoneNumber,
      this.bankCode,
      this.callbackUrl,
      required this.partnerParams,
      required this.timestamp,
      required this.signature});
}

class FlutterEnhancedKycAsyncResponse {
  final bool success;

  FlutterEnhancedKycAsyncResponse({required this.success});
}

@HostApi()
abstract class SmileIDApi {
  void initialize();

  void setEnvironment(bool useSandbox);

  void setCallbackUrl(String callbackUrl);

  @async
  FlutterAuthenticationResponse authenticate(FlutterAuthenticationRequest request);

  @async
  FlutterEnhancedKycAsyncResponse doEnhancedKycAsync(FlutterEnhancedKycRequest request);
}
