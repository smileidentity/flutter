package com.smileidentity.flutter

import BiometricKYCCaptureResult
import BiometricKYCCreationParams
import DocumentCaptureCreationParams
import DocumentCaptureResult
import DocumentVerificationCreationParams
import DocumentVerificationEnhancedCreationParams
import SelfieCaptureViewCreationParams
import SmartSelfieCaptureResult
import SmartSelfieCreationParams
import SmartSelfieEnhancedCreationParams
import SmileFlutterError
import SmileIDProductsApi
import android.app.Activity
import android.content.Intent
import android.os.Bundle
import com.smileidentity.flutter.products.biometric.SmileIDBiometricKYCActivity
import com.smileidentity.flutter.products.document.SmileIDDocumentVerificationActivity
import com.smileidentity.flutter.products.enhanceddocv.SmileIDEnhancedDocumentVerificationActivity
import com.smileidentity.flutter.products.enhancedselfie.SmileIDSmartSelfieAuthenticationEnhancedActivity
import com.smileidentity.flutter.products.enhancedselfie.SmileIDSmartSelfieEnrollmentEnhancedActivity
import com.smileidentity.flutter.products.selfie.SmileIDSmartSelfieAuthenticationActivity
import com.smileidentity.flutter.products.selfie.SmileIDSmartSelfieEnrollmentActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener

class SmileIDProductsPluginApi :
    ActivityResultListener,
    SmileIDProductsApi {
    private var activity: Activity? = null
    private var smartSelfieResult: ((Result<SmartSelfieCaptureResult>) -> Unit)? = null
    private var documentCaptureResult: ((Result<DocumentCaptureResult>) -> Unit)? = null
    private var biometricKycResult: ((Result<BiometricKYCCaptureResult>) -> Unit)? = null

    fun onAttachActivity(activity: Activity?) {
        this.activity = activity
    }

    fun onAttachedToEngine(binding: FlutterPluginBinding) {
        SmileIDProductsApi.setUp(binding.binaryMessenger, this)
    }

    fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        SmileIDProductsApi.setUp(binding.binaryMessenger, null)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        when (requestCode) {
            SmileIDSmartSelfieEnrollmentActivity.REQUEST_CODE -> {
                smartSelfieResult?.let { resultCallback ->
                    handleSelfieResult(
                        resultCode,
                        data,
                        SmileIDSmartSelfieEnrollmentActivity.REQUEST_CODE.toString(),
                        resultCallback,
                    )

                    smartSelfieResult = null
                    return true
                }

                return false
            }

            SmileIDSmartSelfieAuthenticationActivity.REQUEST_CODE -> {
                smartSelfieResult?.let { resultCallback ->
                    handleSelfieResult(
                        resultCode,
                        data,
                        SmileIDSmartSelfieAuthenticationActivity.REQUEST_CODE.toString(),
                        resultCallback,
                    )

                    smartSelfieResult = null
                    return true
                }

                return false
            }

            SmileIDSmartSelfieEnrollmentEnhancedActivity.REQUEST_CODE -> {
                smartSelfieResult?.let { resultCallback ->
                    handleSelfieResult(
                        resultCode,
                        data,
                        SmileIDSmartSelfieEnrollmentEnhancedActivity.REQUEST_CODE.toString(),
                        resultCallback,
                    )

                    smartSelfieResult = null
                    return true
                }

                return false
            }

            SmileIDSmartSelfieAuthenticationEnhancedActivity.REQUEST_CODE -> {
                smartSelfieResult?.let { resultCallback ->
                    handleSelfieResult(
                        resultCode,
                        data,
                        SmileIDSmartSelfieAuthenticationEnhancedActivity.REQUEST_CODE.toString(),
                        resultCallback,
                    )

                    smartSelfieResult = null
                    return true
                }

                return false
            }

//            SmileIDSelfieCaptureActivity.REQUEST_CODE -> {
//                smartSelfieResult?.let { resultCallback ->
//                    handleSelfieResult(
//                        resultCode,
//                        data,
//                        SmileIDSelfieCaptureActivity.REQUEST_CODE.toString(),
//                        resultCallback,
//                    )
//
//                    smartSelfieResult = null
//                    return true
//                }
//
//                return false
//            }

            SmileIDDocumentVerificationActivity.REQUEST_CODE -> {
                documentCaptureResult?.let { resultCallback ->
                    handleDocumentResult(
                        resultCode,
                        data,
                        SmileIDDocumentVerificationActivity.REQUEST_CODE.toString(),
                        resultCallback,
                    )

                    documentCaptureResult = null
                    return true
                }

                return false
            }

            SmileIDEnhancedDocumentVerificationActivity.REQUEST_CODE -> {
                documentCaptureResult?.let { resultCallback ->
                    handleDocumentResult(
                        resultCode,
                        data,
                        SmileIDEnhancedDocumentVerificationActivity.REQUEST_CODE.toString(),
                        resultCallback,
                    )

                    documentCaptureResult = null
                    return true
                }

                return false
            }

//            SmileIDDocumentCaptureActivity.REQUEST_CODE -> {
//                documentCaptureResult?.let { resultCallback ->
//                    handleDocumentResult(
//                        resultCode,
//                        data,
//                        SmileIDDocumentCaptureActivity.REQUEST_CODE.toString(),
//                        resultCallback,
//                    )
//
//                    documentCaptureResult = null
//                    return true
//                }
//
//                return false
//            }

            SmileIDBiometricKYCActivity.REQUEST_CODE -> {
                biometricKycResult?.let { resultCallback ->
                    val errorCode = SmileIDBiometricKYCActivity.REQUEST_CODE.toString()
                    when (resultCode) {
                        Activity.RESULT_OK -> {
                            val result =
                                BiometricKYCCaptureResult(
                                    selfieFile = data?.getStringExtra("selfieFile") ?: "",
                                    livenessFiles =
                                    data?.getStringArrayListExtra("livenessFiles")
                                        ?: emptyList(),
                                    didSubmitBiometricKycJob =
                                    data?.getBooleanExtra(
                                        "didSubmitBiometricKycJob",
                                        false,
                                    ),
                                )

                            resultCallback.invoke(Result.success(result))
                        }

                        Activity.RESULT_CANCELED -> {
                            val error = data?.getStringExtra("error") ?: "Unknown error"
                            resultCallback.invoke(
                                Result.failure(
                                    SmileFlutterError(
                                        errorCode,
                                        message = error,
                                    ),
                                ),
                            )
                        }

                        else -> {
                            resultCallback(
                                Result.failure(
                                    SmileFlutterError(
                                        errorCode,
                                        message = "User cancelled operation",
                                    ),
                                ),
                            )
                        }
                    }

                    biometricKycResult = null
                    return true
                }

                return false
            }

            else -> {
                return false
            }
        }
    }

    override fun documentVerification(
        creationParams: DocumentVerificationCreationParams,
        callback: (Result<DocumentCaptureResult>) -> Unit,
    ) {
        val intent = Intent(activity, SmileIDDocumentVerificationActivity::class.java)
        intent.putExtra("countryCode", creationParams.countryCode)
        intent.putExtra("documentType", creationParams.documentType)
        intent.putExtra("idAspectRatio", creationParams.idAspectRatio)
        intent.putExtra("captureBothSides", creationParams.captureBothSides)
        intent.putExtra("bypassSelfieCaptureWithFile", creationParams.bypassSelfieCaptureWithFile)
        intent.putExtra("userId", creationParams.userId)
        intent.putExtra("jobId", creationParams.jobId)
        intent.putExtra("allowNewEnroll", creationParams.allowNewEnroll)
        intent.putExtra("showAttribution", creationParams.showAttribution)
        intent.putExtra("allowAgentMode", creationParams.allowAgentMode)
        intent.putExtra("allowGalleryUpload", creationParams.allowGalleryUpload)
        intent.putExtra("showInstructions", creationParams.showInstructions)
        intent.putExtra("skipApiSubmission", creationParams.skipApiSubmission)
        intent.putExtra(
            "extraPartnerParams",
            Bundle().apply {
                creationParams.extraPartnerParams?.forEach { (key, value) ->
                    putString(key, value)
                }
            },
        )

        if (activity != null) {
            documentCaptureResult = callback
            activity!!.startActivityForResult(
                intent,
                SmileIDDocumentVerificationActivity.REQUEST_CODE,
            )
        } else {
            callback(
                Result.failure(
                    SmileFlutterError(
                        SmileIDDocumentVerificationActivity.REQUEST_CODE.toString(),
                        "Failed to start document verification",
                    ),
                ),
            )
        }
    }

    override fun documentVerificationEnhanced(
        creationParams: DocumentVerificationEnhancedCreationParams,
        callback: (Result<DocumentCaptureResult>) -> Unit,
    ) {
        val intent = Intent(activity, SmileIDEnhancedDocumentVerificationActivity::class.java)
        intent.putExtra("countryCode", creationParams.countryCode)
        intent.putExtra("documentType", creationParams.documentType)
        intent.putExtra("idAspectRatio", creationParams.idAspectRatio)
        intent.putExtra("captureBothSides", creationParams.captureBothSides)
        intent.putExtra("bypassSelfieCaptureWithFile", creationParams.bypassSelfieCaptureWithFile)
        intent.putExtra("userId", creationParams.userId)
        intent.putExtra("jobId", creationParams.jobId)
        intent.putExtra("allowNewEnroll", creationParams.allowNewEnroll)
        intent.putExtra("showAttribution", creationParams.showAttribution)
        intent.putExtra("allowAgentMode", creationParams.allowAgentMode)
        intent.putExtra("allowGalleryUpload", creationParams.allowGalleryUpload)
        intent.putExtra("showInstructions", creationParams.showInstructions)
        intent.putExtra("skipApiSubmission", creationParams.skipApiSubmission)
        intent.putExtra(
            "extraPartnerParams",
            Bundle().apply {
                creationParams.extraPartnerParams?.forEach { (key, value) ->
                    putString(key, value)
                }
            },
        )

        if (activity != null) {
            documentCaptureResult = callback
            activity!!.startActivityForResult(
                intent,
                SmileIDEnhancedDocumentVerificationActivity.REQUEST_CODE,
            )
        } else {
            callback(
                Result.failure(
                    SmileFlutterError(
                        SmileIDEnhancedDocumentVerificationActivity.REQUEST_CODE.toString(),
                        "Failed to start enhanced document verification",
                    ),
                ),
            )
        }
    }

    override fun smartSelfieEnrollment(
        creationParams: SmartSelfieCreationParams,
        callback: (Result<SmartSelfieCaptureResult>) -> Unit,
    ) {
        val intent = Intent(activity, SmileIDSmartSelfieEnrollmentActivity::class.java)
        intent.putSmartSelfieCreationParams(creationParams)

        if (activity != null) {
            smartSelfieResult = callback
            activity!!.startActivityForResult(
                intent,
                SmileIDSmartSelfieEnrollmentActivity.REQUEST_CODE,
            )
        } else {
            callback(
                Result.failure(
                    SmileFlutterError(
                        SmileIDSmartSelfieEnrollmentActivity.REQUEST_CODE.toString(),
                        "Failed to start smart selfie enrollment",
                    ),
                ),
            )
        }
    }

    override fun smartSelfieAuthentication(
        creationParams: SmartSelfieCreationParams,
        callback: (Result<SmartSelfieCaptureResult>) -> Unit,
    ) {
        val intent = Intent(activity, SmileIDSmartSelfieAuthenticationActivity::class.java)
        intent.putSmartSelfieCreationParams(creationParams)

        if (activity != null) {
            smartSelfieResult = callback
            activity!!.startActivityForResult(
                intent,
                SmileIDSmartSelfieAuthenticationActivity.REQUEST_CODE,
            )
        } else {
            callback(
                Result.failure(
                    SmileFlutterError(
                        SmileIDSmartSelfieAuthenticationActivity.REQUEST_CODE.toString(),
                        "Failed to start smart selfie authentication",
                    ),
                ),
            )
        }
    }

    override fun smartSelfieEnrollmentEnhanced(
        creationParams: SmartSelfieEnhancedCreationParams,
        callback: (Result<SmartSelfieCaptureResult>) -> Unit,
    ) {
        val intent = Intent(activity, SmileIDSmartSelfieEnrollmentEnhancedActivity::class.java)
        intent.putSmartSelfieEnhancedCreationParams(creationParams)

        if (activity != null) {
            smartSelfieResult = callback
            activity!!.startActivityForResult(
                intent,
                SmileIDSmartSelfieEnrollmentEnhancedActivity.REQUEST_CODE,
            )
        } else {
            callback(
                Result.failure(
                    SmileFlutterError(
                        SmileIDSmartSelfieEnrollmentEnhancedActivity.REQUEST_CODE.toString(),
                        "Failed to start smart selfie enrollment enhanced",
                    ),
                ),
            )
        }
    }

    override fun smartSelfieAuthenticationEnhanced(
        creationParams: SmartSelfieEnhancedCreationParams,
        callback: (Result<SmartSelfieCaptureResult>) -> Unit,
    ) {
        val intent = Intent(activity, SmileIDSmartSelfieAuthenticationEnhancedActivity::class.java)
        intent.putSmartSelfieEnhancedCreationParams(creationParams)

        if (activity != null) {
            smartSelfieResult = callback
            activity?.startActivityForResult(
                intent,
                SmileIDSmartSelfieAuthenticationEnhancedActivity.REQUEST_CODE,
            )
        } else {
            callback(
                Result.failure(
                    SmileFlutterError(
                        SmileIDSmartSelfieAuthenticationEnhancedActivity.REQUEST_CODE.toString(),
                        "Failed to start smart selfie authentication enhanced",
                    ),
                ),
            )
        }
    }

    override fun biometricKYC(
        creationParams: BiometricKYCCreationParams,
        callback: (Result<BiometricKYCCaptureResult>) -> Unit,
    ) {
        val intent = Intent(activity, SmileIDBiometricKYCActivity::class.java)
        intent.putExtra("country", creationParams.country)
        intent.putExtra("idType", creationParams.idType)
        intent.putExtra("idNumber", creationParams.idNumber)
        intent.putExtra("firstName", creationParams.firstName)
        intent.putExtra("middleName", creationParams.middleName)
        intent.putExtra("lastName", creationParams.lastName)
        intent.putExtra("dob", creationParams.dob)
        intent.putExtra("bankCode", creationParams.bankCode)
        intent.putExtra("entered", creationParams.entered)
        intent.putExtra("userId", creationParams.userId)
        intent.putExtra("jobId", creationParams.jobId)
        intent.putExtra("allowNewEnroll", creationParams.allowNewEnroll)
        intent.putExtra("allowAgentMode", creationParams.allowAgentMode)
        intent.putExtra("showAttribution", creationParams.showAttribution)
        intent.putExtra("showInstructions", creationParams.showInstructions)
        intent.putExtra(
            "extraPartnerParams",
            Bundle().apply {
                creationParams.extraPartnerParams?.forEach { (key, value) ->
                    putString(key, value)
                }
            },
        )

        if (activity != null) {
            biometricKycResult = callback
            activity!!.startActivityForResult(intent, SmileIDBiometricKYCActivity.REQUEST_CODE)
        } else {
            callback(
                Result.failure(
                    SmileFlutterError(
                        SmileIDBiometricKYCActivity.REQUEST_CODE.toString(),
                        "Failed to start biometric KYC",
                    ),
                ),
            )
        }
    }

    override fun selfieCapture(
        creationParams: SelfieCaptureViewCreationParams,
        callback: (Result<SmartSelfieCaptureResult>) -> Unit,
    ) {
//        val intent = Intent(activity, SmileIDSelfieCaptureActivity::class.java)
//        intent.putExtra("showConfirmationDialog", creationParams.showConfirmationDialog)
//        intent.putExtra("showInstructions", creationParams.showInstructions)
//        intent.putExtra("showAttribution", creationParams.showAttribution)
//        intent.putExtra("allowAgentMode", creationParams.allowAgentMode)
//
//        if (activity != null) {
//            smartSelfieResult = callback
//            activity!!.startActivityForResult(intent, SmileIDSelfieCaptureActivity.REQUEST_CODE)
//        } else {
//            callback(
//                Result.failure(
//                    SmileFlutterError(
//                        SmileIDSelfieCaptureActivity.REQUEST_CODE.toString(),
//                        "Failed to start selfie capture",
//                    ),
//                ),
//            )
//        }
    }

    override fun documentCapture(
        creationParams: DocumentCaptureCreationParams,
        callback: (Result<DocumentCaptureResult>) -> Unit,
    ) {
//        val intent = Intent(activity, SmileIDDocumentCaptureActivity::class.java)
//        intent.putExtra("isDocumentFrontSide", creationParams.isDocumentFrontSide)
//        intent.putExtra("showInstructions", creationParams.showInstructions)
//        intent.putExtra("showAttribution", creationParams.showAttribution)
//        intent.putExtra("allowGalleryUpload", creationParams.allowGalleryUpload)
//        intent.putExtra("showConfirmationDialog", creationParams.showConfirmationDialog)
//        intent.putExtra("idAspectRatio", creationParams.idAspectRatio)
//
//        if (activity != null) {
//            documentCaptureResult = callback
//            activity!!.startActivityForResult(intent, SmileIDDocumentCaptureActivity.REQUEST_CODE)
//        } else {
//            callback(
//                Result.failure(
//                    SmileFlutterError(
//                        SmileIDDocumentCaptureActivity.REQUEST_CODE.toString(),
//                        "Failed to start document capture",
//                    ),
//                ),
//            )
//        }
    }
}

private fun Intent.putSmartSelfieCreationParams(creationParams: SmartSelfieCreationParams) =
    this.apply {
        putExtra("userId", creationParams.userId)
        putExtra("allowNewEnroll", creationParams.allowNewEnroll)
        putExtra("allowAgentMode", creationParams.allowAgentMode)
        putExtra("showAttribution", creationParams.showAttribution)
        putExtra("showInstructions", creationParams.showInstructions)
        putExtra("skipApiSubmission", creationParams.skipApiSubmission)
        putExtra(
            "extraPartnerParams",
            Bundle().apply {
                creationParams.extraPartnerParams?.forEach { (key, value) ->
                    putString(key, value)
                }
            },
        )
    }

private fun Intent.putSmartSelfieEnhancedCreationParams(
    creationParams: SmartSelfieEnhancedCreationParams,
) = this.apply {
    putExtra("userId", creationParams.userId)
    putExtra("allowNewEnroll", creationParams.allowNewEnroll)
    putExtra("showAttribution", creationParams.showAttribution)
    putExtra("showInstructions", creationParams.showInstructions)
    putExtra(
        "extraPartnerParams",
        Bundle().apply {
            creationParams.extraPartnerParams?.forEach { (key, value) ->
                putString(key, value)
            }
        },
    )
}

private fun handleSelfieResult(
    resultCode: Int,
    data: Intent?,
    errorCode: String,
    resultCallback: (Result<SmartSelfieCaptureResult>) -> Unit,
) {
    when (resultCode) {
        Activity.RESULT_OK -> {
            val apiResponseBundle = data?.getBundleExtra("apiResponse")
            val apiResponse =
                apiResponseBundle?.keySet()?.associateWith {
                    return@associateWith if (apiResponseBundle.getString(it) != null) {
                        apiResponseBundle.getString(it)
                    } else {
                        val newBundle = apiResponseBundle.getBundle(it)
                        newBundle?.keySet()?.associateWith { key ->
                            newBundle.getString(key)
                        }
                    }
                } as Map<String, Any>? ?: emptyMap()

            val result =
                SmartSelfieCaptureResult(
                    selfieFile = data?.getStringExtra("selfieFile") ?: "",
                    livenessFiles =
                    data?.getStringArrayListExtra("livenessFiles")
                        ?: emptyList(),
                    apiResponse = apiResponse,
                )
            resultCallback.invoke(Result.success(result))
        }

        Activity.RESULT_CANCELED -> {
            val error = data?.getStringExtra("error") ?: "Unknown error"
            resultCallback.invoke(Result.failure(SmileFlutterError(errorCode, message = error)))
        }

        else -> {
            resultCallback.invoke(
                Result.failure(
                    SmileFlutterError(
                        errorCode,
                        message = "User cancelled operation",
                    ),
                ),
            )
        }
    }
}

private fun handleDocumentResult(
    resultCode: Int,
    data: Intent?,
    errorCode: String,
    resultCallback: (Result<DocumentCaptureResult>) -> Unit,
) {
    when (resultCode) {
        Activity.RESULT_OK -> {
            val result =
                DocumentCaptureResult(
                    selfieFile = data?.getStringExtra("selfieFile") ?: "",
                    livenessFiles = data?.getStringArrayListExtra("livenessFiles") ?: emptyList(),
                    documentFrontFile = data?.getStringExtra("documentFrontFile") ?: "",
                    documentBackFile = data?.getStringExtra("documentBackFile") ?: "",
                    didSubmitDocumentVerificationJob =
                    if (data?.hasExtra("didSubmitDocumentVerificationJob") == true) {
                        data?.getBooleanExtra(
                            "didSubmitDocumentVerificationJob",
                            false,
                        )
                    } else {
                        null
                    },
                    didSubmitEnhancedDocVJob =
                    if (data?.hasExtra("didSubmitEnhanceDocVJob") == true
                    ) {
                        data.getBooleanExtra("didSubmitEnhanceDocVJob", false)
                    } else {
                        null
                    },
                )

            resultCallback.invoke(Result.success(result))
        }

        Activity.RESULT_CANCELED -> {
            val error = data?.getStringExtra("error") ?: "Unknown error"
            resultCallback.invoke(Result.failure(SmileFlutterError(errorCode, message = error)))
        }

        else -> {
            resultCallback.invoke(
                Result.failure(
                    SmileFlutterError(
                        errorCode,
                        message = "User cancelled operation",
                    ),
                ),
            )
        }
    }
}
