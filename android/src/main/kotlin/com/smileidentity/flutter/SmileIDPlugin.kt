package com.smileidentity.flutter

import FlutterAuthenticationRequest
import FlutterAuthenticationResponse
import FlutterEnhancedKycAsyncResponse
import FlutterEnhancedKycRequest
import SmileIDApi
import android.content.Context
import android.util.Log
import com.smileidentity.SmileID
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import kotlinx.coroutines.CoroutineExceptionHandler
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class SmileIDPlugin : FlutterPlugin, SmileIDApi, ActivityAware {

    private lateinit var context: Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        SmileIDApi.setUp(flutterPluginBinding.binaryMessenger, this)
        context = flutterPluginBinding.applicationContext
        flutterPluginBinding.platformViewRegistry.registerViewFactory(
            "SmileIDDocumentVerification",
            SmileIDDocumentVerification.Factory(flutterPluginBinding.binaryMessenger)
        )
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        SmileIDApi.setUp(binding.binaryMessenger, null)
    }

    override fun initialize() {
        SmileID.initialize(context)
    }

    override fun authenticate(
        request: FlutterAuthenticationRequest,
        callback: (Result<FlutterAuthenticationResponse>) -> Unit
    ) = launch(
        work = { SmileID.api.authenticate(request.toRequest()).toResponse() },
        callback = callback
    )

    override fun doEnhancedKycAsync(
        request: FlutterEnhancedKycRequest,
        callback: (Result<FlutterEnhancedKycAsyncResponse>) -> Unit
    ) = launch(
        work = { SmileID.api.doEnhancedKycAsync(request.toRequest()).toResponse() },
        callback = callback
    )

    /**
     * https://stackoverflow.com/a/62206235
     *
     * We can get the context in a ActivityAware way, without asking users to pass the context when
     * calling "initialize" on the sdk
     */
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {}

    override fun onDetachedFromActivityForConfigChanges() {}

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}

    override fun onDetachedFromActivity() {}
}

/**
 * Launches a new coroutine in the specified dispatcher (IO by default) and returns the result to
 * the callback. Used for launching coroutines from Dart.
 */
private fun <T> launch(
    work: suspend () -> T,
    callback: (Result<T>) -> Unit,
    scope: CoroutineScope = CoroutineScope(Dispatchers.IO)
) {
    val handler = CoroutineExceptionHandler { _, throwable ->
        callback.invoke(Result.failure(throwable))
    }
    scope.launch(handler) {
        callback.invoke(Result.success(work()))
    }
}
