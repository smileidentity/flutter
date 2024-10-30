package com.smileidentity.flutter.results

import java.io.File

data class DocumentCaptureResult(
    val selfieFile: File? = null,
    val documentFrontFile: File? = null,
    val livenessFiles: List<File>? = null,
    val documentBackFile: File? = null,
    val didSubmitDocumentVerificationJob: Boolean? = null,
    val didSubmitEnhancedDocVJob: Boolean? = null
)
