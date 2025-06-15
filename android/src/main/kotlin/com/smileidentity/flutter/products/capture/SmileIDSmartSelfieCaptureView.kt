package com.smileidentity.flutter.products.capture

import SmartSelfieCaptureResult
import SmileIDProductsResultApi
import android.content.Context
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.runtime.Composable
import com.smileidentity.SmileID
import com.smileidentity.SmileIDOptIn
import com.smileidentity.compose.SmartSelfieEnrollment
import com.smileidentity.compose.SmartSelfieEnrollmentEnhanced
import com.smileidentity.compose.theme.colorScheme
import com.smileidentity.compose.theme.typography
import com.smileidentity.flutter.mapper.pathList
import com.smileidentity.flutter.mapper.toMap
import com.smileidentity.flutter.views.SmileIDPlatformView
import com.smileidentity.flutter.views.SmileIDViewFactory
import com.smileidentity.results.SmartSelfieResult
import com.smileidentity.results.SmileIDResult
import com.smileidentity.util.randomJobId
import com.smileidentity.util.randomUserId
import io.flutter.plugin.platform.PlatformViewFactory

// todo - did not touch this yet
internal class SmileIDSmartSelfieCaptureView private constructor(
    context: Context,
    args: Map<String, Any?>,
    api: SmileIDProductsResultApi,
) : SmileIDPlatformView(context, args, api) {
    companion object {
        const val VIEW_TYPE_ID = "SmileIDSmartSelfieCaptureView"

        fun createFactory(api: SmileIDProductsResultApi): PlatformViewFactory =
            SmileIDViewFactory(api) { context, args, resultApi ->
                SmileIDSmartSelfieCaptureView(context, args, resultApi)
            }
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
}
