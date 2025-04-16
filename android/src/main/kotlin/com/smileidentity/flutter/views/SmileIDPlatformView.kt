package com.smileidentity.flutter.views

import SmileIDProductsResultApi
import android.content.Context
import com.smileidentity.util.randomJobId
import com.smileidentity.util.randomUserId
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

/**
 * Common helper methods and utilities for SmileID platform views
 */
internal abstract class SmileIDPlatformView protected constructor(
    context: Context,
    viewTypeId: String,
    viewId: Int,
    messenger: BinaryMessenger,
    args: Map<String, Any?>,
    protected val api: SmileIDProductsResultApi,
) : SmileComposablePlatformView(context, viewTypeId, viewId, messenger, args) {

    protected fun getExtraPartnerParams(args: Map<String, Any?>): Map<String, String> {
        return args["extraPartnerParams"] as? Map<String, String> ?: emptyMap()
    }

    protected fun getUserId(args: Map<String, Any?>): String {
        return args["userId"] as? String ?: randomUserId()
    }

    protected fun getJobId(args: Map<String, Any?>): String {
        return args["jobId"] as? String ?: randomJobId()
    }

    protected fun getBoolean(args: Map<String, Any?>, key: String, defaultValue: Boolean): Boolean {
        return args[key] as? Boolean ?: defaultValue
    }

    protected fun getString(
        args: Map<String, Any?>,
        key: String,
        defaultValue: String = "",
    ): String {
        return args[key] as? String ?: defaultValue
    }
}

/**
 * Generic factory for creating SmileID platform views
 */
internal class SmileIDViewFactory<V : PlatformView>(
    private val messenger: BinaryMessenger,
    private val api: SmileIDProductsResultApi,
    private val creator: (
        Context,
        Int,
        BinaryMessenger,
        Map<String, Any?>,
        SmileIDProductsResultApi,
    ) -> V,
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        @Suppress("UNCHECKED_CAST")
        return creator(context, viewId, messenger, args as Map<String, Any?>, api)
    }
}
