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
                      jobType: JobType(rawValue: jobType!.rawValue)!)
    }
}

extension FlutterAuthenticationRequest {
    func toRequest() -> AuthenticationRequest {
        AuthenticationRequest(jobType: JobType(rawValue: jobType!.rawValue)!,
                              enrollment: enrollment,
                              updateEnrolledImage: updateEnrolledImage!,
                              jobId: jobId!,
                              userId: userId!)
    }
}

extension AuthenticationResponse {
    func toResponse() -> FlutterAuthenticationResponse {
        FlutterAuthenticationResponse(success: success,
                                      signature: signature,
                                      timestamp: timestamp,
                                      partnerParams: partnerParams.toFlutterParnerParams())
    }
}

extension PartnerParams {
    func toFlutterParnerParams() -> FlutterPartnerParams {
        FlutterPartnerParams(jobType: FlutterJobType(rawValue: jobType.rawValue),
                             jobId: jobId,
                             userId: userId,
                             extras: [:])
    }
}
