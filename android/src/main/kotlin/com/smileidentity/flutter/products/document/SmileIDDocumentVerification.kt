package com.smileidentity.flutter.products.document

import DocumentCaptureResult
import SmileIDProductsResultApi
import android.content.Context
import androidx.compose.runtime.Composable
import com.smileidentity.SmileID
import com.smileidentity.compose.DocumentVerification
import com.smileidentity.flutter.mapper.pathList
import com.smileidentity.flutter.views.SmileIDPlatformView
import com.smileidentity.flutter.views.SmileIDViewFactory
import com.smileidentity.results.SmileIDResult
import io.flutter.plugin.platform.PlatformViewFactory
import java.io.File
import kotlinx.collections.immutable.toImmutableMap

internal class SmileIDDocumentVerification private constructor(
    context: Context,
    args: Map<String, Any?>,
    api: SmileIDProductsResultApi,
) : SmileIDPlatformView(context, args, api) {
    companion object {
        const val VIEW_TYPE_ID = "SmileIDDocumentVerification"

        fun createFactory(api: SmileIDProductsResultApi): PlatformViewFactory =
            SmileIDViewFactory(api) { context, args, resultApi ->
                SmileIDDocumentVerification(context, args, resultApi)
            }
    }

    @Composable
    override fun Content(args: Map<String, Any?>) {
        SmileID.DocumentVerification(
            countryCode = args["countryCode"] as String,
            documentType = args["documentType"] as? String,
            idAspectRatio = (args["idAspectRatio"] as Double?)?.toFloat(),
            captureBothSides = getBoolean(args, "captureBothSides", true),
            bypassSelfieCaptureWithFile = (args["bypassSelfieCaptureWithFile"] as? String)?.let {
                File(it)
            },
            userId = getUserId(args),
            jobId = getJobId(args),
            allowNewEnroll = getBoolean(args, "allowNewEnroll", false),
            showAttribution = getBoolean(args, "showAttribution", true),
            allowAgentMode = getBoolean(args, "allowAgentMode", false),
            allowGalleryUpload = getBoolean(args, "allowGalleryUpload", false),
            showInstructions = getBoolean(args, "showInstructions", true),
            useStrictMode = getBoolean(args, "useStrictMode", false),
            extraPartnerParams = getExtraPartnerParams(args).toImmutableMap(),
        ) {
            when (it) {
                is SmileIDResult.Success -> {
                    val result = DocumentCaptureResult(
                        selfieFile = it.data.selfieFile.absolutePath,
                        documentFrontFile = it.data.documentFrontFile.absolutePath,
                        livenessFiles = it.data.livenessFiles?.pathList(),
                        documentBackFile = it.data.documentBackFile?.absolutePath,
                        didSubmitDocumentVerificationJob = it.data.didSubmitDocumentVerificationJob,
                    )
                    api.onDocumentVerificationResult(
                        successResultArg = result,
                        errorResultArg = null,
                    ) {}
                }

                is SmileIDResult.Error -> api.onDocumentVerificationResult(
                    successResultArg = null,
                    errorResultArg = it.throwable.message
                        ?: "Unknown error with Document Verification",
                ) {}
            }
        }
    }
}
