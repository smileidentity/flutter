package com.smileidentity.flutter

import android.content.Context
import android.graphics.BitmapFactory
import androidx.compose.foundation.layout.fillMaxSize
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
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.graphics.painter.BitmapPainter
import androidx.compose.ui.res.stringResource
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.lifecycle.viewmodel.viewModelFactory
import com.smileidentity.R
import com.smileidentity.SmileID
import com.smileidentity.compose.components.ImageCaptureConfirmationDialog
import com.smileidentity.compose.components.LocalMetadata
import com.smileidentity.compose.document.DocumentCaptureInstructionsScreen
import com.smileidentity.compose.document.DocumentCaptureScreen
import com.smileidentity.compose.document.DocumentCaptureSide
import com.smileidentity.compose.theme.colorScheme
import com.smileidentity.compose.theme.typography
import com.smileidentity.flutter.results.DocumentCaptureResult
import com.smileidentity.flutter.utils.DocumentCaptureResultAdapter
import com.smileidentity.models.v2.Metadata
import com.smileidentity.util.randomJobId
import com.smileidentity.viewmodel.document.DocumentCaptureViewModel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import java.io.File

internal class SmileIDDocumentCaptureView private constructor(
    context: Context,
    viewId: Int,
    messenger: BinaryMessenger,
    args: Map<String, Any?>,
) : SmileComposablePlatformView(context, VIEW_TYPE_ID, viewId, messenger, args) {
    companion object {
        const val VIEW_TYPE_ID = "SmileIDDocumentCaptureView"
    }

    @Composable
    override fun Content(args: Map<String, Any?>) {
        val isDocumentFrontSide = args["isDocumentFrontSide"] as? Boolean ?: true
        val showInstructions = args["showInstructions"] as? Boolean ?: true
        val showAttribution = args["showAttribution"] as? Boolean ?: true
        val allowGalleryUpload = args["allowGalleryUpload"] as? Boolean ?: false
        val showConfirmation = args["showConfirmationDialog"] as? Boolean ?: true
        val idAspectRatio = (args["idAspectRatio"] as Double?)?.toFloat()

        val jobId = randomJobId()
        val side =
            if (isDocumentFrontSide) {
                DocumentCaptureSide.Front
            } else {
                DocumentCaptureSide.Back
            }

        val metadata = LocalMetadata.current
        val viewModel: DocumentCaptureViewModel =
            viewModel(
                factory =
                viewModelFactory {
                    DocumentCaptureViewModel(
                        jobId = jobId,
                        side = side,
                        knownAspectRatio = idAspectRatio,
                        metadata = metadata,
                    )
                },
                key = side.name,
            )

        val uiState = viewModel.uiState.collectAsStateWithLifecycle().value
        var acknowledgedInstructions: Boolean by rememberSaveable { mutableStateOf(false) }
        var galleryDocumentUri: String? by rememberSaveable { mutableStateOf(null) }

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
                    when {
                        showInstructions && !acknowledgedInstructions ->
                            RenderDocumentCaptureInstructionsScreen(
                                isDocumentFrontSide = isDocumentFrontSide,
                                showAttribution = showAttribution,
                                allowGalleryUpload = allowGalleryUpload,
                            ) { uri ->
                                acknowledgedInstructions = true
                                galleryDocumentUri = uri
                            }
                        showConfirmation && uiState.documentImageToConfirm != null ->
                            RenderDocumentCaptureConfirmationScreen(
                                documentImageToConfirm = uiState.documentImageToConfirm!!,
                                isDocumentFrontSide = isDocumentFrontSide,
                                viewModel = viewModel,
                            )
                        else -> RenderDocumentCaptureScreen(
                            jobId = jobId,
                            isDocumentFrontSide = isDocumentFrontSide,
                            idAspectRatio = idAspectRatio,
                            galleryDocumentUri = galleryDocumentUri,
                            showConfirmation = showConfirmation,
                            viewModel = viewModel,
                        )
                    }
                }
            }
        }
    }

    @Composable
    private fun RenderDocumentCaptureInstructionsScreen(
        isDocumentFrontSide: Boolean,
        showAttribution: Boolean,
        allowGalleryUpload: Boolean,
        onInstructionsAcknowledged: (String?) -> Unit,
    ) {
        val hero =
            if (isDocumentFrontSide) {
                R.drawable.si_doc_v_front_hero
            } else {
                R.drawable.si_doc_v_back_hero
            }
        val instructionTitle =
            if (isDocumentFrontSide) {
                R.string.si_doc_v_instruction_title
            } else {
                R.string.si_doc_v_instruction_back_title
            }
        val instructionSubTitle =
            if (isDocumentFrontSide) {
                R.string.si_verify_identity_instruction_subtitle
            } else {
                R.string.si_doc_v_instruction_back_subtitle
            }
        DocumentCaptureInstructionsScreen(
            modifier = Modifier.fillMaxSize(),
            heroImage = hero,
            title = stringResource(instructionTitle),
            subtitle = stringResource(instructionSubTitle),
            showAttribution = showAttribution,
            allowPhotoFromGallery = allowGalleryUpload,
            showSkipButton = false,
            onSkip = {},
            onInstructionsAcknowledgedSelectFromGallery = { uri ->
                onInstructionsAcknowledged(uri)
            },
            onInstructionsAcknowledgedTakePhoto = {
                onInstructionsAcknowledged(null)
            },
        )
    }

    @Composable
    private fun RenderDocumentCaptureConfirmationScreen(
        documentImageToConfirm: File,
        isDocumentFrontSide: Boolean,
        viewModel: DocumentCaptureViewModel,
    ) {
        ImageCaptureConfirmationDialog(
            modifier = Modifier.fillMaxSize(),
            titleText = stringResource(R.string.si_doc_v_confirmation_dialog_title),
            subtitleText = stringResource(R.string.si_doc_v_confirmation_dialog_subtitle),
            painter = BitmapPainter(
                BitmapFactory
                    .decodeFile(documentImageToConfirm.absolutePath)
                    .asImageBitmap(),
            ),
            confirmButtonText = stringResource(R.string.si_doc_v_confirmation_dialog_confirm_button),
            onConfirm = {
                viewModel.onConfirm(documentImageToConfirm) { file ->
                    handleConfirmation(isDocumentFrontSide, file)
                }
            },
            retakeButtonText = stringResource(R.string.si_doc_v_confirmation_dialog_retake_button),
            onRetake = viewModel::onRetry,
            scaleFactor = 1.0f,
        )
    }

    @Composable
    private fun RenderDocumentCaptureScreen(
        jobId: String,
        isDocumentFrontSide: Boolean,
        idAspectRatio: Float?,
        galleryDocumentUri: String?,
        showConfirmation: Boolean,
        viewModel: DocumentCaptureViewModel,
    ) {
        val captureTitleText = if (isDocumentFrontSide) {
            R.string.si_doc_v_capture_instructions_front_title
        } else {
            R.string.si_doc_v_capture_instructions_back_title
        }
        DocumentCaptureScreen(
            modifier = Modifier.fillMaxSize(),
            jobId = jobId,
            side = if (isDocumentFrontSide) DocumentCaptureSide.Front else DocumentCaptureSide.Back,
            captureTitleText = stringResource(captureTitleText),
            knownIdAspectRatio = idAspectRatio,
            onConfirm = { file ->
                if (!showConfirmation) {
                    handleConfirmation(isDocumentFrontSide, file)
                }
            },
            onError = { throwable -> onError(throwable) },
            galleryDocumentUri = galleryDocumentUri,
            viewModel = viewModel
        )
    }

    private fun handleConfirmation(
        isDocumentFrontSide: Boolean,
        file: File,
    ) {
        val moshi =
            SmileID.moshi
                .newBuilder()
                .add(DocumentCaptureResultAdapter.FACTORY)
                .build()
        val result =
            DocumentCaptureResult(
                documentFrontFile = if (isDocumentFrontSide) file else null,
                documentBackFile = if (!isDocumentFrontSide) file else null,
            )
        val json =
            try {
                moshi
                    .adapter(DocumentCaptureResult::class.java)
                    .toJson(result)
            } catch (e: Exception) {
                onError(e)
                return
            }
        json?.let {
            onSuccessJson(it)
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
            return SmileIDDocumentCaptureView(
                context,
                viewId,
                messenger,
                args as Map<String, Any?>,
            )
        }
    }
}
