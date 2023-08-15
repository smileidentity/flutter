package com.smileidentity.flutter

import FlutterAuthenticationRequest
import FlutterAuthenticationResponse
import FlutterConsentInfo
import FlutterEnhancedKycAsyncResponse
import FlutterEnhancedKycRequest
import FlutterJobType
import FlutterPartnerParams
import com.smileidentity.models.AuthenticationRequest
import com.smileidentity.models.AuthenticationResponse
import com.smileidentity.models.ConsentInfo
import com.smileidentity.models.EnhancedKycAsyncResponse
import com.smileidentity.models.EnhancedKycRequest
import com.smileidentity.models.JobType
import com.smileidentity.models.PartnerParams

fun convertNonNullMapToNullable(map: Map<String, String>): Map<String?, String?> =
    map.mapKeys { it.key }
        .mapValues { it.value }


fun FlutterJobType.toRequest() = when(this) {
    FlutterJobType.ENHANCEDKYC -> JobType.EnhancedKyc
}

fun JobType.toResponse() = when(this) {
    JobType.EnhancedKyc -> FlutterJobType.ENHANCEDKYC
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
)

fun ConsentInfo.toRequest() = FlutterConsentInfo(
    canAccess = canAccess,
    consentRequired = consentRequired
)

fun AuthenticationResponse.toResponse() = FlutterAuthenticationResponse(
    success = success,
    signature = signature,
    timestamp = timestamp,
    partnerParams = partnerParams.toResponse(),
    callbackUrl = callbackUrl,
    consentInfo = consentInfo?.toRequest(),
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
    partnerParams = PartnerParams(
        jobType = partnerParams.jobType?.toRequest(),
        jobId = partnerParams.jobId,
        userId = partnerParams.userId,
    ),
    sourceSdk = "android (flutter)",
    timestamp = timestamp,
    signature = signature,
)

fun EnhancedKycAsyncResponse.toResponse() = FlutterEnhancedKycAsyncResponse(
    success = success
)
