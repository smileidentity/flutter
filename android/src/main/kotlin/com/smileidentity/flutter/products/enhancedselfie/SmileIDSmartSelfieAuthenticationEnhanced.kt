package com.smileidentity.flutter.products.enhancedselfie

import SmartSelfieCaptureResult
import SmileIDProductsResultApi
import android.content.Context
import androidx.compose.runtime.Composable
import com.smileidentity.SmileID
import com.smileidentity.compose.SmartSelfieAuthenticationEnhanced
import com.smileidentity.flutter.mapper.pathList
import com.smileidentity.flutter.mapper.toMap
import com.smileidentity.flutter.views.SmileIDPlatformView
import com.smileidentity.flutter.views.SmileIDViewFactory
import com.smileidentity.results.SmileIDResult
import io.flutter.plugin.platform.PlatformViewFactory
import kotlinx.collections.immutable.toImmutableMap

internal class SmileIDSmartSelfieAuthenticationEnhanced private constructor(
    context: Context,
    args: Map<String, Any?>,
    api: SmileIDProductsResultApi,
) : SmileIDPlatformView(context, args, api) {
    companion object {
        const val VIEW_TYPE_ID = "SmileIDSmartSelfieAuthenticationEnhanced"

        fun createFactory(api: SmileIDProductsResultApi): PlatformViewFactory =
            SmileIDViewFactory(api) { context, args, resultApi ->
                SmileIDSmartSelfieAuthenticationEnhanced(context, args, resultApi)
            }
    }

    @Composable
    override fun Content(args: Map<String, Any?>) {
        SmileID.SmartSelfieAuthenticationEnhanced(
            userId = getUserId(args),
            allowNewEnroll = getBoolean(args, "allowNewEnroll", false),
            showAttribution = getBoolean(args, "showAttribution", true),
            showInstructions = getBoolean(args, "showInstructions", true),
            skipApiSubmission = getBoolean(args, "skipApiSubmission", false),
            extraPartnerParams = getExtraPartnerParams(args).toImmutableMap(),
        ) {
            when (it) {
                is SmileIDResult.Success -> {
                    val result = SmartSelfieCaptureResult(
                        selfieFile = it.data.selfieFile.absolutePath,
                        livenessFiles = it.data.livenessFiles.pathList(),
                        apiResponse = it.data.apiResponse?.toMap(),
                    )
                    api.onSmartSelfieAuthenticationEnhancedResult(
                        successResultArg = result,
                        errorResultArg = null,
                    ) {}
                }

                is SmileIDResult.Error -> api.onSmartSelfieAuthenticationEnhancedResult(
                    successResultArg = null,
                    errorResultArg = it.throwable.message
                        ?: "Unknown error with Smart Selfie Authentication Enhanced",
                ) {}
            }
        }
    }
}
