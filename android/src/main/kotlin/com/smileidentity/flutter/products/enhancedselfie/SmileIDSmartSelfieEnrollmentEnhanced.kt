package com.smileidentity.flutter.products.enhancedselfie

import android.content.Context
import androidx.compose.runtime.Composable
import com.smileidentity.SmileID
import com.smileidentity.compose.SmartSelfieEnrollmentEnhanced
import com.smileidentity.flutter.views.SmileIDViewFactory
import com.smileidentity.flutter.views.SmileSelfieComposablePlatformView
import com.smileidentity.util.randomUserId
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformViewFactory
import kotlinx.collections.immutable.toImmutableMap

internal class SmileIDSmartSelfieEnrollmentEnhanced private constructor(
    context: Context,
    viewId: Int,
    messenger: BinaryMessenger,
    args: Map<String, Any?>,
) : SmileSelfieComposablePlatformView(context, VIEW_TYPE_ID, viewId, messenger, args) {
    companion object {
        const val VIEW_TYPE_ID = "SmileIDSmartSelfieEnrollmentEnhanced"

        fun createFactory(messenger: BinaryMessenger): PlatformViewFactory =
            SmileIDViewFactory(messenger = messenger) { context, args, messenger, viewId ->
                SmileIDSmartSelfieEnrollmentEnhanced(
                    context = context,
                    viewId = viewId,
                    messenger = messenger,
                    args = args,
                )
            }
    }

    @Composable
    override fun Content(args: Map<String, Any?>) {
        val extraPartnerParams = args["extraPartnerParams"] as? Map<String, String> ?: emptyMap()
        SmileID.SmartSelfieEnrollmentEnhanced(
            userId = args["userId"] as? String ?: randomUserId(),
            allowNewEnroll = args["allowNewEnroll"] as? Boolean ?: false,
            showAttribution = args["showAttribution"] as? Boolean ?: true,
            showInstructions = args["showInstructions"] as? Boolean ?: true,
            skipApiSubmission = args["skipApiSubmission"] as? Boolean ?: false,
            extraPartnerParams = extraPartnerParams.toImmutableMap(),
            onResult = { res -> handleResult(res) },
        )
    }
}
