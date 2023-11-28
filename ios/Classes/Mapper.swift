import SmileID

extension FlutterEnhancedKycRequest {
    func toRequest() -> EnhancedKycRequest {
        EnhancedKycRequest(
            country: country,
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
            signature: signature
        )
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
        PartnerParams(
            jobId: jobId,
            userId: userId,
            jobType: jobType!.toRequest(),
            extras: [:]
        )
    }
}

extension PartnerParams {
    func toResponse() -> FlutterPartnerParams {
        FlutterPartnerParams(
            jobType: jobType?.toResponse(),
            jobId: jobId,
            userId: userId,
            extras: extras?.compactMapValues { $0 }
        )
    }
}

extension FlutterAuthenticationRequest {
    func toRequest() -> AuthenticationRequest {
        let mappedJobType = jobType.toRequest()
        return AuthenticationRequest(
            jobType: mappedJobType,
            enrollment: mappedJobType == .smartSelfieEnrollment,
            updateEnrolledImage: updateEnrolledImage,
            jobId: jobId,
            userId: userId
        )
    }
}

extension AuthenticationResponse {
    func toResponse() -> FlutterAuthenticationResponse {
        FlutterAuthenticationResponse(
            success: success,
            signature: signature,
            timestamp: timestamp,
            partnerParams: partnerParams.toFlutterPartnerParams()
        )
    }
}

extension PartnerParams {
    func toFlutterPartnerParams() -> FlutterPartnerParams {
        FlutterPartnerParams(
            jobType: jobType?.toResponse(),
            jobId: jobId,
            userId: userId,
            extras: extras
        )
    }
}

extension FlutterJobType {
    func toRequest() -> JobType {
        switch (self) {
        case .enhancedKyc:
            return JobType.enhancedKyc
        case .documentVerification:
            return JobType.documentVerification
        }
    }
}

extension JobType {
    func toResponse() -> FlutterJobType {
        switch (self) {
        case .enhancedKyc:
            return FlutterJobType.enhancedKyc
        case .documentVerification:
            return FlutterJobType.documentVerification
        default: fatalError("Not yet supported")
        }
    }
}

extension FlutterPrepUploadRequest {
    func toRequest() -> PrepUploadRequest {
        PrepUploadRequest(
            partnerParams: partnerParams.toRequest(),
            callbackUrl: callbackUrl,
            sourceSdk: "ios (flutter)",
            timestamp: timestamp,
            signature: signature
        )
    }
}

extension PrepUploadResponse {
    func toResponse() -> FlutterPrepUploadResponse {
        FlutterPrepUploadResponse(
            code: code,
            refId: refId,
            uploadUrl: uploadUrl,
            smileJobId: smileJobId
        )
    }
}

extension FlutterUploadRequest {
    func toRequest() throws -> Data {
        Data(contentsOf: try LocalStorage.toZip(UploadRequest(
            images: images.map { $0.toRequest() },
            idInfo: idInfo?.toRequest()
        )))
    }
}

extension FlutterUploadImageInfo {
    func toRequest() -> UploadImageInfo {
        UploadImageInfo(
            imageTypeId: imageTypeId.toRequest(),
            fileName: imageName
        )
    }
}

extension FlutterImageType {
    func toRequest() -> ImageType {
        switch self {
        case .selfieJpgFile:
            return .selfieJpgFile
        case .idCardJpgFile:
            return .idCardJpgFile
        case .selfieJpgBase64:
            return .selfieJpgBase64
        case .idCardJpgBase64:
            return .idCardJpgBase64
        case .livenessJpgFile:
            return .livenessJpgFile
        case .idCardRearJpgFile:
            return .idCardRearJpgFile
        case .livenessJpgBase64:
            return .livenessJpgBase64
        case .idCardRearJpgBase64:
            return .idCardRearJpgBase64
        }
    }
}

extension FlutterIdInfo {
    func toRequest() -> IdInfo {
        IdInfo(
            country: country,
            idType: idType,
            idNumber: idNumber,
            firstName: firstName,
            middleName: middleName,
            lastName: lastName,
            dob: dob,
            bankCode: bankCode,
            entered: entered
        )
    }
}

extension FlutterEnhancedKycRequest {
    func toRequest() -> EnhancedKycRequest {
        EnhancedKycRequest(
            country: country,
            idType: idType,
            idNumber: idNumber,
            firstName: firstName,
            middleName: middleName,
            lastName: lastName,
            dob: dob,
            phoneNumber: phoneNumber,
            bankCode: bankCode,
            callbackUrl: callbackUrl,
            partnerParams: PartnerParams(
                jobId: partnerParams.jobId,
                userId: partnerParams.userId,
                jobType: partnerParams.jobType?.toRequest(),
                extras: partnerParams.extras?.compactMapValues { $0 }
            ),
            sourceSdk: "ios (flutter)",
            timestamp: timestamp,
            signature: signature
        )
    }
}

extension EnhancedKycResponse {
    func toResponse() -> FlutterEnhancedKycResponse {
        FlutterEnhancedKycResponse(
            smileJobId: smileJobId,
            partnerParams: partnerParams.toFlutterPartnerParams(),
            resultText: resultText,
            resultCode: resultCode,
            actions: actions.toFlutterActions(),
            country: country,
            idType: idType,
            idNumber: idNumber,
            fullName: fullName,
            expirationDate: expirationDate,
            dob: dob,
            base64Photo: base64Photo
        )
    }
}

extension EnhancedKycAsyncResponse {
    func toResponse() -> FlutterEnhancedKycAsyncResponse {
        FlutterEnhancedKycAsyncResponse(
            success: success
        )
    }
}

extension Actions {
    func toResponse() -> FlutterActions {
        FlutterActions(
            documentCheck: documentCheck.toResponse(),
            humanReviewCompare: humanReviewCompare.toResponse(),
            humanReviewDocumentCheck: humanReviewDocumentCheck.toResponse(),
            humanReviewLivenessCheck: humanReviewLivenessCheck.toResponse(),
            humanReviewSelfieCheck: humanReviewSelfieCheck.toResponse(),
            humanReviewUpdateSelfie: humanReviewUpdateSelfie.toResponse(),
            livenessCheck: livenessCheck.toResponse(),
            registerSelfie: registerSelfie.toResponse(),
            returnPersonalInfo: returnPersonalInfo.toResponse(),
            selfieCheck: selfieCheck.toResponse(),
            selfieProvided: selfieProvided.toResponse(),
            selfieToIdAuthorityCompare: selfieToIdAuthorityCompare.toResponse(),
            selfieToIdCardCompare: selfieToIdCardCompare.toResponse(),
            selfieToRegisteredSelfieCompare: selfieToRegisteredSelfieCompare.toResponse(),
            updateRegisteredSelfieOnFile: updateRegisteredSelfieOnFile.toResponse(),
            verifyDocument: verifyDocument.toResponse(),
            verifyIdNumber: verifyIdNumber.toResponse()
        )
    }
}

extension ActionResult {
    func toResponse() -> FlutterActionResult {
        switch self {
        case .passed:
            return .passed
        case .completed:
            return .completed
        case .approved:
            return .approved
        case .verified:
            return .verified
        case .provisionallyApproved:
            return .provisionallyApproved
        case .returned:
            return .returned
        case .notReturned:
            return .notReturned
        case .failed:
            return .failed
        case .rejected:
            return .rejected
        case .underReview:
            return .underReview
        case .unableToDetermine:
            return .unableToDetermine
        case .notApplicable:
            return .notApplicable
        case .notVerified:
            return .notVerified
        case .notDone:
            return .notDone
        case .issuerUnavailable:
            return .issuerUnavailable
        }
    }
}

extension ImageLinks {
    func toResponse() -> FlutterImageLinks {
        FlutterImageLinks(
            selfieImageUrl: selfieImageUrl,
            error: error
        )
    }
}

extension Antifraud {
    func toResponse() -> FlutterAntifraud {
        FlutterAntifraud(
            suspectUsers: suspectUsers?.map { $0.toResponse() } ?? []
        )
    }
}

extension SuspectUser {
    func toResponse() -> FlutterSuspectUser {
        FlutterSuspectUser(
            reason: reason ?? "",
            userId: userId ?? ""
        )
    }
}

extension FlutterJobStatusRequest {
    func toRequest() -> JobStatusRequest {
        JobStatusRequest(
            userId: userId,
            jobId: jobId,
            includeImageLinks: includeImageLinks,
            includeHistory: includeHistory,
            partnerId: partnerId,
            timestamp: timestamp,
            signature: signature
        )
    }
}

extension SmartSelfieJobStatusResponse {
    func toResponse() -> FlutterSmartSelfieJobStatusResponse {
        FlutterSmartSelfieJobStatusResponse(
            timestamp: timestamp,
            jobComplete: jobComplete,
            jobSuccess: jobSuccess,
            code: code,
            result: result?.toResponse(),
            resultString: resultString,
            imageLinks: imageLinks?.toResponse()
        )
    }
}

extension SmartSelfieJobResult {
    func toResponse() -> FlutterSmartSelfieJobResult {
        FlutterSmartSelfieJobResult(
            actions: actions.toResponse(),
            resultCode: resultCode,
            resultText: resultText,
            smileJobId: smileJobId,
            partnerParams: partnerParams.toResponse(),
            confidence: confidence
        )
    }
}

extension DocumentVerificationJobStatusResponse {
    func toResponse() -> FlutterDocumentVerificationJobStatusResponse {
        FlutterDocumentVerificationJobStatusResponse(
            timestamp: timestamp,
            jobComplete: jobComplete,
            jobSuccess: jobSuccess,
            code: code,
            result: result?.toResponse(),
            resultString: resultString,
            imageLinks: imageLinks?.toResponse()
        )
    }
}

extension DocumentVerificationJobResult {
    func toResponse() -> DocumentVerificationJobResult {
        FlutterDocumentVerificationJobResult(
            actions: actions.toResponse(),
            resultCode: resultCode,
            resultText: resultText,
            smileJobId: smileJobId,
            partnerParams: partnerParams.toFlutterPartnerParams(),
            country: country,
            idType: idType,
            idNumber: idNumber,
            fullName: fullName,
            dob: dob,
            gender: gender,
            expirationDate: expirationDate,
            documentImageBase64: documentImageBase64,
            phoneNumber: phoneNumber,
            phoneNumber2: phoneNumber2,
            address: address
        )
    }
}

extension BiometricKycJobStatusResponse {
    func toResponse() -> FlutterBiometricKycJobStatusResponse {
        FlutterBiometricKycJobStatusResponse(
            timestamp: timestamp,
            jobComplete: jobComplete,
            jobSuccess: jobSuccess,
            code: code,
            result: result?.toResponse(),
            resultString: resultString,
            imageLinks: imageLinks?.toResponse()
        )
    }
}

extension BiometricKycJobResult {
    func toResponse() -> FlutterBiometricKycJobResult {
        FlutterBiometricKycJobResult(
            actions: actions.toResponse(),
            resultCode: resultCode,
            resultText: resultText,
            resultType: "",
            smileJobId: smileJobId,
            partnerParams: partnerParams.toFlutterPartnerParams(),
            antifraud: antifraud?.toResponse(),
            dob: dob,
            photoBase64: photoBase64,
            gender: gender,
            idType: idType,
            address: address,
            country: country,
            documentImageBase64: documentImageBase64,
            fullData: fullData?.mapKeys { $0 },
            fullName: fullName,
            idNumber: idNumber,
            phoneNumber: phoneNumber,
            phoneNumber2: phoneNumber2,
            expirationDate: expirationDate
        )
    }
}

extension EnhancedDocumentVerificationJobStatusResponse {
    func toResponse() -> FlutterEnhancedDocumentVerificationJobStatusResponse {
        FlutterEnhancedDocumentVerificationJobStatusResponse(
            timestamp: timestamp,
            jobComplete: jobComplete,
            jobSuccess: jobSuccess,
            code: code,
            result: result?.toResponse(),
            resultString: resultString,
            imageLinks: imageLinks?.toResponse()
        )
    }
}

extension EnhancedDocumentVerificationJobResult {
    func toResponse() -> FlutterEnhancedDocumentVerificationJobResult {
        FlutterEnhancedDocumentVerificationJobResult(
            actions: actions.toResponse(),
            resultCode: resultCode,
            resultText: resultText,
            resultType: "",
            smileJobId: smileJobId,
            partnerParams: partnerParams.toFlutterPartnerParams(),
            antifraud: antifraud?.toResponse(),
            dob: dob,
            photoBase64: photoBase64,
            gender: gender,
            idType: idType,
            address: address,
            country: country,
            documentImageBase64: documentImageBase64,
            fullData: fullData?.mapKeys { $0 },
            fullName: fullName,
            idNumber: idNumber,
            phoneNumber: phoneNumber,
            phoneNumber2: phoneNumber2,
            expirationDate: expirationDate
        )
    }
}

extension FlutterProductsConfigRequest {
    func toRequest() -> ProductsConfigRequest {
        ProductsConfigRequest(
            partnerId: partnerId,
            timestamp: timestamp,
            signature: signature
        )
    }
}

extension ProductsConfigResponse {
    func toResponse() -> FlutterProductsConfigResponse {
        FlutterProductsConfigResponse(
            consentRequired: consentRequired,
            idSelection: idSelection.toResponse()
        )
    }
}

extension IdSelection {
    func toResponse() -> FlutterIdSelection {
        FlutterIdSelection(
            basicKyc: basicKyc,
            biometricKyc: biometricKyc,
            enhancedKyc: enhancedKyc,
            documentVerification: documentVerification
        )
    }
}

extension ValidDocumentsResponse {
    func toResponse() -> FlutterValidDocumentsResponse {
        FlutterValidDocumentsResponse(
            validDocuments: validDocuments.map { $0.toResponse() }
        )
    }
}

extension ValidDocument {
    func toResponse() -> FlutterValidDocument {
        FlutterValidDocument(
            country: country.toResponse(),
            idTypes: idTypes.map { $0.toResponse() }
        )
    }
}

extension Country {
    func toResponse() -> FlutterCountry {
        FlutterCountry(
            code: code,
            continent: continent,
            name: name
        )
    }
}

extension IdType {
    func toResponse() -> FlutterIdType {
        FlutterIdType(
            code: code,
            example: example.map { $0 },
            hasBack: hasBack,
            name: name
        )
    }
}

extension ServicesResponse {
    func toResponse() -> FlutterServicesResponse {
        FlutterServicesResponse(
            bankCodes: bankCodes.map { $0.toResponse() },
            hostedWeb: hostedWeb.toResponse()
        )
    }
}

extension BankCode {
    func toResponse() -> FlutterBankCode {
        FlutterBankCode(
            name: name,
            code: code
        )
    }
}

extension HostedWeb {
    func toResponse() -> FlutterHostedWeb {
        FlutterHostedWeb(
            basicKyc: Dictionary(uniqueKeysWithValues: basicKyc.map { ($0.countryCode, $0.toResponse()) }),
            biometricKyc: Dictionary(uniqueKeysWithValues: biometricKyc.map { ($0.countryCode, $0.toResponse()) }),
            enhancedKyc: Dictionary(uniqueKeysWithValues: enhancedKyc.map { ($0.countryCode, $0.toResponse()) }),
            documentVerification: Dictionary(uniqueKeysWithValues: docVerification.map { ($0.countryCode, $0.toResponse()) }),
            enhancedKycSmartSelfie: Dictionary(uniqueKeysWithValues: enhancedKycSmartSelfie.map { ($0.countryCode, $0.toResponse()) }),
            enhancedDocumentVerification: Dictionary(uniqueKeysWithValues: enhancedDocumentVerification.map { ($0.countryCode, $0.toResponse()) })
        )
    }
}

extension CountryInfo {
    func toResponse() -> FlutterCountryInfo {
        FlutterCountryInfo(
            countryCode: countryCode,
            name: name,
            availableIdTypes: availableIdTypes.map { $0.toResponse() }
        )
    }
}

extension AvailableIdType {
    func toResponse() -> FlutterAvailableIdType {
        FlutterAvailableIdType(
            idTypeKey: idTypeKey,
            label: label,
            requiredFields: requiredFields?.map { $0.rawValue } ?? [],
            testData: testData,
            idNumberRegex: idNumberRegex
        )
    }
}
