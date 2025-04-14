package com.smileidentity.flutter

import BiometricKYCCaptureResult
import SmileIDProductsResultApi
import android.content.Context
import androidx.compose.runtime.Composable
import com.smileidentity.SmileID
import com.smileidentity.compose.BiometricKYC
import com.smileidentity.flutter.utils.getCurrentIsoTimestamp
import com.smileidentity.models.ConsentInformation
import com.smileidentity.models.IdInfo
import com.smileidentity.results.SmileIDResult
import com.smileidentity.util.randomJobId
import com.smileidentity.util.randomUserId
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import kotlinx.collections.immutable.toImmutableMap

internal class SmileIDBiometricKYC private constructor(
    context: Context,
    viewId: Int,
    messenger: BinaryMessenger,
    args: Map<String, Any?>,
    private val api: SmileIDProductsResultApi,
) : SmileComposablePlatformView(context, VIEW_TYPE_ID, viewId, messenger, args) {
    companion object {
        const val VIEW_TYPE_ID = "SmileIDBiometricKYC"
    }

    @Composable
    override fun Content(args: Map<String, Any?>) {
        val extraPartnerParams = args["extraPartnerParams"] as? Map<String, String> ?: emptyMap()
        SmileID.BiometricKYC(
            idInfo =
            IdInfo(
                country = args["country"] as? String ?: "",
                idType = args["idType"] as? String?,
                idNumber = args["idNumber"] as? String?,
                firstName = args["firstName"] as? String?,
                middleName = args["middleName"] as? String?,
                lastName = args["lastName"] as? String?,
                dob = args["dob"] as? String?,
                bankCode = args["bankCode"] as? String?,
                entered = args["entered"] as? Boolean?,
            ),
            consentInformation =
            ConsentInformation(
                consentGrantedDate =
                args["consentGrantedDate"] as? String ?: getCurrentIsoTimestamp(),
                personalDetailsConsentGranted =
                args["personalDetailsConsentGranted"] as? Boolean
                    ?: false,
                contactInfoConsentGranted =
                args["contactInfoConsentGranted"] as? Boolean ?: false,
                documentInfoConsentGranted =
                args["documentInfoConsentGranted"] as? Boolean
                    ?: false,
            ),
            userId = args["userId"] as? String ?: randomUserId(),
            jobId = args["jobId"] as? String ?: randomJobId(),
            allowNewEnroll = args["allowNewEnroll"] as? Boolean ?: false,
            allowAgentMode = args["allowAgentMode"] as? Boolean ?: false,
            showAttribution = args["showAttribution"] as? Boolean ?: true,
            showInstructions = args["showInstructions"] as? Boolean ?: true,
            useStrictMode = args["useStrictMode"] as? Boolean ?: true,
            extraPartnerParams = extraPartnerParams.toImmutableMap(),
        ) {
            when (it) {
                is SmileIDResult.Success -> {
                    val result = BiometricKYCCaptureResult(
                        selfieFile = it.data.selfieFile.absolutePath,
                        livenessFiles = it.data.livenessFiles.pathList(),
                        didSubmitBiometricKycJob = it.data.didSubmitBiometricKycJob,
                    )

                    api.onBiometricKYCResult(successResultArg = result, errorResultArg = null) {}
                }

                is SmileIDResult.Error -> api.onBiometricKYCResult(
                    successResultArg = null,
                    errorResultArg = it.throwable.message ?: "Unknown error with Biometric KYC",
                ) {}
            }
        }
    }

    class Factory(
        private val messenger: BinaryMessenger,
        private val api: SmileIDProductsResultApi,
    ) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
        override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
            @Suppress("UNCHECKED_CAST")
            return SmileIDBiometricKYC(
                context,
                viewId,
                messenger,
                args as Map<String, Any?>,
                api,
            )
        }
    }
}
