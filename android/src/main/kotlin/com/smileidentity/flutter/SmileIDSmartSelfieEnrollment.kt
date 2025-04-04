package com.smileidentity.flutter

import SmartSelfieCaptureResult
import SmileIDProductsResultApi
import android.content.Context
import androidx.compose.runtime.Composable
import com.smileidentity.SmileID
import com.smileidentity.compose.SmartSelfieEnrollment
import com.smileidentity.results.SmileIDResult
import com.smileidentity.util.randomUserId
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import kotlinx.collections.immutable.toImmutableMap

internal class SmileIDSmartSelfieEnrollment private constructor(
    context: Context,
    viewId: Int,
    messenger: BinaryMessenger,
    args: Map<String, Any?>,
    private val api: SmileIDProductsResultApi,
) : SmileComposablePlatformView(context, VIEW_TYPE_ID, viewId, messenger, args) {
    companion object {
        const val VIEW_TYPE_ID = "SmileIDSmartSelfieEnrollment"
    }

    @Composable
    override fun Content(args: Map<String, Any?>) {
        val extraPartnerParams = args["extraPartnerParams"] as? Map<String, String> ?: emptyMap()
        SmileID.SmartSelfieEnrollment(
            userId = args["userId"] as? String ?: randomUserId(),
            allowNewEnroll = args["allowNewEnroll"] as? Boolean ?: false,
            allowAgentMode = args["allowAgentMode"] as? Boolean ?: false,
            showAttribution = args["showAttribution"] as? Boolean ?: true,
            showInstructions = args["showInstructions"] as? Boolean ?: true,
            skipApiSubmission = args["skipApiSubmission"] as? Boolean ?: false,
            extraPartnerParams = extraPartnerParams.toImmutableMap(),
        ) {
            when (it) {
                is SmileIDResult.Success -> {
                    val result =
                        SmartSelfieCaptureResult(
                            selfieFile = it.data.selfieFile.absolutePath,
                            livenessFiles = it.data.livenessFiles.pathList(),
                            apiResponse = it.data.apiResponse?.toMap(),
                        )
                    api.onSmartSelfieEnrollmentResult(
                        successResultArg = result,
                        errorResultArg = null,
                    ) {
                    }
                }

                is SmileIDResult.Error ->
                    api.onSmartSelfieEnrollmentResult(
                        successResultArg = null,
                        errorResultArg =
                            it.throwable.message
                                ?: "Unknown error with Smart Selfie Enrollment",
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
            return SmileIDSmartSelfieEnrollment(
                context,
                viewId,
                messenger,
                args as Map<String, Any?>,
                api,
            )
        }
    }
}
