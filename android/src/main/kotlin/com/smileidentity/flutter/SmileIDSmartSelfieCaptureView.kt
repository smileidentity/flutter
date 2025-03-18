package com.smileidentity.flutter

import android.content.Context
import android.graphics.BitmapFactory
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.consumeWindowInsets
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.statusBars
import androidx.compose.foundation.layout.windowInsetsPadding
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.runtime.toMutableStateList
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.graphics.painter.BitmapPainter
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.lifecycle.viewmodel.compose.viewModel
import com.smileidentity.R
import com.smileidentity.SmileID
import com.smileidentity.SmileIDOptIn
import com.smileidentity.compose.SmartSelfieEnrollment
import com.smileidentity.compose.SmartSelfieEnrollmentEnhanced
import com.smileidentity.compose.components.ImageCaptureConfirmationDialog
import com.smileidentity.compose.components.LocalMetadata
import com.smileidentity.compose.selfie.SelfieCaptureScreen
import com.smileidentity.compose.selfie.SmartSelfieInstructionsScreen
import com.smileidentity.compose.selfie.enhanced.OrchestratedSelfieCaptureScreenEnhanced
import com.smileidentity.compose.theme.colorScheme
import com.smileidentity.compose.theme.typography
import com.smileidentity.flutter.results.SmartSelfieCaptureResult
import com.smileidentity.flutter.utils.SelfieCaptureResultAdapter
import com.smileidentity.ml.SelfieQualityModel
import com.smileidentity.models.v2.Metadata
import com.smileidentity.results.SmartSelfieResult
import com.smileidentity.results.SmileIDResult
import com.smileidentity.util.randomJobId
import com.smileidentity.util.randomUserId
import com.smileidentity.viewmodel.SelfieUiState
import com.smileidentity.viewmodel.SelfieViewModel
import com.smileidentity.viewmodel.viewModelFactory
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

internal class SmileIDSmartSelfieCaptureView private constructor(
    context: Context,
    viewId: Int,
    messenger: BinaryMessenger,
    args: Map<String, Any?>,
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
        val allowNewEnroll = args["allowNewEnroll"] as? Boolean ?: false
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
                                allowNewEnroll = allowNewEnroll,
                                showAttribution = showAttribution,
                                showInstructions = showInstructions,
                                skipApiSubmission = true,
                                onResult = { res -> handleResult(res) },
                            )
                        } else {
                            SmileID.SmartSelfieEnrollment(
                                userId = userId,
                                jobId = jobId,
                                allowNewEnroll = allowNewEnroll,
                                allowAgentMode = allowAgentMode,
                                showAttribution = showAttribution,
                                showInstructions = showInstructions,
                                skipApiSubmission = true,
                                onResult = { res -> handleResult(res) },
                            )
                        }
                    },
                )
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
            return SmileIDSmartSelfieCaptureView(
                context,
                viewId,
                messenger,
                args as Map<String, Any?>,
            )
        }
    }
}
