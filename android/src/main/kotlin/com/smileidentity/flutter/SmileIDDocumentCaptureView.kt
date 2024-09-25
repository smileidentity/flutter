package com.smileidentity.flutter

import android.content.Context
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
import androidx.compose.ui.res.stringResource
import com.smileidentity.R
import com.smileidentity.SmileID
import com.smileidentity.compose.document.DocumentCaptureScreen
import com.smileidentity.compose.document.DocumentCaptureSide
import com.smileidentity.compose.theme.colorScheme
import com.smileidentity.util.randomJobId
import com.squareup.moshi.JsonClass
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import java.io.File

@JsonClass(generateAdapter = true)
data class DocumentCaptureResult(val documentFile: File?)

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
        val colorScheme = SmileID.colorScheme.copy(background = Color.White)
        Box(
            modifier = Modifier
                .background(color = colorScheme.background)
                .windowInsetsPadding(WindowInsets.statusBars)
                .consumeWindowInsets(WindowInsets.statusBars)
                .fillMaxSize(),
        ) {
            val jobId = args["jobId"] as? String ?: randomJobId()
            val front = args["front"] as? Boolean ?: true
            val showInstructions = args["showInstructions"] as? Boolean ?: true
            val showAttribution = args["showAttribution"] as? Boolean ?: true
            val allowGalleryUpload = args["allowGalleryUpload"] as? Boolean ?: false
            val idAspectRatio = (args["idAspectRatio"] as Double?)?.toFloat()
            RenderDocumentCaptureScreen(
                jobId, front, showInstructions,
                showAttribution, allowGalleryUpload, idAspectRatio,
            )
        }
    }

    @Composable
    private fun RenderDocumentCaptureScreen(
        jobId: String, front: Boolean,
        showInstructions: Boolean, showAttribution: Boolean,
        allowGalleryUpload: Boolean, idAspectRatio: Float?,
    ) {
        val hero = if (front) R.drawable.si_doc_v_front_hero else R.drawable.si_doc_v_back_hero
        val instructionTitle = if (front) R.string.si_doc_v_instruction_title else
            R.string.si_doc_v_instruction_back_title
        val instructionSubTitle = if (front) R.string.si_verify_identity_instruction_subtitle else
            R.string.si_doc_v_instruction_back_subtitle
        val captureTitleText = if (front) R.string.si_doc_v_capture_instructions_front_title else
            R.string.si_doc_v_capture_instructions_back_title
        DocumentCaptureScreen(
            jobId = jobId,
            side = if (front) DocumentCaptureSide.Front else DocumentCaptureSide.Back,
            showInstructions = showInstructions,
            showAttribution = showAttribution,
            allowGallerySelection = allowGalleryUpload,
            showSkipButton = false,
            instructionsHeroImage = hero,
            instructionsTitleText = stringResource(instructionTitle),
            instructionsSubtitleText = stringResource(instructionSubTitle),
            captureTitleText = stringResource(captureTitleText),
            knownIdAspectRatio = idAspectRatio,
            onConfirm = { file -> onSuccess(DocumentCaptureResult(file)) },
            onError = { throwable -> onError(throwable) },
            onSkip = { },
        )
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