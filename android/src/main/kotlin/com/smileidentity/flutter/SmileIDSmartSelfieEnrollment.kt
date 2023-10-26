package com.smileidentity.flutter

import android.content.Context
import androidx.compose.runtime.Composable
import com.smileidentity.SmileID
import com.smileidentity.compose.SmartSelfieEnrollment
import com.smileidentity.results.SmileIDResult
import com.smileidentity.util.randomJobId
import com.smileidentity.util.randomUserId
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

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
        SmileID.SmartSelfieEnrollment(
            userId = args["userId"] as? String ?: randomUserId(),
            jobId = args["jobId"] as? String ?: randomJobId(),
            allowAgentMode = args["allowAgentMode"] as? Boolean ?: false,
            showAttribution = args["showAttribution"] as? Boolean ?: true,
            showInstructions = args["showInstructions"] as? Boolean ?: true,
        ) {
            when (it) {
                is SmileIDResult.Success -> onSuccess(it.data)
                is SmileIDResult.Error -> onError(it.throwable)
            }
        }
    }

    class Factory(
        private val messenger: BinaryMessenger,
    ) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
        override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
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
