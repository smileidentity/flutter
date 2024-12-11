package com.smileidentity.flutter.v2

import android.content.Context
import androidx.compose.runtime.Composable
import com.smileidentity.SmileID
import com.smileidentity.flutter.SmileComposablePlatformView
import com.smileidentity.results.SmileIDResult
import com.smileidentity.util.randomUserId
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import kotlinx.collections.immutable.toImmutableMap

internal class SmileIDSmartSelfieEnrollmentV2 private constructor(
    context: Context,
    viewId: Int,
    messenger: BinaryMessenger,
    args: Map<String, Any?>,
) : SmileComposablePlatformView(context, VIEW_TYPE_ID, viewId, messenger, args) {
    companion object {
        const val VIEW_TYPE_ID = "SmileIDSmartSelfieEnrollmentV2"
    }

    @Composable
    override fun Content(args: Map<String, Any?>) {
        val extraPartnerParams = args["extraPartnerParams"] as? Map<String, String> ?: emptyMap()
        SmileID.SmartSelfieEnrollmentV2(
            userId = args["userId"] as? String ?: randomUserId(),
            allowNewEnroll = args["allowNewEnroll"] as? Boolean ?: false,
            showAttribution = args["showAttribution"] as? Boolean ?: true,
            showInstructions = args["showInstructions"] as? Boolean ?: true,
            extraPartnerParams = extraPartnerParams.toImmutableMap(),
        ) {
            when (it) {
                is SmileIDResult.Success -> {
                    // todo
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
            return SmileIDSmartSelfieEnrollmentV2(
                context,
                viewId,
                messenger,
                args as Map<String, Any?>,
            )
        }
    }
}