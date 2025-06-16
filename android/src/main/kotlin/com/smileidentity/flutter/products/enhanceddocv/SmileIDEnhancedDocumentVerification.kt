package com.smileidentity.flutter.products.enhanceddocv

import DocumentCaptureResult
import SmileIDProductsResultApi
import android.content.Context
import androidx.compose.runtime.Composable
import com.smileidentity.SmileID
import com.smileidentity.compose.EnhancedDocumentVerificationScreen
import com.smileidentity.flutter.mapper.pathList
import com.smileidentity.flutter.utils.getCurrentIsoTimestamp
import com.smileidentity.flutter.views.SmileIDPlatformView
import com.smileidentity.flutter.views.SmileIDViewFactory
import com.smileidentity.models.ConsentInformation
import com.smileidentity.results.SmileIDResult
import io.flutter.plugin.platform.PlatformViewFactory
import kotlinx.collections.immutable.toImmutableMap

internal class SmileIDEnhancedDocumentVerification private constructor(
    context: Context,
    args: Map<String, Any?>,
    api: SmileIDProductsResultApi,
) : SmileIDPlatformView(context, args, api) {
    companion object {
        const val VIEW_TYPE_ID = "SmileIDEnhancedDocumentVerification"

        fun createFactory(api: SmileIDProductsResultApi): PlatformViewFactory =
            SmileIDViewFactory(api) { context, args, resultApi ->
                SmileIDEnhancedDocumentVerification(context, args, resultApi)
            }
    }

    @Composable
    override fun Content(args: Map<String, Any?>) {
        SmileID.EnhancedDocumentVerificationScreen(
            countryCode = args["countryCode"] as String,
            documentType = args["documentType"] as? String,
            idAspectRatio = (args["idAspectRatio"] as Double?)?.toFloat(),
            captureBothSides = getBoolean(args, "captureBothSides", true),
            userId = getUserId(args),
            jobId = getJobId(args),
            allowNewEnroll = getBoolean(args, "allowNewEnroll", false),
            showAttribution = getBoolean(args, "showAttribution", true),
            allowAgentMode = getBoolean(args, "allowAgentMode", false),
            allowGalleryUpload = getBoolean(args, "allowGalleryUpload", false),
            showInstructions = getBoolean(args, "showInstructions", true),
            useStrictMode = getBoolean(args, "useStrictMode", false),
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
            extraPartnerParams = getExtraPartnerParams(args).toImmutableMap(),
        ) {
            when (it) {
                is SmileIDResult.Success -> {
                    val result = DocumentCaptureResult(
                        selfieFile = it.data.selfieFile.absolutePath,
                        documentFrontFile = it.data.documentFrontFile.absolutePath,
                        livenessFiles = it.data.livenessFiles?.pathList(),
                        documentBackFile = it.data.documentBackFile?.absolutePath,
                        didSubmitEnhancedDocVJob = it.data.didSubmitEnhancedDocVJob,
                    )

                    api.onDocumentVerificationEnhancedResult(
                        successResultArg = result,
                        errorResultArg = null,
                    ) {}
                }

                is SmileIDResult.Error -> api.onDocumentVerificationEnhancedResult(
                    successResultArg = null,
                    errorResultArg = it.throwable.message
                        ?: "Unknown error with Enhanced Document Verification",
                ) {}
            }
        }
    }
}
