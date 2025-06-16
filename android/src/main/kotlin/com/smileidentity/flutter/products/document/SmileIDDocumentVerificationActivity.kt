package com.smileidentity.flutter.products.document

import android.content.Intent
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import com.smileidentity.SmileID
import com.smileidentity.compose.DocumentVerification
import com.smileidentity.flutter.mapper.pathList
import com.smileidentity.results.SmileIDResult
import com.smileidentity.util.randomJobId
import com.smileidentity.util.randomUserId
import java.io.File
import kotlinx.collections.immutable.toImmutableMap

class SmileIDDocumentVerificationActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val countryCode = intent.getStringExtra("countryCode") ?: ""
        val documentType = intent.getStringExtra("documentType")
        val idAspectRatio =
            intent.getDoubleExtra("idAspectRatio", -1.0).let {
                if (it == -1.0) return@let null
                return@let it.toFloat()
            }
        val captureBothSides = intent.getBooleanExtra("captureBothSides", true)
        val bypassSelfieCaptureWithFile =
            intent.getStringExtra("bypassSelfieCaptureWithFile")?.let {
                File(it)
            }
        val userId = intent.getStringExtra("userId") ?: randomUserId()
        val jobId = intent.getStringExtra("jobId") ?: randomJobId()
        val allowNewEnroll = intent.getBooleanExtra("allowNewEnroll", false)
        val showAttribution = intent.getBooleanExtra("showAttribution", true)
        val allowAgentMode = intent.getBooleanExtra("allowAgentMode", false)
        val allowGalleryUpload = intent.getBooleanExtra("allowGalleryUpload", false)
        val showInstructions = intent.getBooleanExtra("showInstructions", true)
        val skipApiSubmission = intent.getBooleanExtra("skipApiSubmission", false)
        val extraPartnerParamsBundle = intent.getBundleExtra("extraPartnerParams")
        val extraPartnerParams =
            extraPartnerParamsBundle?.keySet()?.associateWith {
                extraPartnerParamsBundle.getString(it)
            } as? Map<String, String> ?: emptyMap()

        setContent {
            SmileID.DocumentVerification(
                countryCode = countryCode,
                documentType = documentType,
                idAspectRatio = idAspectRatio,
                captureBothSides = captureBothSides,
                bypassSelfieCaptureWithFile = bypassSelfieCaptureWithFile,
                userId = userId,
                jobId = jobId,
                allowNewEnroll = allowNewEnroll,
                showAttribution = showAttribution,
                allowAgentMode = allowAgentMode,
                allowGalleryUpload = allowGalleryUpload,
                showInstructions = showInstructions,
//                skipApiSubmission = skipApiSubmission, // todo fix me
                extraPartnerParams = extraPartnerParams.toImmutableMap(),
            ) {
                val intent = Intent()
                when (it) {
                    is SmileIDResult.Success -> {
                        intent.putExtra("selfieFile", it.data.selfieFile.absolutePath)
                        intent.putExtra("documentFrontFile", it.data.documentFrontFile.absolutePath)
                        intent.putStringArrayListExtra(
                            "livenessFiles",
                            it.data.livenessFiles?.pathList(),
                        )
                        intent.putExtra("documentBackFile", it.data.documentBackFile?.absolutePath)
                        intent.putExtra(
                            "didSubmitDocumentVerificationJob",
                            it.data.didSubmitDocumentVerificationJob,
                        )

                        setResult(RESULT_OK, intent)
                        finish()
                    }

                    is SmileIDResult.Error -> {
                        intent.putExtra("error", it.throwable.message)
                        setResult(RESULT_CANCELED, intent)
                        finish()
                    }
                }
            }
        }
    }

    companion object {
        const val REQUEST_CODE = 17
    }
}
