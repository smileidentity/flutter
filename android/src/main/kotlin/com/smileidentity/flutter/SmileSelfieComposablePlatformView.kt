package com.smileidentity.flutter

import android.content.Context
import com.smileidentity.SmileID
import com.smileidentity.flutter.results.SmileIDCaptureResult
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
    protected open fun handleResult(res: SmileIDResult<SmartSelfieResult>) {
        when (res) {
            is SmileIDResult.Success -> {
                val json =
                    try {
                        SmileID.moshi
                            .adapter(
                                SmileIDCaptureResult.SmartSelfieCaptureResponse::class.java,
                            ).toJson(
                                SmileIDCaptureResult.SmartSelfieCaptureResponse(
                                    selfieFile = res.data.selfieFile.absolutePath,
                                    livenessFiles =
                                        res.data.livenessFiles.map { file ->
                                            file.absolutePath
                                        },
                                    apiResponse = res.data.apiResponse,
                                ),
                            )
                    } catch (e: Exception) {
                        onError(e)
                        return@handleResult
                    }
                json?.let { js ->
                    onSuccessJson(js)
                }
            }

            is SmileIDResult.Error -> onError(res.throwable)
        }
    }
}
