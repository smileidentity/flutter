import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/messages.g.dart',
  dartOptions: DartOptions(),
  kotlinOut: 'android/src/main/kotlin/com/smileidentity/smileid/Messages.g.kt',
  kotlinOptions: KotlinOptions(),
  swiftOut: 'ios/Classes/Messages.g.swift',
  swiftOptions: SwiftOptions(),
  dartPackageName: 'smileid',
))
enum FlutterJobType { enhanced_kyc(5) }

class FlutterPartnerParams {
  final FlutterJobType? jobType;
  final String jobId;
  final String userId;
  final Map<String?, String?> extras;

  FlutterPartnerParams(this.jobType, this.jobId, this.userId, this.extras);
}

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
  final String partnerId;
  final String sourceSdk;
  final String sourceSdkVersion;
  final String timestamp;
  final String signature;

  FlutterEnhancedKycRequest(
      this.country,
      this.idType,
      this.idNumber,
      this.firstName,
      this.middleName,
      this.lastName,
      this.dob,
      this.phoneNumber,
      this.bankCode,
      this.callbackUrl,
      this.partnerParams,
      this.partnerId,
      this.sourceSdk,
      this.sourceSdkVersion,
      this.timestamp,
      this.signature);
}

class FlutterEnhancedKycAsyncResponse {
  final bool success;

  FlutterEnhancedKycAsyncResponse(this.success);
}

@HostApi()
abstract class SmileIDApi {
  @async
  String? getPlatformVersion();

  @async
  void initialize();

  @async
  FlutterEnhancedKycAsyncResponse? doEnhancedKycAsync(
      FlutterEnhancedKycRequest request);
}
