package com.smileidentity.flutter.views

import SmileIDProductsResultApi
import android.content.Context
import com.smileidentity.util.randomJobId
import com.smileidentity.util.randomUserId
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

/**
 * Common helper methods and utilities for SmileID platform views
 */
internal abstract class SmileIDPlatformView protected constructor(
    context: Context,
    args: Map<String, Any?>,
    protected val api: SmileIDProductsResultApi,
) : SmileComposablePlatformView(context, args) {

    @Suppress("UNCHECKED_CAST")
    protected fun getExtraPartnerParams(args: Map<String, Any?>): Map<String, String> =
        args["extraPartnerParams"] as? Map<String, String> ?: emptyMap()

    protected fun getUserId(args: Map<String, Any?>): String =
        args["userId"] as? String ?: randomUserId()

    protected fun getJobId(args: Map<String, Any?>): String =
        args["jobId"] as? String ?: randomJobId()

    protected fun getBoolean(args: Map<String, Any?>, key: String, defaultValue: Boolean): Boolean =
        args[key] as? Boolean ?: defaultValue

    protected fun getString(
        args: Map<String, Any?>,
        key: String,
        defaultValue: String = "",
    ): String = args[key] as? String ?: defaultValue
}

/**
 * Generic factory for creating SmileID platform views
 */
internal class SmileIDViewFactory<V : PlatformView>(
    private val api: SmileIDProductsResultApi,
    private val creator: (
        Context,
        Map<String, Any?>,
        SmileIDProductsResultApi,
    ) -> V,
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        @Suppress("UNCHECKED_CAST")
        return creator(context, args as Map<String, Any?>, api)
    }
}
