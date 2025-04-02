package com.smileidentity.flutter

import android.content.Intent
import android.graphics.BitmapFactory
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
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
import androidx.lifecycle.viewmodel.compose.viewModel
import com.smileidentity.R
import com.smileidentity.SmileID
import com.smileidentity.compose.components.ImageCaptureConfirmationDialog
import com.smileidentity.compose.components.LocalMetadata
import com.smileidentity.compose.document.DocumentCaptureInstructionsScreen
import com.smileidentity.compose.document.DocumentCaptureSide
import com.smileidentity.compose.theme.colorScheme
import com.smileidentity.compose.theme.typography
import com.smileidentity.models.v2.Metadata
import com.smileidentity.util.randomJobId
import com.smileidentity.viewmodel.document.DocumentCaptureViewModel
import com.smileidentity.viewmodel.viewModelFactory
import java.io.File
import java.net.URLDecoder
import java.nio.charset.StandardCharsets

class SmileIDDocumentCaptureActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val isDocumentFrontSide = intent.getBooleanExtra("isDocumentFrontSide", true)
        val showInstructions = intent.getBooleanExtra("showInstructions", true)
        val showAttribution = intent.getBooleanExtra("showAttribution", true)
        val allowGalleryUpload = intent.getBooleanExtra("allowGalleryUpload", false)
        val showConfirmationDialog = intent.getBooleanExtra("showConfirmationDialog", true)
        val idAspectRatio =
            intent.getDoubleExtra("idAspectRatio", -1.0).let {
                if (it == -1.0) return@let null
                return@let it.toFloat()
            }

        setContent {
            RenderDocumentCaptureContent(
                isDocumentFrontSide = isDocumentFrontSide,
                showInstructions = showInstructions,
                showAttribution = showAttribution,
                allowGalleryUpload = allowGalleryUpload,
                showConfirmationDialog = showConfirmationDialog,
                idAspectRatio = idAspectRatio,
            )
        }
    }

    @Composable
    private fun RenderDocumentCaptureContent(
        isDocumentFrontSide: Boolean,
        showInstructions: Boolean,
        showAttribution: Boolean,
        allowGalleryUpload: Boolean,
        showConfirmationDialog: Boolean,
        idAspectRatio: Float?,
    ) {
        var acknowledgedInstructions by rememberSaveable { mutableStateOf(false) }
        var galleryDocumentUri: String? by rememberSaveable { mutableStateOf(null) }
        var documentImageToConfirm: File? by rememberSaveable { mutableStateOf(null) }
        val jobId = randomJobId()
        val metadata = LocalMetadata.current
        val side =
            if (isDocumentFrontSide) {
                DocumentCaptureSide.Front
            } else {
                DocumentCaptureSide.Back
            }
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
            )

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
                                galleryDocumentUri =
                                    uri?.let {
                                        URLDecoder.decode(it, StandardCharsets.UTF_8.toString())
                                    }
                            }

                        showConfirmationDialog && documentImageToConfirm != null ->
                            RenderDocumentCaptureConfirmationScreen(
                                documentImageToConfirm = documentImageToConfirm!!,
                                isDocumentFrontSide = isDocumentFrontSide,
                            ) {
                                documentImageToConfirm = null

                                // in case the user chooses to retake an image after a photo gallery
                                // upload, we redirect the user to the instructions screen
                                if (galleryDocumentUri != null) {
                                    galleryDocumentUri = null
                                    acknowledgedInstructions = false
                                }
                            }

                        else ->
                            RenderDocumentCaptureScreen(
                                isDocumentFrontSide = isDocumentFrontSide,
                                idAspectRatio = idAspectRatio,
                                galleryDocumentUri = galleryDocumentUri,
                                jobId = jobId,
                                viewModel = viewModel,
                                showConfirmation = showConfirmationDialog,
                            ) { file ->
                                documentImageToConfirm = file
                            }
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
            onInstructionsAcknowledgedSelectFromGallery = {
                // todo needs an arg here
//                onInstructionsAcknowledged()
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
        onRetake: () -> Unit,
    ) {
        ImageCaptureConfirmationDialog(
            modifier = Modifier.fillMaxSize(),
            titleText = stringResource(R.string.si_doc_v_confirmation_dialog_title),
            subtitleText = stringResource(R.string.si_doc_v_confirmation_dialog_subtitle),
            painter =
                BitmapPainter(
                    BitmapFactory
                        .decodeFile(documentImageToConfirm.absolutePath)
                        .asImageBitmap(),
                ),
            confirmButtonText =
                stringResource(R.string.si_doc_v_confirmation_dialog_confirm_button),
            onConfirm = {
                handleConfirmation(isDocumentFrontSide, documentImageToConfirm)
            },
            retakeButtonText = stringResource(R.string.si_doc_v_confirmation_dialog_retake_button),
            onRetake = onRetake,
            scaleFactor = 1.0f,
        )
    }

    @Composable
    private fun RenderDocumentCaptureScreen(
        isDocumentFrontSide: Boolean,
        idAspectRatio: Float?,
        galleryDocumentUri: String?,
        jobId: String,
        viewModel: DocumentCaptureViewModel,
        showConfirmation: Boolean,
        onConfirm: (File?) -> Unit,
    ) {
        val captureTitleText =
            if (isDocumentFrontSide) {
                R.string.si_doc_v_capture_instructions_front_title
            } else {
                R.string.si_doc_v_capture_instructions_back_title
            }
        // todo - relook at this
//        DocumentCaptureScreen(
//            modifier = Modifier.fillMaxSize(),
//            jobId = jobId,
//            side = if (isDocumentFrontSide) DocumentCaptureSide.Front else DocumentCaptureSide.Back,
//            captureTitleText = stringResource(captureTitleText),
//            knownIdAspectRatio = idAspectRatio,
//            onConfirm = { file ->
//                if (!showConfirmation) {
//                    handleConfirmation(isDocumentFrontSide, file)
//                } else {
//                    onConfirm(file)
//                }
//            },
//            onError = { throwable ->
//                val intent = Intent()
//                intent.putExtra("error", throwable.message)
//                setResult(RESULT_CANCELED, intent)
//                finish()
//            },
//            showInstructions = true,
//            showAttribution = true,
//            allowGallerySelection = true,
//            showSkipButton = true,
//            instructionsHeroImage = true,
//            instructionsTitleText = true,
//            instructionsSubtitleText = true,
//            showConfirmation = true,
//            onSkip = true,
//            viewModel = true,
// //            galleryDocumentUri = galleryDocumentUri,
// //            viewModel = viewModel,
//        )
    }

    private fun handleConfirmation(
        isDocumentFrontSide: Boolean,
        file: File,
    ) {
        val intent = Intent()

        intent.putExtra(
            if (isDocumentFrontSide) "documentFrontFile" else "documentBackFile",
            file.absolutePath,
        )

        setResult(RESULT_OK, intent)
        finish()
    }

    companion object {
        const val REQUEST_CODE = 20
    }
}
