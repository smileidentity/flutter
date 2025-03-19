package com.smileidentity.flutter.results

import java.io.File

object SmileIDCaptureResultAdapterRegistry {
    private val commonFileFields =
        mapOf<String, (SmileIDCaptureResult) -> File?>(
            "selfieFile" to { it.selfieFile },
        )

    private val commonFileListFields =
        mapOf<String, (SmileIDCaptureResult) -> List<File>?>(
            "livenessFiles" to { it.livenessFiles },
        )

    // Document capture common fields
    private val documentFileFields =
        mapOf<String, (SmileIDCaptureResult.DocumentCaptureResult) -> File?>(
            "selfieFile" to { it.selfieFile },
            "documentFrontFile" to { it.documentFrontFile },
            "documentBackFile" to { it.documentBackFile },
        )

    // Selfie capture adapter
    val selfieAdapter =
        SmileIDResultsAdapter.create(
            singleCapture =
                commonFileFields
                    .mapKeys { it.key }
                    .mapValues { entry ->
                        { value: SmileIDCaptureResult.SmartSelfieCapture -> entry.value(value) }
                    },
            livenessImages =
                commonFileListFields
                    .mapKeys { it.key }
                    .mapValues { entry ->
                        { value: SmileIDCaptureResult.SmartSelfieCapture -> entry.value(value) }
                    },
            createResult = { fileValues, fileListValues, _, _ ->
                SmileIDCaptureResult.SmartSelfieCapture(
                    selfieFile = fileValues["selfieFile"],
                    livenessFiles = fileListValues["livenessFiles"],
                )
            },
        )

    // Smart Selfie adapter
    val smartSelfieAdapter =
        SmileIDResultsAdapter.create(
            singleCapture =
                commonFileFields
                    .mapKeys { it.key }
                    .mapValues { entry ->
                        { value: SmileIDCaptureResult.SmartSelfieCaptureResponse ->
                            entry.value(value)
                        }
                    },
            livenessImages =
                commonFileListFields
                    .mapKeys { it.key }
                    .mapValues { entry ->
                        { value: SmileIDCaptureResult.SmartSelfieCaptureResponse ->
                            entry.value(value)
                        }
                    },
            apiResponse =
                mapOf(
                    "apiResponse" to { it.apiResponse },
                ),
            createResult = { fileValues, fileListValues, _, apiResponseValues ->
                SmileIDCaptureResult.SmartSelfieCaptureResponse(
                    selfieFile = fileValues["selfieFile"],
                    livenessFiles = fileListValues["livenessFiles"],
                    apiResponse = apiResponseValues["apiResponse"],
                )
            },
        )

    // Document capture adapter
    val documentCaptureAdapter =
        SmileIDResultsAdapter.create(
            singleCapture =
                documentFileFields
                    .mapKeys { it.key }
                    .mapValues { entry ->
                        { value: SmileIDCaptureResult.DocumentCaptureResult.DocumentCapture ->
                            entry.value(
                                value,
                            )
                        }
                    },
            livenessImages =
                commonFileListFields
                    .mapKeys { it.key }
                    .mapValues { entry ->
                        { value: SmileIDCaptureResult.DocumentCaptureResult.DocumentCapture ->
                            entry.value(
                                value,
                            )
                        }
                    },
            createResult = { fileValues, fileListValues, _, _ ->
                SmileIDCaptureResult.DocumentCaptureResult.DocumentCapture(
                    selfieFile = fileValues["selfieFile"],
                    livenessFiles = fileListValues["livenessFiles"],
                    documentFrontFile = fileValues["documentFrontFile"],
                    documentBackFile = fileValues["documentBackFile"],
                )
            },
        )

    // Document Verification adapter
    val documentVerificationAdapter =
        SmileIDResultsAdapter.create(
            singleCapture =
                documentFileFields
                    .mapKeys { it.key }
                    .mapValues { entry ->
                        { value: SmileIDCaptureResult.DocumentCaptureResult.DocumentVerification ->
                            entry.value(
                                value,
                            )
                        }
                    },
            livenessImages =
                commonFileListFields
                    .mapKeys { it.key }
                    .mapValues { entry ->
                        { value: SmileIDCaptureResult.DocumentCaptureResult.DocumentVerification ->
                            entry.value(
                                value,
                            )
                        }
                    },
            didSubmit =
                mapOf(
                    "didSubmitDocumentVerificationJob" to { it.didSubmitDocumentVerificationJob },
                ),
            createResult = { fileValues, fileListValues, booleanValues, _ ->
                SmileIDCaptureResult.DocumentCaptureResult.DocumentVerification(
                    selfieFile = fileValues["selfieFile"],
                    livenessFiles = fileListValues["livenessFiles"],
                    documentFrontFile = fileValues["documentFrontFile"],
                    documentBackFile = fileValues["documentBackFile"],
                    didSubmitDocumentVerificationJob = booleanValues["didSubmitDocumentVerificationJob"],
                )
            },
        )

    // Enhanced Document Verification adapter
    val enhancedDocumentAdapter =
        SmileIDResultsAdapter.create(
            singleCapture =
                documentFileFields
                    .mapKeys { it.key }
                    .mapValues { entry ->
                        {
                            value:
                                SmileIDCaptureResult.DocumentCaptureResult.EnhancedDocumentVerification,
                            ->
                            entry.value(
                                value,
                            )
                        }
                    },
            livenessImages =
                commonFileListFields
                    .mapKeys { it.key }
                    .mapValues { entry ->
                        {
                            value:
                                SmileIDCaptureResult.DocumentCaptureResult.EnhancedDocumentVerification,
                            ->
                            entry.value(
                                value,
                            )
                        }
                    },
            didSubmit =
                mapOf(
                    "didSubmitEnhancedDocVJob" to { it.didSubmitEnhancedDocVJob },
                ),
            createResult = { fileValues, fileListValues, booleanValues, _ ->
                SmileIDCaptureResult.DocumentCaptureResult.EnhancedDocumentVerification(
                    selfieFile = fileValues["selfieFile"],
                    livenessFiles = fileListValues["livenessFiles"],
                    documentFrontFile = fileValues["documentFrontFile"],
                    documentBackFile = fileValues["documentBackFile"],
                    didSubmitEnhancedDocVJob = booleanValues["didSubmitEnhancedDocVJob"],
                )
            },
        )

    // Biometric KYC adapter
    val biometricKycAdapter =
        SmileIDResultsAdapter.create(
            singleCapture =
                commonFileFields
                    .mapKeys { it.key }
                    .mapValues { entry ->
                        { value: SmileIDCaptureResult.BiometricKYC -> entry.value(value) }
                    },
            livenessImages =
                commonFileListFields
                    .mapKeys { it.key }
                    .mapValues { entry ->
                        { value: SmileIDCaptureResult.BiometricKYC -> entry.value(value) }
                    },
            didSubmit =
                mapOf(
                    "didSubmitBiometricKycJob" to { it.didSubmitBiometricKycJob },
                ),
            createResult = { fileValues, fileListValues, booleanValues, _ ->
                SmileIDCaptureResult.BiometricKYC(
                    selfieFile = fileValues["selfieFile"],
                    livenessFiles = fileListValues["livenessFiles"],
                    didSubmitBiometricKycJob = booleanValues["didSubmitBiometricKycJob"],
                )
            },
        )
}
