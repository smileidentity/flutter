package com.smileidentity.flutter.products.capture

import DocumentCaptureResult
import SmileIDProductsResultApi
import android.content.Context
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import com.smileidentity.R
import com.smileidentity.SmileID
import com.smileidentity.compose.document.DocumentCaptureScreen
import com.smileidentity.compose.document.DocumentCaptureSide
import com.smileidentity.compose.theme.colorScheme
import com.smileidentity.compose.theme.typography
import com.smileidentity.flutter.results.DocumentCaptureResult
import com.smileidentity.flutter.views.SmileIDPlatformView
import com.smileidentity.flutter.views.SmileIDViewFactory
import com.smileidentity.models.v2.Metadata
import com.smileidentity.util.randomJobId
import io.flutter.plugin.platform.PlatformViewFactory
import java.io.File

// todo - did not touch this yet
internal class SmileIDDocumentCaptureView private constructor(
    context: Context,
    args: Map<String, Any?>,
    api: SmileIDProductsResultApi,
) : SmileIDPlatformView(context, args, api) {
    companion object {
        const val VIEW_TYPE_ID = "SmileIDDocumentCaptureView"

        fun createFactory(api: SmileIDProductsResultApi): PlatformViewFactory =
            SmileIDViewFactory(api) { context, args, resultApi ->
                SmileIDDocumentCaptureView(context, args, resultApi)
            }
    }

    @Composable
    override fun Content(args: Map<String, Any?>) {
        CompositionLocalProvider(
            LocalMetadata provides remember {
                Metadata.Companion.default().items.toMutableStateList()
            },
        ) {
            MaterialTheme(
                colorScheme = SmileID.colorScheme,
                typography = SmileID.typography,
            ) {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                ) {
                    val isDocumentFrontSide = args["isDocumentFrontSide"] as? Boolean ?: true
                    val showInstructions = args["showInstructions"] as? Boolean ?: true
                    val showAttribution = args["showAttribution"] as? Boolean ?: true
                    val allowGalleryUpload = args["allowGalleryUpload"] as? Boolean ?: false
                    val showConfirmationDialog = args["showConfirmationDialog"] as? Boolean ?: true
                    val idAspectRatio = (args["idAspectRatio"] as Double?)?.toFloat()
                    RenderDocumentCaptureScreen(
                        jobId = randomJobId(),
                        isDocumentFrontSide = isDocumentFrontSide,
                        showInstructions = showInstructions,
                        showAttribution = showAttribution,
                        allowGalleryUpload = allowGalleryUpload,
                        showConfirmationDialog = showConfirmationDialog,
                        idAspectRatio = idAspectRatio,
                    )
                }
            }
        }
    }

    @Composable
    private fun RenderDocumentCaptureScreen(
        jobId: String,
        isDocumentFrontSide: Boolean,
        showInstructions: Boolean,
        showAttribution: Boolean,
        allowGalleryUpload: Boolean,
        showConfirmationDialog: Boolean,
        idAspectRatio: Float?,
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
        val captureTitleText =
            if (isDocumentFrontSide) {
                R.string.si_doc_v_capture_instructions_front_title
            } else {
                R.string.si_doc_v_capture_instructions_back_title
            }
        DocumentCaptureScreen(
            jobId = jobId,
            side = if (isDocumentFrontSide) DocumentCaptureSide.Front else DocumentCaptureSide.Back,
            showInstructions = showInstructions,
            showAttribution = showAttribution,
            allowGallerySelection = allowGalleryUpload,
            showConfirmation = showConfirmationDialog,
            showSkipButton = false,
            instructionsHeroImage = hero,
            instructionsTitleText = stringResource(instructionTitle),
            instructionsSubtitleText = stringResource(instructionSubTitle),
            captureTitleText = stringResource(captureTitleText),
            knownIdAspectRatio = idAspectRatio,
            onConfirm = { file -> handleConfirmation(isDocumentFrontSide, file) },
            onError = { throwable ->
                api.onDocumentCaptureResult(
                    successResultArg = null,
                    errorResultArg = throwable.message ?: "Unknown error with Document Capture",
                ) {}
            },
            onSkip = { },
        )
    }

    private fun handleConfirmation(isDocumentFrontSide: Boolean, file: File) {
        val result =
            DocumentCaptureResult(
                documentFrontFile = if (isDocumentFrontSide) file.absolutePath else null,
                documentBackFile = if (!isDocumentFrontSide) file.absolutePath else null,
            )
        api.onDocumentCaptureResult(successResultArg = result, errorResultArg = null) {}
    }
}
