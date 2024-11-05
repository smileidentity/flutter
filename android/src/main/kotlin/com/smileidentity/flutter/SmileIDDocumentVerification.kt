package com.smileidentity.flutter

import android.content.Context
import androidx.compose.runtime.Composable
import com.smileidentity.SmileID
import com.smileidentity.compose.DocumentVerification
import com.smileidentity.flutter.results.DocumentCaptureResult
import com.smileidentity.flutter.utils.DocumentCaptureResultAdapter
import com.smileidentity.results.SmileIDResult
import com.smileidentity.util.randomJobId
import com.smileidentity.util.randomUserId
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import kotlinx.collections.immutable.toImmutableMap
import java.io.File

internal class SmileIDDocumentVerification private constructor(
    context: Context,
    viewId: Int,
    messenger: BinaryMessenger,
    args: Map<String, Any?>,
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
            extraPartnerParams = extraPartnerParams.toImmutableMap(),
        ) {
            when (it) {
                is SmileIDResult.Success -> {
                    val result =
                        DocumentCaptureResult(
                            selfieFile = it.data.selfieFile,
                            documentFrontFile = it.data.documentFrontFile,
                            livenessFiles = it.data.livenessFiles,
                            documentBackFile = it.data.documentBackFile,
                            didSubmitDocumentVerificationJob =
                                it.data.didSubmitDocumentVerificationJob,
                        )
                    val moshi =
                        SmileID.moshi
                            .newBuilder()
                            .add(DocumentCaptureResultAdapter.FACTORY)
                            .build()
                    val json =
                        try {
                            moshi.adapter(DocumentCaptureResult::class.java).toJson(result)
                        } catch (e: Exception) {
                            onError(e)
                            return@DocumentVerification
                        }
                    json?.let { js ->
                        onSuccessJson(js)
                    }
                }

                is SmileIDResult.Error -> onError(it.throwable)
            }
        }
    }

    class Factory(
        private val messenger: BinaryMessenger,
    ) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
        override fun create(
            context: Context,
            viewId: Int,
            args: Any?,
        ): PlatformView {
            @Suppress("UNCHECKED_CAST")
            return SmileIDDocumentVerification(
                context,
                viewId,
                messenger,
                args as Map<String, Any?>,
            )
        }
    }
}
