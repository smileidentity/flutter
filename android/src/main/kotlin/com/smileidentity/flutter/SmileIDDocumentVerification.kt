package com.smileidentity.flutter

import android.content.Context
import android.view.View
import androidx.compose.ui.platform.ComposeView
import com.smileidentity.SmileID
import com.smileidentity.compose.DocumentVerification
import com.smileidentity.models.Document
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import java.io.File

internal class SmileIDDocumentVerification private constructor(
    private val context: Context,
    viewId: Int,
    messenger: BinaryMessenger,
    args: Any?,
) : PlatformView {

    private val methodChannel: MethodChannel
//    private val args: Map<String, String>

    init {
//        this.args = args as Map<String, String> // todo format of args
        methodChannel = MethodChannel(messenger, "SmileIDDocumentVerification_$viewId")
    }
    override fun getView() = ComposeView(context).apply {
        setContent {
            SmileID.DocumentVerification(
//                idType = Document(args["countryCode"]!!, args["documentType"]!!),
//                idAspectRatio = args["idAspectRatio"]?.toFloat() ?: 0f,
//                captureBothSides = args["captureBothSides"]?.toBoolean() ?: false,
//                bypassSelfieCaptureWithFile = args["bypassSelfieCaptureWithFile"]?.let { File(it) },
//                userId = args["userId"] ?: "",
//                jobId = args["jobId"] ?: "",
//                showAttribution = args["showAttribution"]?.toBoolean() ?: false,
//                allowGalleryUpload = args["allowGalleryUpload"]?.toBoolean() ?: false,
//                showInstructions = args["showInstructions"]?.toBoolean() ?: false,
                idType = Document("NG", "PASSPORT"),
                showInstructions = true
            ) {
                methodChannel.invokeMethod("onResult", it)
            }
        }
    }

    override fun dispose() = Unit

    class Factory(
        private val messenger: BinaryMessenger
    ) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
        override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
            return SmileIDDocumentVerification(context, viewId, messenger, args)
        }
    }
}
