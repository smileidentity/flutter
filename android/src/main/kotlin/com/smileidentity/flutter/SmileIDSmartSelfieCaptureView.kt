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
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.graphics.painter.BitmapPainter
import androidx.compose.ui.res.stringResource
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.lifecycle.viewmodel.compose.viewModel
import com.smileidentity.R
import com.smileidentity.SmileID
import com.smileidentity.SmileIDOptIn
import com.smileidentity.compose.components.ImageCaptureConfirmationDialog
import com.smileidentity.compose.components.LocalMetadata
import com.smileidentity.compose.selfie.SelfieCaptureScreen
import com.smileidentity.compose.theme.colorScheme
import com.smileidentity.flutter.utils.SelfieCaptureResultAdapter
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
import java.io.File

data class SmartSelfieCaptureResult(
    val selfieFile: File? = null,
    val livenessFiles: List<File>? = null,
)

internal class SmileIDSmartSelfieCaptureView private constructor(
    context: Context,
    viewId: Int,
    messenger: BinaryMessenger,
    args: Map<String, Any?>,
) : SmileComposablePlatformView(context, VIEW_TYPE_ID, viewId, messenger, args) {
    companion object {
        const val VIEW_TYPE_ID = "SmileIDSmartSelfieCaptureView"
    }

    @OptIn(SmileIDOptIn::class)
    @Composable
    override fun Content(args: Map<String, Any?>) {
        val colorScheme = SmileID.colorScheme.copy(background = Color.White)
        Box(
            modifier = Modifier
                .background(color = colorScheme.background)
                .windowInsetsPadding(WindowInsets.statusBars)
                .consumeWindowInsets(WindowInsets.statusBars)
                .fillMaxSize(),
        ) {
            val userId = args["userId"] as? String ?: randomUserId()
            val jobId = args["jobId"] as? String ?: randomJobId()
            val showConfirmation = args["showConfirmation"] as? Boolean ?: true
            val allowAgentMode = args["allowAgentMode"] as? Boolean ?: true
            val metadata = LocalMetadata.current
            val viewModel: SelfieViewModel = viewModel(
                factory = viewModelFactory {
                    SelfieViewModel(
                        isEnroll = false,
                        userId = userId,
                        jobId = jobId,
                        allowNewEnroll = false,
                        skipApiSubmission = true,
                        metadata = metadata,
                    )
                },
            )
            val uiState = viewModel.uiState.collectAsStateWithLifecycle().value

            when {
                uiState.processingState != null -> HandleProcessingState(viewModel)
                uiState.selfieToConfirm != null -> HandleSelfieConfirmation(
                    showConfirmation,
                    uiState, viewModel,
                )

                else -> RenderSelfieCaptureScreen(userId, jobId, allowAgentMode, viewModel)
            }
        }
    }

    @Composable
    private fun RenderSelfieCaptureScreen(
        userId: String,
        jobId: String,
        allowAgentMode: Boolean,
        viewModel: SelfieViewModel,
    ) {
        Box(
            modifier = Modifier
                .background(color = Color.White)
                .windowInsetsPadding(WindowInsets.statusBars)
                .consumeWindowInsets(WindowInsets.statusBars)
                .fillMaxSize(),
        ) {
            SelfieCaptureScreen(
                modifier = Modifier
                    .background(color = Color.White),
                userId = userId,
                jobId = jobId,
                allowAgentMode = allowAgentMode ?: true,
                allowNewEnroll = false,
                skipApiSubmission = true,
                viewModel = viewModel,
            )
        }
    }

    @Composable
    private fun HandleSelfieConfirmation(
        showConfirmation: Boolean,
        uiState: SelfieUiState,
        viewModel: SelfieViewModel,
    ) {
        if (showConfirmation) {
            ImageCaptureConfirmationDialog(
                titleText = stringResource(R.string.si_smart_selfie_confirmation_dialog_title),
                subtitleText = stringResource(R.string.si_smart_selfie_confirmation_dialog_subtitle),
                painter = BitmapPainter(
                    BitmapFactory.decodeFile(uiState.selfieToConfirm!!.absolutePath)
                        .asImageBitmap(),
                ),
                confirmButtonText = stringResource(R.string.si_smart_selfie_confirmation_dialog_confirm_button),
                onConfirm = {
                    viewModel.submitJob()
                },
                retakeButtonText = stringResource(R.string.si_smart_selfie_confirmation_dialog_retake_button),
                onRetake = viewModel::onSelfieRejected,
                scaleFactor = 1.25f,
            )
        } else {
            viewModel.submitJob()
        }
    }

    @Composable
    private fun HandleProcessingState(viewModel: SelfieViewModel) {
        viewModel.onFinished { res ->
            when (res) {
                is SmileIDResult.Success -> {
                    val result = SmartSelfieCaptureResult(
                        selfieFile = res.data.selfieFile,
                        livenessFiles = res.data.livenessFiles,
                    )
                    val newMoshi = SmileID.moshi.newBuilder()
                        .add(SelfieCaptureResultAdapter.FACTORY)
                        .build()
                    val json = try {
                        newMoshi
                            .adapter(SmartSelfieCaptureResult::class.java)
                            .toJson(result)
                    } catch (e: Exception) {
                        onError(e)
                        return@onFinished
                    }
                    json?.let { js ->
                        onSuccessJson(js)
                    }
                }

                is SmileIDResult.Error -> onError(res.throwable)
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