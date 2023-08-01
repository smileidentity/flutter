package com.smileidentity.smileid

import FlutterAuthenticationRequest
import FlutterEnhancedKycAsyncResponse
import FlutterEnhancedKycRequest
import FlutterJobType
import com.smileidentity.models.EnhancedKycAsyncResponse
import com.smileidentity.models.EnhancedKycRequest
import com.smileidentity.models.JobType
import com.smileidentity.models.PartnerParams

fun FlutterJobType.toRequest(): JobType {
    return JobType.valueOf(this.name)
}

fun FlutterAuthenticationRequest.toRequest() = AuthenticationRequest(
    jobType = jobType,
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

fun AuthenticationResponse.toResponse() = FlutterAuthenticationResponse(
    success = success,
    signature = signature,
    timestamp = timestamp,
    partnerParams = partnerParams.toResponse(),
    callbackUrl = callbackUrl,
    consentInfo = consentInfo?.toResponse(),
)

fun FlutterEnhancedKycRequest.toRequest(): EnhancedKycRequest {
    return EnhancedKycRequest(
        country = this.country,
        idType = this.idType,
        idNumber = this.idNumber,
        firstName = this.firstName,
        middleName = this.middleName,
        lastName = this.lastName,
        dob = this.dob,
        phoneNumber = this.phoneNumber,
        bankCode = this.bankCode,
        callbackUrl = this.callbackUrl,
        partnerParams = PartnerParams(
            jobType = this.partnerParams.jobType.toRequest(),
            jobId = this.partnerParams.jobId,
            userId = this.partnerParams.userId,
            extras = mapOf(),
        ),
        partnerId = this.partnerId,
        sourceSdk = this.sourceSdk,
        sourceSdkVersion = this.sourceSdkVersion,
        timestamp = this.timestamp,
        signature = this.signature,
    )
}

fun EnhancedKycAsyncResponse.toResponse(): FlutterEnhancedKycAsyncResponse {
    return FlutterEnhancedKycAsyncResponse(
        success = this.success
    )
}
