package com.smileidentity.flutter

import android.content.Context
import android.graphics.BitmapFactory
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.remember
import androidx.compose.runtime.toMutableStateList
import androidx.compose.ui.Modifier
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
import com.smileidentity.compose.theme.typography
import com.smileidentity.flutter.utils.SelfieCaptureResultAdapter
import com.smileidentity.models.v2.Metadata
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
        CompositionLocalProvider(
            LocalMetadata provides remember { Metadata.default().items.toMutableStateList() },
        ) {
            MaterialTheme(
                colorScheme = SmileID.colorScheme,
                typography = SmileID.typography,
            ) {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                ) {
                    val userId = randomUserId()
                    val jobId = randomJobId()
                    val showConfirmationDialog = args["showConfirmationDialog"] as? Boolean ?: true
                    val allowAgentMode = args["allowAgentMode"] as? Boolean ?: true
                    val metadata = LocalMetadata.current
                    val viewModel: SelfieViewModel =
                        viewModel(
                            factory =
                                viewModelFactory {
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
                        uiState.processingState != null ->
                            HandleProcessingState(
                                viewModel = viewModel,
                            )
                        uiState.selfieToConfirm != null ->
                            HandleSelfieConfirmation(
                                showConfirmationDialog = showConfirmationDialog,
                                uiState = uiState,
                                viewModel = viewModel,
                            )

                        else ->
                            RenderSelfieCaptureScreen(
                                userId = userId,
                                jobId = jobId,
                                allowAgentMode = allowAgentMode,
                                viewModel = viewModel,
                            )
                    }
                }
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
        SelfieCaptureScreen(
            modifier = Modifier.fillMaxSize(),
            userId = userId,
            jobId = jobId,
            allowAgentMode = allowAgentMode ?: true,
            allowNewEnroll = false,
            skipApiSubmission = true,
            viewModel = viewModel,
        )
    }

    @Composable
    private fun HandleSelfieConfirmation(
        showConfirmationDialog: Boolean,
        uiState: SelfieUiState,
        viewModel: SelfieViewModel,
    ) {
        if (showConfirmationDialog) {
            ImageCaptureConfirmationDialog(
                titleText = stringResource(R.string.si_smart_selfie_confirmation_dialog_title),
                subtitleText =
                    stringResource(
                        R.string.si_smart_selfie_confirmation_dialog_subtitle,
                    ),
                painter =
                    BitmapPainter(
                        BitmapFactory
                            .decodeFile(uiState.selfieToConfirm!!.absolutePath)
                            .asImageBitmap(),
                    ),
                confirmButtonText =
                    stringResource(
                        R.string.si_smart_selfie_confirmation_dialog_confirm_button,
                    ),
                onConfirm = {
                    viewModel.submitJob()
                },
                retakeButtonText =
                    stringResource(
                        R.string.si_smart_selfie_confirmation_dialog_retake_button,
                    ),
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
                    val result =
                        SmartSelfieCaptureResult(
                            selfieFile = res.data.selfieFile,
                            livenessFiles = res.data.livenessFiles,
                        )
                    val moshi =
                        SmileID.moshi
                            .newBuilder()
                            .add(SelfieCaptureResultAdapter.FACTORY)
                            .build()
                    val json =
                        try {
                            moshi
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
