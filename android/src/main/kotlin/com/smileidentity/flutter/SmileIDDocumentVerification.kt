package com.smileidentity.flutter

import DocumentCaptureResult
import SmileIDProductsResultApi
import android.content.Context
import androidx.compose.runtime.Composable
import com.smileidentity.SmileID
import com.smileidentity.compose.DocumentVerification
import com.smileidentity.results.SmileIDResult
import com.smileidentity.util.randomJobId
import com.smileidentity.util.randomUserId
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import java.io.File
import kotlinx.collections.immutable.toImmutableMap

internal class SmileIDDocumentVerification private constructor(
    context: Context,
    viewId: Int,
    messenger: BinaryMessenger,
    args: Map<String, Any?>,
    private val api: SmileIDProductsResultApi,
) : SmileComposablePlatformView(context, VIEW_TYPE_ID, viewId, messenger, args) {
    companion object {
        const val VIEW_TYPE_ID = "SmileIDDocumentVerification"
    }

    @Composable
    override fun Content(args: Map<String, Any?>) {
        val extraPartnerParams = args["extraPartnerParams"] as? Map<String, String> ?: emptyMap()
        SmileID.DocumentVerification(
            countryCode = args["countryCode"] as String,
            documentType = args["documentType"] as? String,
            idAspectRatio = (args["idAspectRatio"] as Double?)?.toFloat(),
            captureBothSides = args["captureBothSides"] as? Boolean ?: true,
            bypassSelfieCaptureWithFile =
            (args["bypassSelfieCaptureWithFile"] as? String)?.let {
                File(it)
            },
            userId = args["userId"] as? String ?: randomUserId(),
            jobId = args["jobId"] as? String ?: randomJobId(),
            allowNewEnroll = args["allowNewEnroll"] as? Boolean ?: false,
            showAttribution = args["showAttribution"] as? Boolean ?: true,
            allowAgentMode = args["allowAgentMode"] as? Boolean ?: false,
            allowGalleryUpload = args["allowGalleryUpload"] as? Boolean ?: false,
            showInstructions = args["showInstructions"] as? Boolean ?: true,
            useStrictMode = args["useStrictMode"] as? Boolean ?: false,
            extraPartnerParams = extraPartnerParams.toImmutableMap(),
        ) {
            when (it) {
                is SmileIDResult.Success -> {
                    val result =
                        DocumentCaptureResult(
                            selfieFile = it.data.selfieFile.absolutePath,
                            documentFrontFile = it.data.documentFrontFile.absolutePath,
                            livenessFiles = it.data.livenessFiles?.pathList(),
                            documentBackFile = it.data.documentBackFile?.absolutePath,
                            didSubmitDocumentVerificationJob =
                            it.data.didSubmitDocumentVerificationJob,
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

    class Factory(
        private val messenger: BinaryMessenger,
        private val api: SmileIDProductsResultApi,
    ) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
        override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
            @Suppress("UNCHECKED_CAST")
            return SmileIDDocumentVerification(
                context,
                viewId,
                messenger,
                args as Map<String, Any?>,
                api,
            )
        }
    }
}
