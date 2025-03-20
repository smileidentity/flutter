package com.smileidentity.flutter

import android.content.Context
import com.smileidentity.SmileID
import com.smileidentity.flutter.results.SmartSelfieCaptureResult
import com.smileidentity.flutter.utils.SelfieCaptureResultAdapter
import com.smileidentity.results.SmartSelfieResult
import com.smileidentity.results.SmileIDResult
import io.flutter.plugin.common.BinaryMessenger

internal abstract class SmileSelfieComposablePlatformView(
    context: Context,
    viewTypeId: String,
    viewId: Int,
    messenger: BinaryMessenger,
    args: Map<String, Any?>,
) : SmileComposablePlatformView(context, viewTypeId, viewId, messenger, args) {
    protected fun handleResult(res: SmileIDResult<SmartSelfieResult>) {
        when (res) {
            is SmileIDResult.Success -> {
                val result =
                    SmartSelfieCaptureResult(
                        selfieFile = res.data.selfieFile,
                        livenessFiles = res.data.livenessFiles,
                        apiResponse = res.data.apiResponse,
                    )
                val moshi =
                    SmileID.moshi
                        .newBuilder()
                        .add(SelfieCaptureResultAdapter.FACTORY)
                        .build()
                val json =
                    try {
                        moshi
                            .adapter(SmartSelfieCaptureResult::class.java)
                            .toJson(result)
                    } catch (e: Exception) {
                        onError(e)
                        return
                    }
                json?.let { js ->
                    onSuccessJson(js)
                }
            }

            is SmileIDResult.Error -> onError(res.throwable)
        }
    }
}
