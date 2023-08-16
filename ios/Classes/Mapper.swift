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
                           partnerParams: partnerParams.toRequest(),
                           sourceSdk: "ios (flutter)",
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
    func toRequest() -> PartnerParams {
        PartnerParams(jobId: jobId,
                      userId: userId,
                      jobType: jobType!.toRequest())
    }
}

extension FlutterAuthenticationRequest {
    func toRequest() -> AuthenticationRequest {
        let mappedJobType = jobType.toRequest()
        return AuthenticationRequest(jobType: mappedJobType,
                              enrollment: mappedJobType == .smartSelfieEnrollment,
                              updateEnrolledImage: updateEnrolledImage,
                              jobId: jobId,
                              userId: userId)
    }
}

extension AuthenticationResponse {
    func toResponse() -> FlutterAuthenticationResponse {
        FlutterAuthenticationResponse(success: success,
                                      signature: signature,
                                      timestamp: timestamp,
                                      partnerParams: partnerParams.toFlutterPartnerParams())
    }
}

extension PartnerParams {
    func toFlutterPartnerParams() -> FlutterPartnerParams {
        FlutterPartnerParams(jobType: FlutterJobType(rawValue: jobType.rawValue),
                             jobId: jobId,
                             userId: userId,
                             extras: [:])
    }
}

extension FlutterJobType {
    func toRequest() -> JobType {
        switch (self) {
        case .enhancedKyc:
            return JobType.enhancedKyc
        default: fatalError("Not yet supported")
        }
    }
}

extension JobType {
    func toResponse() -> FlutterJobType {
        switch (self) {
        case .enhancedKyc:
            return FlutterJobType.enhancedKyc
        default: fatalError("Not yet supported")
        }
    }
}
