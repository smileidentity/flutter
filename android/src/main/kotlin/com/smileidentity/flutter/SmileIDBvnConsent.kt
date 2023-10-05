package com.smileidentity.flutter

import android.content.Context
import android.view.View
import androidx.compose.ui.platform.ComposeView
import com.smileidentity.SmileID
import com.smileidentity.compose.BvnConsentScreen
import com.smileidentity.util.randomUserId
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

internal class SmileIDBvnConsent private constructor(
    context: Context,
    viewId: Int,
    messenger: BinaryMessenger,
    args: Map<String, Any?>,
) : PlatformView {
    companion object {
        const val VIEW_TYPE_ID = "SmileIDBvnConsent"
    }

    private val methodChannel: MethodChannel
    private val view: View

    init {
        methodChannel = MethodChannel(messenger, "${VIEW_TYPE_ID}_$viewId")
        view = ComposeView(context).apply {
            setContent {
                SmileID.BvnConsentScreen(
//                    partnerIcon = args["partnerIcon"] as Painter,
//                    partnerName = args["partnerName"] as String,
//                    partnerPrivacyPolicy = args["partnerPrivacyPolicy"] as URL,
                    userId = args["userId"] as? String ?: randomUserId(),
                ) {
                }
            }
        }
    }

    override fun getView() = view

    override fun dispose() = Unit

    class Factory(
        private val messenger: BinaryMessenger,
    ) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
        override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
            @Suppress("UNCHECKED_CAST")
            return SmileIDBvnConsent(
                context,
                viewId,
                messenger,
                args as Map<String, Any?>,
            )
        }
    }
}
