package com.smileidentity.flutter

import FlutterActionResult
import FlutterActions
import FlutterAntifraud
import FlutterAuthenticationRequest
import FlutterAuthenticationResponse
import FlutterAvailableIdType
import FlutterBankCode
import FlutterBiometricKycJobResult
import FlutterBiometricKycJobStatusResponse
import FlutterConsentInfo
import FlutterCountry
import FlutterCountryInfo
import FlutterDocumentVerificationJobResult
import FlutterDocumentVerificationJobStatusResponse
import FlutterEnhancedDocumentVerificationJobResult
import FlutterEnhancedDocumentVerificationJobStatusResponse
import FlutterEnhancedKycAsyncResponse
import FlutterEnhancedKycRequest
import FlutterEnhancedKycResponse
import FlutterHostedWeb
import FlutterIdInfo
import FlutterIdSelection
import FlutterIdType
import FlutterImageLinks
import FlutterImageType
import FlutterJobStatusRequest
import FlutterJobType
import FlutterJobTypeV2
import FlutterPartnerParams
import FlutterPrepUploadRequest
import FlutterPrepUploadResponse
import FlutterProductsConfigRequest
import FlutterProductsConfigResponse
import FlutterServicesResponse
import FlutterSmartSelfieJobResult
import FlutterSmartSelfieJobStatusResponse
import FlutterSmartSelfieResponse
import FlutterSmartSelfieStatus
import FlutterSuspectUser
import FlutterUploadImageInfo
import FlutterUploadRequest
import FlutterValidDocument
import FlutterValidDocumentsResponse
import com.smileidentity.models.ActionResult
import com.smileidentity.models.Actions
import com.smileidentity.models.Antifraud
import com.smileidentity.models.AuthenticationRequest
import com.smileidentity.models.AuthenticationResponse
import com.smileidentity.models.AvailableIdType
import com.smileidentity.models.BankCode
import com.smileidentity.models.BiometricKycJobResult
import com.smileidentity.models.BiometricKycJobStatusResponse
import com.smileidentity.models.ConsentInfo
import com.smileidentity.models.Country
import com.smileidentity.models.CountryInfo
import com.smileidentity.models.DocumentVerificationJobResult
import com.smileidentity.models.DocumentVerificationJobStatusResponse
import com.smileidentity.models.EnhancedDocumentVerificationJobResult
import com.smileidentity.models.EnhancedDocumentVerificationJobStatusResponse
import com.smileidentity.models.EnhancedKycAsyncResponse
import com.smileidentity.models.EnhancedKycRequest
import com.smileidentity.models.EnhancedKycResponse
import com.smileidentity.models.HostedWeb
import com.smileidentity.models.IdInfo
import com.smileidentity.models.IdSelection
import com.smileidentity.models.IdType
import com.smileidentity.models.ImageLinks
import com.smileidentity.models.ImageType
import com.smileidentity.models.JobResult
import com.smileidentity.models.JobStatusRequest
import com.smileidentity.models.JobType
import com.smileidentity.models.PartnerParams
import com.smileidentity.models.PrepUploadRequest
import com.smileidentity.models.PrepUploadResponse
import com.smileidentity.models.ProductsConfigRequest
import com.smileidentity.models.ProductsConfigResponse
import com.smileidentity.models.ServicesResponse
import com.smileidentity.models.SmartSelfieJobResult
import com.smileidentity.models.SmartSelfieJobStatusResponse
import com.smileidentity.models.SuspectUser
import com.smileidentity.models.UploadImageInfo
import com.smileidentity.models.UploadRequest
import com.smileidentity.models.ValidDocument
import com.smileidentity.models.ValidDocumentsResponse
import com.smileidentity.models.v2.JobType as JobTypeV2
import com.smileidentity.models.v2.SmartSelfieResponse
import com.smileidentity.models.v2.SmartSelfieStatus
import java.io.File

/**
 * Pigeon does not allow non nullable types in this example here
 *
 *  final Map<String, String> extras;
 *
 *  Error: pigeons/messages.dart:18: Generic type arguments must be nullable in field "extras" in
 *  class "FlutterPartnerParams".
 *
 *  The fix is these two helper functions to convert maps to nullable types, and vice versa
 */
fun convertNullableMapToNonNull(map: Map<String?, String?>?): Map<String, String> =
    map?.filterKeys { it != null }
        ?.filterValues { it != null }
        ?.mapKeys { it.key!! }
        ?.mapValues { it.value!! } ?: mapOf()

fun convertNonNullMapToNullable(map: Map<String, String>): Map<String?, String?> =
    map.mapKeys { it.key }
        .mapValues { it.value }

fun FlutterJobType.toRequest() = when (this) {
    FlutterJobType.ENHANCEDKYC -> JobType.EnhancedKyc
    FlutterJobType.DOCUMENTVERIFICATION -> JobType.DocumentVerification
    FlutterJobType.BIOMETRICKYC -> JobType.BiometricKyc
    FlutterJobType.ENHANCEDDOCUMENTVERIFICATION -> JobType.EnhancedDocumentVerification
    FlutterJobType.SMARTSELFIEENROLLMENT -> JobType.SmartSelfieEnrollment
    FlutterJobType.SMARTSELFIEAUTHENTICATION -> JobType.SmartSelfieAuthentication
}

fun JobType.toResponse() = when (this) {
    JobType.EnhancedKyc -> FlutterJobType.ENHANCEDKYC
    JobType.DocumentVerification -> FlutterJobType.DOCUMENTVERIFICATION
    JobType.BiometricKyc -> FlutterJobType.BIOMETRICKYC
    JobType.EnhancedDocumentVerification -> FlutterJobType.ENHANCEDDOCUMENTVERIFICATION
    JobType.SmartSelfieEnrollment -> FlutterJobType.SMARTSELFIEENROLLMENT
    JobType.SmartSelfieAuthentication -> FlutterJobType.SMARTSELFIEAUTHENTICATION
    else -> TODO("Not yet implemented")
}

fun FlutterJobTypeV2.toRequest() = when (this) {
    FlutterJobTypeV2.SMARTSELFIEAUTHENTICATION -> JobTypeV2.SmartSelfieAuthentication
    FlutterJobTypeV2.SMARTSELFIEENROLLMENT -> JobTypeV2.SmartSelfieEnrollment
}

fun JobTypeV2.toResponse() = when (this) {
    JobTypeV2.SmartSelfieAuthentication -> FlutterJobTypeV2.SMARTSELFIEAUTHENTICATION
    JobTypeV2.SmartSelfieEnrollment -> FlutterJobTypeV2.SMARTSELFIEENROLLMENT
    else -> TODO("Not yet implemented")
}

fun FlutterAuthenticationRequest.toRequest() = AuthenticationRequest(
    jobType = jobType.toRequest(),
    country = country,
    idType = idType,
    updateEnrolledImage = updateEnrolledImage,
    jobId = jobId,
    userId = userId,
)

fun PartnerParams.toResponse() = FlutterPartnerParams(
    jobType = jobType?.toResponse(),
    jobId = jobId,
    userId = userId,
    extras = convertNonNullMapToNullable(extras),
)

fun FlutterPartnerParams.toRequest() = PartnerParams(
    jobType = jobType?.toRequest(),
    jobId = jobId,
    userId = userId,
    extras = convertNullableMapToNonNull(extras),
)

fun ConsentInfo.toRequest() = FlutterConsentInfo(
    canAccess = canAccess,
    consentRequired = consentRequired,
)

fun AuthenticationResponse.toResponse() = FlutterAuthenticationResponse(
    success = success,
    signature = signature,
    timestamp = timestamp,
    partnerParams = partnerParams.toResponse(),
    callbackUrl = callbackUrl,
    consentInfo = consentInfo?.toRequest(),
)

fun FlutterPrepUploadRequest.toRequest() = PrepUploadRequest(
    partnerParams = partnerParams.toRequest(),
    callbackUrl = callbackUrl,
    allowNewEnroll = allowNewEnroll.toString(),
    partnerId = partnerId,
    sourceSdk = "android (flutter)",
    timestamp = timestamp,
    signature = signature,
)

fun PrepUploadResponse.toResponse() = FlutterPrepUploadResponse(
    code = code,
    refId = refId,
    uploadUrl = uploadUrl,
    smileJobId = smileJobId,
)

fun FlutterUploadRequest.toRequest() = UploadRequest(
    images = images.mapNotNull { it?.toRequest() },
    idInfo = idInfo?.toRequest(),
)

fun FlutterUploadImageInfo.toRequest() = UploadImageInfo(
    imageTypeId = imageTypeId.toRequest(),
    image = File(imageName),
)

fun FlutterImageType.toRequest() = when (this) {
    FlutterImageType.SELFIEJPGFILE -> ImageType.SelfieJpgFile
    FlutterImageType.IDCARDJPGFILE -> ImageType.IdCardJpgFile
    FlutterImageType.SELFIEJPGBASE64 -> ImageType.SelfieJpgBase64
    FlutterImageType.IDCARDJPGBASE64 -> ImageType.IdCardJpgBase64
    FlutterImageType.LIVENESSJPGFILE -> ImageType.LivenessJpgFile
    FlutterImageType.IDCARDREARJPGFILE -> ImageType.IdCardRearJpgFile
    FlutterImageType.LIVENESSJPGBASE64 -> ImageType.LivenessJpgBase64
    FlutterImageType.IDCARDREARJPGBASE64 -> ImageType.IdCardRearJpgBase64
}

fun FlutterIdInfo.toRequest() = IdInfo(
    country = country,
    idType = idType,
    idNumber = idNumber,
    firstName = firstName,
    middleName = middleName,
    lastName = lastName,
    dob = dob,
    bankCode = bankCode,
    entered = entered,
)

fun FlutterEnhancedKycRequest.toRequest() = EnhancedKycRequest(
    country = country,
    idType = idType,
    idNumber = idNumber,
    firstName = firstName,
    middleName = middleName,
    lastName = lastName,
    dob = dob,
    phoneNumber = phoneNumber,
    bankCode = bankCode,
    callbackUrl = callbackUrl,
    partnerParams = partnerParams.toRequest(),
    sourceSdk = "android (flutter)",
    timestamp = timestamp,
    signature = signature,
)

fun EnhancedKycResponse.toResponse() = FlutterEnhancedKycResponse(
    smileJobId = smileJobId,
    partnerParams = partnerParams.toResponse(),
    resultText = resultText,
    resultCode = resultCode,
    actions = actions.toResponse(),
    country = country,
    idType = idType,
    idNumber = idNumber,
    fullName = fullName,
    expirationDate = expirationDate,
    dob = dob,
    base64Photo = base64Photo,
)

fun EnhancedKycAsyncResponse.toResponse() = FlutterEnhancedKycAsyncResponse(
    success = success,
)

fun Actions.toResponse() = FlutterActions(
    documentCheck = documentCheck.toResponse(),
    humanReviewCompare = humanReviewCompare.toResponse(),
    humanReviewDocumentCheck = humanReviewDocumentCheck.toResponse(),
    humanReviewLivenessCheck = humanReviewLivenessCheck.toResponse(),
    humanReviewSelfieCheck = humanReviewSelfieCheck.toResponse(),
    humanReviewUpdateSelfie = humanReviewUpdateSelfie.toResponse(),
    livenessCheck = livenessCheck.toResponse(),
    registerSelfie = registerSelfie.toResponse(),
    returnPersonalInfo = returnPersonalInfo.toResponse(),
    selfieCheck = selfieCheck.toResponse(),
    selfieProvided = selfieProvided.toResponse(),
    selfieToIdAuthorityCompare = selfieToIdAuthorityCompare.toResponse(),
    selfieToIdCardCompare = selfieToIdCardCompare.toResponse(),
    selfieToRegisteredSelfieCompare = selfieToRegisteredSelfieCompare.toResponse(),
    updateRegisteredSelfieOnFile = updateRegisteredSelfieOnFile.toResponse(),
    verifyDocument = verifyDocument.toResponse(),
    verifyIdNumber = verifyIdNumber.toResponse(),
)

fun ActionResult.toResponse() = when (this) {
    ActionResult.Passed -> FlutterActionResult.PASSED
    ActionResult.Completed -> FlutterActionResult.COMPLETED
    ActionResult.Approved -> FlutterActionResult.APPROVED
    ActionResult.Verified -> FlutterActionResult.VERIFIED
    ActionResult.ProvisionallyApproved -> FlutterActionResult.PROVISIONALLYAPPROVED
    ActionResult.Returned -> FlutterActionResult.RETURNED
    ActionResult.NotReturned -> FlutterActionResult.NOTRETURNED
    ActionResult.Failed -> FlutterActionResult.FAILED
    ActionResult.Rejected -> FlutterActionResult.REJECTED
    ActionResult.UnderReview -> FlutterActionResult.UNDERREVIEW
    ActionResult.UnableToDetermine -> FlutterActionResult.UNABLETODETERMINE
    ActionResult.NotApplicable -> FlutterActionResult.NOTAPPLICABLE
    ActionResult.NotVerified -> FlutterActionResult.NOTVERIFIED
    ActionResult.NotDone -> FlutterActionResult.NOTDONE
    ActionResult.IssuerUnavailable -> FlutterActionResult.ISSUERUNAVAILABLE
    ActionResult.Unknown -> FlutterActionResult.UNKNOWN
}

fun ImageLinks.toResponse() = FlutterImageLinks(
    selfieImageUrl = selfieImageUrl,
    error = error,
)

fun Antifraud.toResponse() = FlutterAntifraud(
    suspectUsers = suspectUsers.map { it.toResponse() },
)

fun SuspectUser.toResponse() = FlutterSuspectUser(
    reason = reason,
    userId = userId,
)

fun FlutterJobStatusRequest.toRequest() = JobStatusRequest(
    userId = userId,
    jobId = jobId,
    includeImageLinks = includeImageLinks,
    includeHistory = includeHistory,
    partnerId = partnerId,
    timestamp = timestamp,
    signature = signature,
)

fun SmartSelfieJobStatusResponse.toResponse() = FlutterSmartSelfieJobStatusResponse(
    timestamp = timestamp,
    jobComplete = jobComplete,
    jobSuccess = jobSuccess,
    code = code,
    result = result?.toResponse() as? FlutterSmartSelfieJobResult,
    resultString = result?.toResponse() as? String,
    imageLinks = imageLinks?.toResponse(),
)

fun SmartSelfieJobResult.toResponse(): Any = when (this) {
    is JobResult.Freeform -> this.result
    is SmartSelfieJobResult.Entry -> FlutterSmartSelfieJobResult(
        actions = actions.toResponse(),
        resultCode = resultCode,
        resultText = resultText,
        smileJobId = smileJobId,
        partnerParams = partnerParams.toResponse(),
        confidence = confidence,
    )
}

fun SmartSelfieStatus.toResponse() = when (this) {
    SmartSelfieStatus.Approved -> FlutterSmartSelfieStatus.APPROVED
    SmartSelfieStatus.Pending -> FlutterSmartSelfieStatus.PENDING
    SmartSelfieStatus.Rejected -> FlutterSmartSelfieStatus.REJECTED
    SmartSelfieStatus.Unknown -> FlutterSmartSelfieStatus.UNKNOWN
}

fun SmartSelfieResponse.toResponse() = FlutterSmartSelfieResponse(
    code = code,
    createdAt = createdAt,
    jobId = jobId,
    jobType = jobType.toResponse(),
    message = message,
    partnerId = partnerId,
    partnerParams = convertNonNullMapToNullable(partnerParams),
    status = status.toResponse(),
    updatedAt = updatedAt,
    userId = userId,
)

fun DocumentVerificationJobStatusResponse.toResponse() =
    FlutterDocumentVerificationJobStatusResponse(
        timestamp = timestamp,
        jobComplete = jobComplete,
        jobSuccess = jobSuccess,
        code = code,
        result = result?.toResponse() as? FlutterDocumentVerificationJobResult,
        resultString = result?.toResponse() as? String,
        imageLinks = imageLinks?.toResponse(),
    )

fun DocumentVerificationJobResult.toResponse(): Any = when (this) {
    is JobResult.Freeform -> this.result
    is DocumentVerificationJobResult.Entry -> FlutterDocumentVerificationJobResult(
        actions = actions.toResponse(),
        resultCode = resultCode,
        resultText = resultText,
        smileJobId = smileJobId,
        partnerParams = partnerParams.toResponse(),
        country = country,
        idType = idType,
        fullName = fullName,
        idNumber = idNumber,
        dob = dob,
        gender = gender,
        expirationDate = expirationDate,
        documentImageBase64 = documentImageBase64,
        phoneNumber = phoneNumber,
        phoneNumber2 = phoneNumber2,
        address = address,
    )
}

fun BiometricKycJobStatusResponse.toResponse() = FlutterBiometricKycJobStatusResponse(
    timestamp = timestamp,
    jobComplete = jobComplete,
    jobSuccess = jobSuccess,
    code = code,
    result = result?.toResponse() as? FlutterBiometricKycJobResult,
    resultString = result?.toResponse() as? String,
    imageLinks = imageLinks?.toResponse(),
)

fun BiometricKycJobResult.toResponse(): Any = when (this) {
    is JobResult.Freeform -> this.result
    is BiometricKycJobResult.Entry -> FlutterBiometricKycJobResult(
        actions = actions.toResponse(),
        resultCode = resultCode,
        resultText = resultText,
        resultType = resultType,
        smileJobId = smileJobId,
        partnerParams = partnerParams.toResponse(),
        antifraud = antifraud?.toResponse(),
        dob = dob,
        photoBase64 = photoBase64,
        gender = gender,
        idType = idType,
        address = address,
        country = country,
        documentImageBase64 = documentImageBase64,
        fullData = fullData?.mapKeys { it.key },
        fullName = fullName,
        idNumber = idNumber,
        phoneNumber = phoneNumber,
        phoneNumber2 = phoneNumber2,
        expirationDate = expirationDate,
    )
}

fun EnhancedDocumentVerificationJobStatusResponse.toResponse() =
    FlutterEnhancedDocumentVerificationJobStatusResponse(
        timestamp = timestamp,
        jobComplete = jobComplete,
        jobSuccess = jobSuccess,
        code = code,
        result = result?.toResponse() as? FlutterEnhancedDocumentVerificationJobResult,
        resultString = result?.toResponse() as? String,
        imageLinks = imageLinks?.toResponse(),
    )

fun EnhancedDocumentVerificationJobResult.toResponse(): Any = when (this) {
    is JobResult.Freeform -> this.result
    is EnhancedDocumentVerificationJobResult.Entry -> FlutterEnhancedDocumentVerificationJobResult(
        actions = actions.toResponse(),
        resultCode = resultCode,
        resultText = resultText,
        smileJobId = smileJobId,
        resultType = resultType,
        partnerParams = partnerParams.toResponse(),
        antifraud = antifraud?.toResponse(),
        dob = dob,
        photoBase64 = photoBase64,
        gender = gender,
        idType = idType,
        address = address,
        country = country,
        documentImageBase64 = documentImageBase64,
        fullData = fullData?.mapKeys { it.key },
        fullName = fullName,
        idNumber = idNumber,
        phoneNumber = phoneNumber,
        phoneNumber2 = phoneNumber2,
        expirationDate = expirationDate,
    )
}

fun FlutterProductsConfigRequest.toRequest() = ProductsConfigRequest(
    partnerId = partnerId,
    timestamp = timestamp,
    signature = signature,
)

fun ProductsConfigResponse.toResponse() = FlutterProductsConfigResponse(
    consentRequired = consentRequired.mapKeys { it.key },
    idSelection = idSelection.toResponse(),
)

fun IdSelection.toResponse() = FlutterIdSelection(
    basicKyc = basicKyc.mapKeys { it.key },
    biometricKyc = biometricKyc.mapKeys { it.key },
    enhancedKyc = enhancedKyc.mapKeys { it.key },
    documentVerification = documentVerification.mapKeys { it.key },
)

fun ValidDocumentsResponse.toResponse() = FlutterValidDocumentsResponse(
    validDocuments = validDocuments.map { it.toResponse() },
)

fun ValidDocument.toResponse() = FlutterValidDocument(
    country = country.toResponse(),
    idTypes = idTypes.map { it.toResponse() },
)

fun Country.toResponse() = FlutterCountry(
    name = name,
    code = code,
    continent = continent,
)

fun IdType.toResponse() = FlutterIdType(
    name = name,
    code = code,
    example = example.map { it },
    hasBack = hasBack,
)

fun ServicesResponse.toResponse() = FlutterServicesResponse(
    bankCodes = bankCodes.map { it.toResponse() },
    hostedWeb = hostedWeb.toResponse(),
)

fun BankCode.toResponse() = FlutterBankCode(
    name = name,
    code = code,
)

fun HostedWeb.toResponse() = FlutterHostedWeb(
    basicKyc = basicKyc.groupBy { it.countryCode }.mapValues { it.value.first().toResponse() },
    biometricKyc = biometricKyc.groupBy { it.countryCode }
        .mapValues { it.value.first().toResponse() },
    enhancedKyc = enhancedKyc.groupBy { it.countryCode }
        .mapValues { it.value.first().toResponse() },
    documentVerification = docVerification.groupBy { it.countryCode }
        .mapValues { it.value.first().toResponse() },
    enhancedKycSmartSelfie = enhancedKycSmartSelfie.groupBy { it.countryCode }
        .mapValues { it.value.first().toResponse() },
    enhancedDocumentVerification = enhancedDocumentVerification.groupBy { it.countryCode }
        .mapValues { it.value.first().toResponse() },
)

fun CountryInfo.toResponse() = FlutterCountryInfo(
    countryCode = countryCode,
    name = name,
    availableIdTypes = availableIdTypes.map { it.toResponse() },
)

fun AvailableIdType.toResponse() = FlutterAvailableIdType(
    idTypeKey = idTypeKey,
    label = label,
    requiredFields = requiredFields.map { it.name },
    testData = testData,
    idNumberRegex = idNumberRegex,
)
