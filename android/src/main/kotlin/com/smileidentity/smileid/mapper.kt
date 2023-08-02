package com.smileidentity.smileid

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

fun FlutterJobType.toRequest(): JobType {
    return JobType.valueOf(this.name)
}

fun JobType.toResponse(): FlutterJobType {
    return FlutterJobType.valueOf(this.name)
}

fun FlutterAuthenticationRequest.toRequest() = AuthenticationRequest(
    jobType = jobType?.toRequest(),
    enrollment = enrollment,
    country = country,
    idType = idType,
    updateEnrolledImage = updateEnrolledImage,
    jobId = jobId,
    userId = userId,
    signature = signature,
    production = production,
    partnerId = partnerId,
    authToken = authToken,
)

fun PartnerParams.toResponse() = FlutterPartnerParams(
    jobType = jobType?.toResponse(),
    jobId = jobId,
    userId = userId,
    extras = mapOf()
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
        extras = mapOf(),
    ),
    partnerId = partnerId,
    sourceSdk = sourceSdk,
    sourceSdkVersion = sourceSdkVersion,
    timestamp = timestamp,
    signature = signature,
)

fun EnhancedKycAsyncResponse.toResponse() = FlutterEnhancedKycAsyncResponse(
    success = success
)

