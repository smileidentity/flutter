import SmileID

extension FlutterEnhancedKycRequest {
    func toRequest() -> EnhancedKycRequest {
        EnhancedKycRequest(country: country,
                           idType: idType,
                           idNumber: idNumber,
                           firstName: firstName,
                           middleName: middleName,
                           lastName: lastName,
                           dob: dob,
                           phoneNumber: phoneNumber,
                           bankCode: bankCode,
                           callbackUrl: callbackUrl,
                           partnerParams: partnerParams.toPartnerParams(),
                           timestamp: timestamp,
                           signature: signature)
    }
}

extension FlutterEnhancedKycAsyncResponse {
    func toResponse() ->  EnhancedKycAsyncResponse {
        EnhancedKycAsyncResponse(success: success)
    }
}

extension EnhancedKycAsyncResponse {
    func toFlutterResponse() -> FlutterEnhancedKycAsyncResponse {
        FlutterEnhancedKycAsyncResponse(success: success)
    }
}

extension FlutterPartnerParams {
    func toPartnerParams() -> PartnerParams {
        PartnerParams(jobId: jobId,
                      userId: userId,
                      jobType: JobType(rawValue: jobType.rawValue)!)
    }
}
