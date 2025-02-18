package com.smileidentity.flutter.enhanced

import android.content.Context
import androidx.compose.runtime.Composable
import com.smileidentity.SmileID
import com.smileidentity.compose.SmartSelfieEnrollmentEnhanced
import com.smileidentity.flutter.SmileComposablePlatformView
import com.smileidentity.networking.FileAdapter
import com.smileidentity.results.SmartSelfieResult
import com.smileidentity.results.SmileIDResult
import com.smileidentity.util.randomUserId
import com.squareup.moshi.Moshi
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import kotlinx.collections.immutable.toImmutableMap

internal class SmileIDSmartSelfieEnrollmentEnhanced private constructor(
    context: Context,
    viewId: Int,
    messenger: BinaryMessenger,
    args: Map<String, Any?>,
) : SmileComposablePlatformView(context, VIEW_TYPE_ID, viewId, messenger, args) {
    companion object {
        const val VIEW_TYPE_ID = "SmileIDSmartSelfieEnrollmentEnhanced"
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
        ) {
            val moshi =
                Moshi
                    .Builder()
                    .add(FileAdapter)
                    .build()
            when (it) {
                is SmileIDResult.Success -> {
                    val result =
                        SmartSelfieResult(
                            selfieFile = it.data.selfieFile,
                            livenessFiles = it.data.livenessFiles,
                            apiResponse = it.data.apiResponse,
                        )
                    val json =
                        try {
                            moshi
                                .adapter(SmartSelfieResult::class.java)
                                .toJson(result)
                        } catch (e: Exception) {
                            onError(e)
                            return@SmartSelfieEnrollmentEnhanced
                        }
                    json?.let { response ->
                        onSuccessJson(response)
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
            return SmileIDSmartSelfieEnrollmentEnhanced(
                context,
                viewId,
                messenger,
                args as Map<String, Any?>,
            )
        }
    }
}
