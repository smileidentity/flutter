package com.smileidentity.flutter

import android.content.Context
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.remember
import androidx.compose.runtime.toMutableStateList
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import com.smileidentity.R
import com.smileidentity.SmileID
import com.smileidentity.compose.components.LocalMetadata
import com.smileidentity.compose.document.DocumentCaptureScreen
import com.smileidentity.compose.document.DocumentCaptureSide
import com.smileidentity.compose.theme.colorScheme
import com.smileidentity.compose.theme.typography
import com.smileidentity.flutter.results.DocumentCaptureResult
import com.smileidentity.flutter.utils.DocumentCaptureResultAdapter
import com.smileidentity.models.v2.Metadata
import com.smileidentity.util.randomJobId
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
            modifier = Modifier.fillMaxSize(),
            jobId = jobId,
            side = if (isDocumentFrontSide) DocumentCaptureSide.Front else DocumentCaptureSide.Back,
            captureTitleText = stringResource(captureTitleText),
            knownIdAspectRatio = idAspectRatio,
            onConfirm = { file -> handleConfirmation(isDocumentFrontSide, file) },
            onError = { throwable -> onError(throwable) },
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
