package com.smileidentity.flutter

import FlutterAuthenticationRequest
import FlutterAuthenticationResponse
import FlutterBiometricKycJobStatusResponse
import FlutterDocumentVerificationJobStatusResponse
import FlutterEnhancedDocumentVerificationJobStatusResponse
import FlutterEnhancedKycAsyncResponse
import FlutterEnhancedKycRequest
import FlutterEnhancedKycResponse
import FlutterJobStatusRequest
import FlutterPrepUploadRequest
import FlutterPrepUploadResponse
import FlutterProductsConfigRequest
import FlutterProductsConfigResponse
import FlutterServicesResponse
import FlutterSmartSelfieJobStatusResponse
import FlutterUploadRequest
import FlutterValidDocumentsResponse
import SmileIDApi
import android.app.Activity
import android.content.Context
import com.smileidentity.SmileID
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import kotlinx.coroutines.CoroutineExceptionHandler
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.net.URL

class SmileIDPlugin : FlutterPlugin, SmileIDApi, ActivityAware {

    private var activity: Activity? = null
    private lateinit var appContext: Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        SmileIDApi.setUp(flutterPluginBinding.binaryMessenger, this)
        appContext = flutterPluginBinding.applicationContext

        flutterPluginBinding.platformViewRegistry.registerViewFactory(
            SmileIDDocumentVerification.VIEW_TYPE_ID,
            SmileIDDocumentVerification.Factory(flutterPluginBinding.binaryMessenger),
        )

        flutterPluginBinding.platformViewRegistry.registerViewFactory(
            SmileIDSmartSelfieEnrollment.VIEW_TYPE_ID,
            SmileIDSmartSelfieEnrollment.Factory(flutterPluginBinding.binaryMessenger),
        )

        flutterPluginBinding.platformViewRegistry.registerViewFactory(
            SmileIDSmartSelfieAuthentication.VIEW_TYPE_ID,
            SmileIDSmartSelfieAuthentication.Factory(flutterPluginBinding.binaryMessenger),
        )

        flutterPluginBinding.platformViewRegistry.registerViewFactory(
            SmileIDBiometricKYC.VIEW_TYPE_ID,
            SmileIDBiometricKYC.Factory(flutterPluginBinding.binaryMessenger),
        )

        flutterPluginBinding.platformViewRegistry.registerViewFactory(
            SmileIDEnhancedDocumentVerification.VIEW_TYPE_ID,
            SmileIDEnhancedDocumentVerification.Factory(flutterPluginBinding.binaryMessenger),
        )
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        SmileIDApi.setUp(binding.binaryMessenger, null)
    }

    override fun initialize() {
        SmileID.initialize(context = appContext, enableCrashReporting = false)
    }

    override fun setEnvironment(useSandbox: Boolean) {
        SmileID.setEnvironment(useSandbox = useSandbox)
    }

    override fun setCallbackUrl(callbackUrl: String) {
        SmileID.setCallbackUrl(callbackUrl = URL(callbackUrl))
    }

    override fun authenticate(
        request: FlutterAuthenticationRequest,
        callback: (Result<FlutterAuthenticationResponse>) -> Unit,
    ) = launch(
        work = { SmileID.api.authenticate(request.toRequest()).toResponse() },
        callback = callback,
    )

    override fun prepUpload(
        request: FlutterPrepUploadRequest,
        callback: (Result<FlutterPrepUploadResponse>) -> Unit,
    ) = launch(
        work = { SmileID.api.prepUpload(request.toRequest()).toResponse() },
        callback = callback,
    )

    override fun upload(
        url: String,
        request: FlutterUploadRequest,
        callback: (Result<Unit>) -> Unit,
    ) = launch(
        work = { SmileID.api.upload(url, request.toRequest()) },
        callback = callback,
    )

    override fun doEnhancedKyc(
        request: FlutterEnhancedKycRequest,
        callback: (Result<FlutterEnhancedKycResponse>) -> Unit,
    ) = launch(
        work = { SmileID.api.doEnhancedKyc(request.toRequest()).toResponse() },
        callback = callback,
    )

    override fun doEnhancedKycAsync(
        request: FlutterEnhancedKycRequest,
        callback: (Result<FlutterEnhancedKycAsyncResponse>) -> Unit,
    ) = launch(
        work = { SmileID.api.doEnhancedKycAsync(request.toRequest()).toResponse() },
        callback = callback,
    )

    override fun getSmartSelfieJobStatus(
        request: FlutterJobStatusRequest,
        callback: (Result<FlutterSmartSelfieJobStatusResponse>) -> Unit,
    ) = launch(
        work = { SmileID.api.getSmartSelfieJobStatus(request.toRequest()).toResponse() },
        callback = callback,
    )

    override fun getDocumentVerificationJobStatus(
        request: FlutterJobStatusRequest,
        callback: (Result<FlutterDocumentVerificationJobStatusResponse>) -> Unit,
    ) = launch(
        work = { SmileID.api.getDocumentVerificationJobStatus(request.toRequest()).toResponse() },
        callback = callback,
    )

    override fun getBiometricKycJobStatus(
        request: FlutterJobStatusRequest,
        callback: (Result<FlutterBiometricKycJobStatusResponse>) -> Unit,
    ) = launch(
        work = { SmileID.api.getBiometricKycJobStatus(request.toRequest()).toResponse() },
        callback = callback,
    )

    override fun getEnhancedDocumentVerificationJobStatus(
        request: FlutterJobStatusRequest,
        callback: (Result<FlutterEnhancedDocumentVerificationJobStatusResponse>) -> Unit,
    ) = launch(
        work = {
            SmileID.api.getEnhancedDocumentVerificationJobStatus(request.toRequest()).toResponse()
        },
        callback = callback,
    )

    override fun getProductsConfig(
        request: FlutterProductsConfigRequest,
        callback: (Result<FlutterProductsConfigResponse>) -> Unit,
    ) = launch(
        work = { SmileID.api.getProductsConfig(request.toRequest()).toResponse() },
        callback = callback,
    )

    override fun getValidDocuments(
        request: FlutterProductsConfigRequest,
        callback: (Result<FlutterValidDocumentsResponse>) -> Unit,
    ) = launch(
        work = { SmileID.api.getValidDocuments(request.toRequest()).toResponse() },
        callback = callback,
    )

    override fun getServices(
        callback: (Result<FlutterServicesResponse>) -> Unit,
    ) = launch(
        work = { SmileID.api.getServices().toResponse() },
        callback = callback,
    )

    /**
     * https://stackoverflow.com/a/62206235
     *
     * We can get the context in a ActivityAware way, without asking users to pass the context when
     * calling "initialize" on the sdk
     */
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.activity = binding.activity
    }

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
    scope: CoroutineScope = CoroutineScope(Dispatchers.IO),
) {
    val handler = CoroutineExceptionHandler { _, throwable ->
        callback.invoke(Result.failure(throwable))
    }
    scope.launch(handler) {
        callback.invoke(Result.success(work()))
    }
}
