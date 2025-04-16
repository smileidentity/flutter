package com.smileidentity.flutter.views

import android.content.Context
import android.view.View
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.ui.platform.ComposeView
import androidx.lifecycle.ViewModelStore
import androidx.lifecycle.ViewModelStoreOwner
import androidx.lifecycle.viewmodel.compose.LocalViewModelStoreOwner
import io.flutter.plugin.platform.PlatformView

/**
 * Base class for hosting Smile ID Composables in Flutter. This class handles flutter<>android
 * result delivery, view initialization (incl. view model store), and boilerplate. Subclasses should
 * implement [Content] to provide the actual Composable content.
 */
internal abstract class SmileComposablePlatformView(
    context: Context,
    protected val args: Map<String, Any?>,
) : PlatformView {
    /**
     * Creates a viewModelStore that is scoped to the FlutterView's lifecycle. Otherwise, state gets
     * shared between multiple FlutterView instances since the default viewModelStore is at the
     * Activity level and since we don't have a full Compose app or nav graph, the same viewModel
     * ends up getting re-used
     */
    private val viewModelStoreOwner = object : ViewModelStoreOwner {
        override val viewModelStore = ViewModelStore()
    }

    private var composeView: ComposeView = ComposeView(context).apply {
        setContent {
            CompositionLocalProvider(LocalViewModelStoreOwner provides viewModelStoreOwner) {
                Content(args)
            }
        }
    }

    private var isDisposed = false

    /**
     * Implement this method to provide the actual Composable content for the view
     *
     * @param args The arguments passed from Flutter. It is the responsibility of the subclass to
     * ensure the correct types are provided by the Flutter view and that they are parsed correctly
     */
    @Composable
    abstract fun Content(args: Map<String, Any?>)

    override fun getView(): View = if (isDisposed) {
        throw IllegalStateException(
            "View accessed after disposal",
        )
    } else {
        composeView
    }

    override fun dispose() {
        // We can't nullify composeView since it's a val, but we mark it as disposed
        // to prevent further access
        isDisposed = true
    }
}
