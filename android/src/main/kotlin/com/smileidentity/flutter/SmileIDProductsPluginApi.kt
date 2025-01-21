package com.smileidentity.flutter

import SmartSelfieCaptureResult
import SmartSelfieCreationParams
import SmartSelfieEnhancedCreationParams
import SmileFlutterError
import SmileIDProductsApi
import android.app.Activity
import android.content.Intent
import android.os.Bundle
import com.smileidentity.flutter.enhanced.SmileIDSmartSelfieAuthenticationEnhancedActivity
import com.smileidentity.flutter.enhanced.SmileIDSmartSelfieEnrollmentEnhancedActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener

class SmileIDProductsPluginApi :
    ActivityResultListener,
    SmileIDProductsApi {
    private var activity: Activity? = null
    private var smartSelfieResult: ((Result<SmartSelfieCaptureResult>) -> Unit)? = null

    fun onAttachActivity(activity: Activity?) {
        this.activity = activity
    }

    fun onAttachedToEngine(binding: FlutterPluginBinding) {
        SmileIDProductsApi.setUp(binding.binaryMessenger, this)
    }

    fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        SmileIDProductsApi.setUp(binding.binaryMessenger, null)
    }

    override fun onActivityResult(
        requestCode: Int,
        resultCode: Int,
        data: Intent?,
    ): Boolean {
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

            else -> {
                return false
            }
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
        } else
            callback(
                Result.failure(
                    SmileFlutterError(
                        SmileIDSmartSelfieEnrollmentActivity.REQUEST_CODE.toString(),
                        "Failed to start smart selfie enrollment",
                    ),
                ),
            )
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
        } else
            callback(
                Result.failure(
                    SmileFlutterError(
                        SmileIDSmartSelfieAuthenticationActivity.REQUEST_CODE.toString(),
                        "Failed to start smart selfie authentication",
                    ),
                ),
            )
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
        } else
            callback(
                Result.failure(
                    SmileFlutterError(
                        SmileIDSmartSelfieEnrollmentEnhancedActivity.REQUEST_CODE.toString(),
                        "Failed to start smart selfie enrollment enhanced",
                    ),
                ),
            )
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
        } else
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
