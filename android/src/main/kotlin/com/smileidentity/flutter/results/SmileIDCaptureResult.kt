package com.smileidentity.flutter.results

import com.smileidentity.models.v2.SmartSelfieResponse
import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true, generator = "sealed:type")
sealed class SmileIDCaptureResult {
    abstract val selfieFile: String?
    abstract val livenessFiles: List<String>?

    @JsonClass(generateAdapter = true)
    data class SmartSelfieCapture(
        @Json(name = "selfieFile") override val selfieFile: String?,
        @Json(name = "livenessFiles") override val livenessFiles: List<String>?,
    ) : SmileIDCaptureResult()

    @JsonClass(generateAdapter = true)
    data class SmartSelfieCaptureResponse(
        @Json(name = "selfieFile") override val selfieFile: String?,
        @Json(name = "livenessFiles") override val livenessFiles: List<String>?,
        val apiResponse: SmartSelfieResponse? = null,
    ) : SmileIDCaptureResult()

    sealed class DocumentCaptureResult : SmileIDCaptureResult() {
        abstract val documentFrontFile: String?
        abstract val documentBackFile: String?

        @JsonClass(generateAdapter = true)
        data class DocumentCapture(
            @Json(name = "selfieFile") override val selfieFile: String? = null,
            @Json(name = "livenessFiles") override val livenessFiles: List<String>? = null,
            @Json(name = "documentFrontFile") override val documentFrontFile: String?,
            @Json(name = "documentBackFile") override val documentBackFile: String?,
        ) : DocumentCaptureResult()

        @JsonClass(generateAdapter = true)
        data class DocumentVerification(
            @Json(name = "selfieFile") override val selfieFile: String?,
            @Json(name = "livenessFiles") override val livenessFiles: List<String>?,
            @Json(name = "documentFrontFile") override val documentFrontFile: String?,
            @Json(name = "documentBackFile") override val documentBackFile: String?,
            @Json(name = "didSubmitDocumentVerificationJob") val didSubmitDocumentVerificationJob:
                Boolean? = null,
        ) : DocumentCaptureResult()

        @JsonClass(generateAdapter = true)
        data class EnhancedDocumentVerification(
            @Json(name = "selfieFile") override val selfieFile: String?,
            @Json(name = "livenessFiles") override val livenessFiles: List<String>?,
            @Json(name = "documentFrontFile") override val documentFrontFile: String?,
            @Json(name = "documentBackFile") override val documentBackFile: String?,
            @Json(name = "didSubmitEnhancedDocVJob") val didSubmitEnhancedDocVJob: Boolean? = null,
        ) : DocumentCaptureResult()
    }

    @JsonClass(generateAdapter = true)
    data class BiometricKYC(
        @Json(name = "selfieFile") override val selfieFile: String?,
        @Json(name = "livenessFiles") override val livenessFiles: List<String>?,
        @Json(name = "didSubmitBiometricKycJob")val didSubmitBiometricKycJob: Boolean? = null,
    ) : SmileIDCaptureResult()
}
