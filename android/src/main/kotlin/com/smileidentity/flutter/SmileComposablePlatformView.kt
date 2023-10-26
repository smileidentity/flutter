package com.smileidentity.flutter

import android.content.Context
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.ui.platform.ComposeView
import androidx.lifecycle.ViewModelStore
import androidx.lifecycle.ViewModelStoreOwner
import androidx.lifecycle.viewmodel.compose.LocalViewModelStoreOwner
import com.smileidentity.SmileID
import io.flutter.Log
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

/**
 * Base class for hosting Smile ID Composables in Flutter. This class handles flutter<>android
 * result delivery, view initialization (incl. view model store), and boilerplate. Subclasses
 * should implement [Content] to provide the actual Composable content.
 */
internal abstract class SmileComposablePlatformView(
    context: Context,
    viewTypeId: String,
    viewId: Int,
    messenger: BinaryMessenger,
    args: Map<String, Any?>,
) : PlatformView {

    private val methodChannel = MethodChannel(messenger, "${viewTypeId}_$viewId")

    // Creates a viewModelStore that is scoped to the FlutterView's lifecycle. Otherwise, state gets
    // shared between multiple FlutterView instances since the default viewModelStore is at the
    // Activity level and since we don't have a full Compose app or nav graph, the same viewModel
    // ends up getting re-used
    private var view: ComposeView? = ComposeView(context).apply {
        setContent {
            CompositionLocalProvider(
                LocalViewModelStoreOwner provides object : ViewModelStoreOwner {
                    override val viewModelStore = ViewModelStore()
                }
            ) {
                Content(args)
            }
        }
    }

    /**
     * Implement this method to provide the actual Composable content for the view
     *
     * @param args The arguments passed from Flutter. It is the responsibility of the subclass to
     * ensure the correct types are provided by the Flutter view and that they are parsed correctly
     */
    @Composable
    abstract fun Content(args: Map<String, Any?>)

    /**
     * Delivers a successful result back to Flutter as JSON. It is the flutter code's responsibility
     * to parse this JSON string into the appropriate object
     *
     * @param result The success result object. NB! This object *must* be serializable by the
     * [SmileID.moshi] instance!
     */
    inline fun <reified T> onSuccess(result: T) {
        // At this point, we have a successful result from the native SDK. But, there is still a
        // possibility of the JSON serializing erroring for whatever reason -- if such a thing
        // happens, we still want to tell the caller that the overall operation was successful.
        // However, we just may not be able to provide the result JSON.
        val json = try {
            SmileID.moshi
                .adapter(T::class.java)
                .toJson(result)
        } catch (e: Exception) {
            Log.e("SmileComposablePlatformView", "Error serializing result", e)
            Log.v("SmileComposablePlatformView", "Result is: $result")
            "null"
        }
        methodChannel.invokeMethod("onSuccess", json)
    }

    /**
     * Delivers an error result back to Flutter
     *
     * @param throwable The throwable that caused the error. This will be converted to a string
     * message and delivered back to Flutter, because a [Throwable] cannot be passed back to Flutter
     */
    fun onError(throwable: Throwable) {
        // Print the stack trace, since we can't provide the actual Throwable back to Flutter
        throwable.printStackTrace()
        methodChannel.invokeMethod("onError", throwable.message)
    }

    override fun getView() = view

    override fun dispose() {
        // Clear references to the view to avoid memory leaks
        view = null
    }
}
