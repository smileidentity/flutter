enum JobType {
  BiometricKyc,
}

class PartnerParams {
  final JobType jobType;
  final String jobId;
  final String userId;
  final Map<String, String> extras;

  PartnerParams.fromJson(this.jobType, this.jobId, this.userId, this.extras);
}

class EnhancedKycRequest {
  final String country;
  final String idType;
  final String idNumber;
  final String firstName;
  final String middleName;
  final String lastName;
  final String dob;
  final String phoneNumber;
  final String bankCode;
  final String callbackUrl;
  final String partnerParams;
  final String partnerId;
  final String sourceSdk;
  final String sourceSdkVersion;
  final String timestamp;
  final String signature;

  EnhancedKycRequest.fromJson(
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

class EnhancedKycAsyncResponse {
  final bool success;

  EnhancedKycAsyncResponse.fromJson(bool response) : success = response;
}
