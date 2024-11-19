package com.smileidentity.flutter

import android.content.Context
import androidx.compose.runtime.Composable
import com.smileidentity.SmileID
import com.smileidentity.compose.SmartSelfieEnrollment
import com.smileidentity.flutter.results.SmartSelfieCaptureResult
import com.smileidentity.flutter.utils.SelfieCaptureResultAdapter
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
                            selfieFile = it.data.selfieFile,
                            livenessFiles = it.data.livenessFiles,
                            apiResponse = it.data.apiResponse,
                        )
                    val moshi =
                        SmileID.moshi
                            .newBuilder()
                            .add(SelfieCaptureResultAdapter.FACTORY)
                            .build()
                    val json =
                        try {
                            moshi
                                .adapter(SmartSelfieCaptureResult::class.java)
                                .toJson(result)
                        } catch (e: Exception) {
                            onError(e)
                            return@SmartSelfieEnrollment
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
            return SmileIDSmartSelfieEnrollment(
                context,
                viewId,
                messenger,
                args as Map<String, Any?>,
            )
        }
    }
}
