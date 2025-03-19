package com.smileidentity.flutter.results

import com.smileidentity.models.v2.SmartSelfieResponse
import java.io.File

sealed class SmileIDCaptureResult {
    abstract val selfieFile: File?
    abstract val livenessFiles: List<File>?

    data class SmartSelfieCapture(
        override val selfieFile: File?,
        override val livenessFiles: List<File>?,
    ) : SmileIDCaptureResult()

    data class SmartSelfieCaptureResponse(
        override val selfieFile: File?,
        override val livenessFiles: List<File>?,
        val apiResponse: SmartSelfieResponse? = null,
    ) : SmileIDCaptureResult()

    sealed class DocumentCaptureResult : SmileIDCaptureResult() {
        abstract val documentFrontFile: File?
        abstract val documentBackFile: File?

        data class DocumentCapture(
            override val selfieFile: File? = null,
            override val livenessFiles: List<File>? = null,
            override val documentFrontFile: File? = null,
            override val documentBackFile: File? = null,
        ) : DocumentCaptureResult()

        data class DocumentVerification(
            override val selfieFile: File? = null,
            override val livenessFiles: List<File>? = null,
            override val documentFrontFile: File? = null,
            override val documentBackFile: File? = null,
            val didSubmitDocumentVerificationJob: Boolean? = null,
        ) : DocumentCaptureResult()

        data class EnhancedDocumentVerification(
            override val selfieFile: File?,
            override val livenessFiles: List<File>?,
            override val documentFrontFile: File?,
            override val documentBackFile: File?,
            val didSubmitEnhancedDocVJob: Boolean? = null,
        ) : DocumentCaptureResult()
    }

    data class BiometricKYC(
        override val selfieFile: File?,
        override val livenessFiles: List<File>?,
        val didSubmitBiometricKycJob: Boolean? = null,
    ) : SmileIDCaptureResult()
}
