package com.smileidentity.flutter

import android.content.Context
import android.view.View
import androidx.compose.ui.platform.ComposeView
import com.smileidentity.SmileID
import com.smileidentity.compose.DocumentVerification
import com.smileidentity.models.Document
import io.flutter.Log
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

internal class SmileIDDocumentVerification private constructor(
    private val context: Context,
    viewId: Int,
    messenger: BinaryMessenger,
    args: Map<String, Any?>,
) : PlatformView {

    private val methodChannel: MethodChannel
    private var view: View? = null

    init {
        // print contents of args
        args.forEach { (key, value) ->
            Log.d("SmileIDDocumentVerification", "$key: $value")
        }
        methodChannel = MethodChannel(messenger, "SmileIDDocumentVerification_$viewId")
    }

    override fun getView() = (view ?: ComposeView(context).apply {
        Log.d("SmileIDDocumentVerification", "getView")
//        setViewCompositionStrategy(DisposeOnViewTreeLifecycleDestroyed)
        setContent {
            SmileID.DocumentVerification(
                // idType = Document(args["countryCode"]!!, args["documentType"]!!),
                // idAspectRatio = args["idAspectRatio"]?.toFloat() ?: 0f,
                // captureBothSides = args["captureBothSides"]?.toBoolean() ?: false,
                // bypassSelfieCaptureWithFile = args["bypassSelfieCaptureWithFile"]?.let { File(it) },
                // userId = args["userId"] ?: "",
                // jobId = args["jobId"] ?: "",
                // showAttribution = args["showAttribution"]?.toBoolean() ?: false,
                // allowGalleryUpload = args["allowGalleryUpload"]?.toBoolean() ?: false,
                // showInstructions = args["showInstructions"]?.toBoolean() ?: false,
                idType = Document("NG", "PASSPORT"),
                showInstructions = true
            ) {
                methodChannel.invokeMethod(
                    "onResult",
                    it.toString(),
                )
            }
        }
    }.also { view = it })

    override fun dispose() {
//        view = null
        Log.d("SmileIDDocumentVerification", "dispose")
    }

    override fun onFlutterViewAttached(flutterView: View) {
        super.onFlutterViewAttached(flutterView)
//        view?.setViewTreeViewModelStoreOwner(flutterView.findViewTreeViewModelStoreOwner())
        Log.d("SmileIDDocumentVerification", "onFlutterViewAttached")
    }

    override fun onFlutterViewDetached() {
        super.onFlutterViewDetached()
//        view?.setViewTreeViewModelStoreOwner(null)
        Log.d("SmileIDDocumentVerification", "onFlutterViewDetached")
    }

    override fun onInputConnectionLocked() {
        super.onInputConnectionLocked()
        Log.d("SmileIDDocumentVerification", "onInputConnectionLocked")
    }

    override fun onInputConnectionUnlocked() {
        super.onInputConnectionUnlocked()
        Log.d("SmileIDDocumentVerification", "onInputConnectionUnlocked")
    }

    class Factory(
        private val messenger: BinaryMessenger
    ) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
        override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
            @Suppress("UNCHECKED_CAST")
            return SmileIDDocumentVerification(
                context, viewId, messenger, args as Map<String, Any?>
            )
        }
    }
}
