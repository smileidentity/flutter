package com.smileidentity.flutter.products.enhanceddocv

import android.content.Context
import androidx.compose.runtime.Composable
import com.smileidentity.SmileID
import com.smileidentity.compose.EnhancedDocumentVerificationScreen
import com.smileidentity.flutter.results.DocumentCaptureResult
import com.smileidentity.flutter.utils.DocumentCaptureResultAdapter
import com.smileidentity.flutter.utils.getCurrentIsoTimestamp
import com.smileidentity.flutter.views.SmileComposablePlatformView
import com.smileidentity.flutter.views.SmileIDViewFactory
import com.smileidentity.models.ConsentInformation
import com.smileidentity.models.ConsentedInformation
import com.smileidentity.results.SmileIDResult
import com.smileidentity.util.randomJobId
import com.smileidentity.util.randomUserId
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformViewFactory
import kotlinx.collections.immutable.toImmutableMap

internal class SmileIDEnhancedDocumentVerification private constructor(
    context: Context,
    viewId: Int,
    messenger: BinaryMessenger,
    args: Map<String, Any?>,
) : SmileComposablePlatformView(context, VIEW_TYPE_ID, viewId, messenger, args) {
    companion object {
        const val VIEW_TYPE_ID = "SmileIDEnhancedDocumentVerification"

        fun createFactory(messenger: BinaryMessenger): PlatformViewFactory =
            SmileIDViewFactory(messenger = messenger) { context, args, messenger, viewId ->
                SmileIDEnhancedDocumentVerification(
                    context = context,
                    viewId = viewId,
                    messenger = messenger,
                    args = args,
                )
            }
    }

    @Composable
    override fun Content(args: Map<String, Any?>) {
        val extraPartnerParams = args["extraPartnerParams"] as? Map<String, String> ?: emptyMap()
        val consentInformation: ConsentInformation? = run {
            val consentGrantedDate = args["consentGrantedDate"] as? String
            val personalDetails = args["personalDetailsConsentGranted"] as? Boolean
            val contactInformation = args["contactInfoConsentGranted"] as? Boolean
            val documentInformation = args["documentInfoConsentGranted"] as? Boolean

            if (consentGrantedDate != null && personalDetails != null &&
                contactInformation != null && documentInformation != null
            ) {
                ConsentInformation(
                    consented = ConsentedInformation(
                        consentGrantedDate = consentGrantedDate,
                        personalDetails = personalDetails,
                        contactInformation = contactInformation,
                        documentInformation = documentInformation,
                    )
                )
            } else {
                null
            }
        }

        SmileID.EnhancedDocumentVerificationScreen(
            countryCode = args["countryCode"] as String,
            documentType = args["documentType"] as? String,
            idAspectRatio = (args["idAspectRatio"] as Double?)?.toFloat(),
            captureBothSides = args["captureBothSides"] as? Boolean ?: true,
            userId = args["userId"] as? String ?: randomUserId(),
            jobId = args["jobId"] as? String ?: randomJobId(),
            enableAutoCapture = args["enableAutoCapture"] as? Boolean ?: true,
            allowNewEnroll = args["allowNewEnroll"] as? Boolean ?: false,
            showAttribution = args["showAttribution"] as? Boolean ?: true,
            allowAgentMode = args["allowAgentMode"] as? Boolean ?: false,
            allowGalleryUpload = args["allowGalleryUpload"] as? Boolean ?: false,
            showInstructions = args["showInstructions"] as? Boolean ?: true,
            useStrictMode = args["useStrictMode"] as? Boolean ?: false,
            consentInformation = ConsentInformation(consented = consentInformation),
            extraPartnerParams = extraPartnerParams.toImmutableMap(),
        ) {
            when (it) {
                is SmileIDResult.Success -> {
                    val result =
                        DocumentCaptureResult(
                            selfieFile = it.data.selfieFile,
                            documentFrontFile = it.data.documentFrontFile,
                            livenessFiles = it.data.livenessFiles,
                            documentBackFile = it.data.documentBackFile,
                            didSubmitEnhancedDocVJob = it.data.didSubmitEnhancedDocVJob,
                        )
                    val moshi =
                        SmileID.moshi
                            .newBuilder()
                            .add(DocumentCaptureResultAdapter.FACTORY)
                            .build()
                    val json =
                        try {
                            moshi
                                .adapter(DocumentCaptureResult::class.java)
                                .toJson(result)
                        } catch (e: Exception) {
                            onError(e)
                            return@EnhancedDocumentVerificationScreen
                        }
                    json?.let { js ->
                        onSuccessJson(js)
                    }
                }

                is SmileIDResult.Error -> onError(it.throwable)
            }
        }
    }
}
