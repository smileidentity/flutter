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
import java.io.File

internal class SmileIDDocumentVerification private constructor(
    context: Context,
    viewId: Int,
    messenger: BinaryMessenger,
    args: Map<String, Any?>,
) : PlatformView {
    companion object {
        const val viewTypeId = "SmileIDDocumentVerification"
    }

    private val methodChannel: MethodChannel
    private val view: View

    init {
        // print contents of args
        args.forEach { (key, value) ->
            Log.d("SmileIDDocumentVerification", "$key: $value")
        }
        methodChannel = MethodChannel(messenger, "SmileIDDocumentVerification_$viewId")
        view = ComposeView(context).apply {
            Log.d("SmileIDDocumentVerification", "getView")
            // setViewCompositionStrategy(DisposeOnViewTreeLifecycleDestroyed)
            setContent {
                SmileID.DocumentVerification(
                    // TODO: Global DocV changes
                    idType = Document(args["countryCode"] as String, args["documentType"] as String),
                    idAspectRatio = (args["idAspectRatio"] as Double?)?.toFloat(),
                    captureBothSides = args["captureBothSides"] as? Boolean ?: false,
                    bypassSelfieCaptureWithFile = (args["bypassSelfieCaptureWithFile"] as? String)?.let { File(it) },
                    userId = args["userId"] as? String ?: "",
                    jobId = args["jobId"] as? String ?: "",
                    showAttribution = args["showAttribution"] as? Boolean ?: true,
                    allowGalleryUpload = args["allowGalleryUpload"] as? Boolean ?: false,
                    showInstructions = args["showInstructions"] as? Boolean ?: true,
                ) {
                    methodChannel.invokeMethod(
                        "onResult",
                        it.toString(),
                    )
                }
            }
        }
    }

    override fun getView() = view

    override fun dispose() {
        // view = null
        Log.d("SmileIDDocumentVerification", "dispose")
    }

    override fun onFlutterViewAttached(flutterView: View) {
        super.onFlutterViewAttached(flutterView)
        // view?.setViewTreeViewModelStoreOwner(flutterView.findViewTreeViewModelStoreOwner())
        Log.d("SmileIDDocumentVerification", "onFlutterViewAttached")
    }

    override fun onFlutterViewDetached() {
        super.onFlutterViewDetached()
        // view?.setViewTreeViewModelStoreOwner(null)
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
