package com.smileidentity.flutter.products.biometric

import BiometricKYCCaptureResult
import SmileIDProductsResultApi
import android.content.Context
import androidx.compose.runtime.Composable
import com.smileidentity.SmileID
import com.smileidentity.compose.BiometricKYC
import com.smileidentity.flutter.mapper.pathList
import com.smileidentity.flutter.utils.getCurrentIsoTimestamp
import com.smileidentity.flutter.views.SmileIDPlatformView
import com.smileidentity.flutter.views.SmileIDViewFactory
import com.smileidentity.models.ConsentInformation
import com.smileidentity.models.IdInfo
import com.smileidentity.results.SmileIDResult
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformViewFactory
import kotlinx.collections.immutable.toImmutableMap

internal class SmileIDBiometricKYC private constructor(
    context: Context,
    viewId: Int,
    messenger: BinaryMessenger,
    args: Map<String, Any?>,
    api: SmileIDProductsResultApi,
) : SmileIDPlatformView(context, VIEW_TYPE_ID, viewId, messenger, args, api) {
    companion object {
        const val VIEW_TYPE_ID = "SmileIDBiometricKYC"

        fun createFactory(
            messenger: BinaryMessenger,
            api: SmileIDProductsResultApi,
        ): PlatformViewFactory {
            return SmileIDViewFactory(messenger, api) { context, viewId, msgr, args, resultApi ->
                SmileIDBiometricKYC(context, viewId, msgr, args, resultApi)
            }
        }
    }

    @Composable
    override fun Content(args: Map<String, Any?>) {
        SmileID.BiometricKYC(
            idInfo = IdInfo(
                country = getString(args, "country"),
                idType = args["idType"] as? String?,
                idNumber = args["idNumber"] as? String?,
                firstName = args["firstName"] as? String?,
                middleName = args["middleName"] as? String?,
                lastName = args["lastName"] as? String?,
                dob = args["dob"] as? String?,
                bankCode = args["bankCode"] as? String?,
                entered = args["entered"] as? Boolean?,
            ),
            consentInformation = ConsentInformation(
                consentGrantedDate = getString(
                    args,
                    "consentGrantedDate",
                    getCurrentIsoTimestamp(),
                ),
                personalDetailsConsentGranted = getBoolean(
                    args,
                    "personalDetailsConsentGranted",
                    false,
                ),
                contactInfoConsentGranted = getBoolean(args, "contactInfoConsentGranted", false),
                documentInfoConsentGranted = getBoolean(args, "documentInfoConsentGranted", false),
            ),
            userId = getUserId(args),
            jobId = getJobId(args),
            allowNewEnroll = getBoolean(args, "allowNewEnroll", false),
            allowAgentMode = getBoolean(args, "allowAgentMode", false),
            showAttribution = getBoolean(args, "showAttribution", true),
            showInstructions = getBoolean(args, "showInstructions", true),
            useStrictMode = getBoolean(args, "useStrictMode", true),
            extraPartnerParams = getExtraPartnerParams(args).toImmutableMap(),
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
}
