package com.smileidentity.smileid

import FlutterEnhancedKycAsyncResponse
import FlutterEnhancedKycRequest
import SmileIdApi
import android.content.Context
import androidx.annotation.NonNull
import com.smileidentity.SmileID
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import kotlinx.coroutines.runBlocking

/** SmileidPlugin */
class SmileidPlugin : FlutterPlugin, SmileIdApi, ActivityAware {

    private lateinit var context: Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        SmileIdApi.setUp(flutterPluginBinding.binaryMessenger, this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        SmileIdApi.setUp(binding.binaryMessenger, this)
    }

    override fun getPlatformVersion(callback: (Result<String?>) -> Unit) {
        callback.invoke(Result.success("Android ${android.os.Build.VERSION.RELEASE}"))
    }

    override fun initialize(callback: (Result<Unit>) -> Unit) {
        SmileID.initialize(context)
    }

    override fun doEnhancedKycAsync(
        request: FlutterEnhancedKycRequest,
        callback: (Result<FlutterEnhancedKycAsyncResponse?>) -> Unit
    ) = runBlocking {
        val response = SmileID.api.doEnhancedKycAsync(request.toRequest())
        callback.invoke(Result.success(response.toResponse()))
    }

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
