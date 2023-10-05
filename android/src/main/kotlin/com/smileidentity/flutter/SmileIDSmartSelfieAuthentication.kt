package com.smileidentity.flutter

import android.content.Context
import android.view.View
import androidx.compose.ui.platform.ComposeView
import com.smileidentity.SmileID
import com.smileidentity.compose.SmartSelfieAuthentication
import com.smileidentity.results.SmartSelfieResult
import com.smileidentity.results.SmileIDResult
import com.smileidentity.util.randomJobId
import com.smileidentity.util.randomUserId
import io.flutter.Log
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

internal class SmileIDSmartSelfieAuthentication private constructor(
    context: Context,
    viewId: Int,
    messenger: BinaryMessenger,
    args: Map<String, Any?>,
) : PlatformView {
    companion object {
        const val VIEW_TYPE_ID = "SmileIDSmartSelfieAuthentication"
    }

    private val methodChannel: MethodChannel
    private val view: View

    init {
        methodChannel = MethodChannel(messenger, "${VIEW_TYPE_ID}_$viewId")
        view = ComposeView(context).apply {
            setContent {
                SmileID.SmartSelfieAuthentication(
                    userId = args["userId"] as? String ?: randomUserId(),
                    jobId = args["jobId"] as? String ?: randomJobId(),
                    allowAgentMode = args["allowAgentMode"] as? Boolean ?: false,
                    showAttribution = args["showAttribution"] as? Boolean ?: true,
                ) {
                    when (it) {
                        is SmileIDResult.Success -> {
                            // At this point, we have a successful result from the native SDK. But,
                            // there is still a possibility of the JSON serializing erroring for
                            // whatever reason -- if such a thing happens, we still want to tell
                            // the caller that the overall operation was successful. However, we
                            // just may not be able to provide the result JSON.
                            val json = try {
                                SmileID.moshi
                                    .adapter(SmartSelfieResult::class.java)
                                    .toJson(it.data)
                            } catch (e: Exception) {
                                Log.e(
                                    "SmileIDSmartSelfieAuthentication",
                                    "Error serializing result",
                                    e,
                                )
                                "null"
                            }
                            methodChannel.invokeMethod("onSuccess", json)
                        }

                        is SmileIDResult.Error -> {
                            // Print the stack trace, since we can't provide the actual Throwable
                            // back to Flutter
                            it.throwable.printStackTrace()
                            methodChannel.invokeMethod("onError", it.throwable.message)
                        }
                    }
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
            return SmileIDSmartSelfieAuthentication(
                context,
                viewId,
                messenger,
                args as Map<String, Any?>,
            )
        }
    }
}