package com.smileidentity.flutter

import SmartSelfieCaptureResult
import SmileIDProductsResultApi
import android.content.Context
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.remember
import androidx.compose.runtime.toMutableStateList
import com.smileidentity.SmileID
import com.smileidentity.SmileIDOptIn
import com.smileidentity.compose.SmartSelfieEnrollment
import com.smileidentity.compose.SmartSelfieEnrollmentEnhanced
import com.smileidentity.compose.components.LocalMetadata
import com.smileidentity.compose.theme.colorScheme
import com.smileidentity.compose.theme.typography
import com.smileidentity.models.v2.Metadata
import com.smileidentity.results.SmartSelfieResult
import com.smileidentity.results.SmileIDResult
import com.smileidentity.util.randomJobId
import com.smileidentity.util.randomUserId
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

internal class SmileIDSmartSelfieCaptureView private constructor(
    context: Context,
    viewId: Int,
    messenger: BinaryMessenger,
    args: Map<String, Any?>,
    private val api: SmileIDProductsResultApi,
) : SmileSelfieComposablePlatformView(context, VIEW_TYPE_ID, viewId, messenger, args) {
    companion object {
        const val VIEW_TYPE_ID = "SmileIDSmartSelfieCaptureView"
    }

    @OptIn(SmileIDOptIn::class)
    @Composable
    override fun Content(args: Map<String, Any?>) {
        val showInstructions = args["showInstructions"] as? Boolean ?: true
        val showAttribution = args["showAttribution"] as? Boolean ?: true
        val allowAgentMode = args["allowAgentMode"] as? Boolean ?: true
        val useStrictMode = args["useStrictMode"] as? Boolean ?: false
        val userId = randomUserId()
        val jobId = randomJobId()
        CompositionLocalProvider(
            LocalMetadata provides remember { Metadata.default().items.toMutableStateList() },
        ) {
            MaterialTheme(colorScheme = SmileID.colorScheme, typography = SmileID.typography) {
                Surface(
                    content = {
                        if (useStrictMode) {
                            SmileID.SmartSelfieEnrollmentEnhanced(
                                userId = userId,
                                showAttribution = showAttribution,
                                showInstructions = showInstructions,
                                skipApiSubmission = true,
                                onResult = { res -> handleApiResult(res) },
                            )
                        } else {
                            SmileID.SmartSelfieEnrollment(
                                userId = userId,
                                jobId = jobId,
                                allowAgentMode = allowAgentMode,
                                showAttribution = showAttribution,
                                showInstructions = showInstructions,
                                skipApiSubmission = true,
                                onResult = { res -> handleApiResult(res) },
                            )
                        }
                    },
                )
            }
        }
    }

    private fun handleApiResult(res: SmileIDResult<SmartSelfieResult>) {
        when (res) {
            is SmileIDResult.Error -> api.onSelfieCaptureResult(
                successResultArg = null,
                errorResultArg = res.throwable.message ?: "Unknown error with Selfie Capture",
            ) {}

            is SmileIDResult.Success -> {
                val result = SmartSelfieCaptureResult(
                    selfieFile = res.data.selfieFile.absolutePath,
                    livenessFiles = res.data.livenessFiles.pathList(),
                    apiResponse = res.data.apiResponse?.toMap(),
                )

                api.onSelfieCaptureResult(successResultArg = result, errorResultArg = null) {}
            }
        }
    }


    class Factory(
        private val messenger: BinaryMessenger,
        private val api: SmileIDProductsResultApi,
    ) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
        override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
            @Suppress("UNCHECKED_CAST")
            return SmileIDSmartSelfieCaptureView(
                context,
                viewId,
                messenger,
                args as Map<String, Any?>,
                api,
            )
        }
    }
}
