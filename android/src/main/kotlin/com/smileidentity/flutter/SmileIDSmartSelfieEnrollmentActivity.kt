package com.smileidentity.flutter

import android.content.Intent
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import com.smileidentity.SmileID
import com.smileidentity.compose.SmartSelfieEnrollment
import com.smileidentity.models.v2.SmartSelfieResponse
import com.smileidentity.results.SmileIDResult
import com.smileidentity.util.randomUserId
import kotlinx.collections.immutable.toImmutableMap
import java.io.File

class SmileIDSmartSelfieEnrollmentActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val userId = intent.getStringExtra("userId") ?: randomUserId()
        val allowNewEnroll = intent.getBooleanExtra("allowNewEnroll", false)
        val allowAgentMode = intent.getBooleanExtra("allowAgentMode", false)
        val showAttribution = intent.getBooleanExtra("showAttribution", true)
        val showInstructions = intent.getBooleanExtra("showInstructions", true)
        val skipApiSubmission = intent.getBooleanExtra("skipApiSubmission", false)
        val extraPartnerParamsBundle = intent.getBundleExtra("extraPartnerParams")
        val extraPartnerParams =
            extraPartnerParamsBundle?.keySet()?.associateWith {
                extraPartnerParamsBundle.getString(it)
            } as? Map<String, String> ?: emptyMap()

        setContent {
            SmileID.SmartSelfieEnrollment(
                userId = userId,
                allowNewEnroll = allowNewEnroll,
                allowAgentMode = allowAgentMode,
                showAttribution = showAttribution,
                showInstructions = showInstructions,
                skipApiSubmission = skipApiSubmission,
                extraPartnerParams = extraPartnerParams.toImmutableMap(),
            ) {
                val intent = Intent()
                when (it) {
                    is SmileIDResult.Success -> {
                        intent.putExtra("selfieFile", it.data.selfieFile.absolutePath)
                        intent.putStringArrayListExtra(
                            "livenessFiles",
                            it.data.livenessFiles.pathList(),
                        )

                        intent.putExtra(
                            "apiResponse",
                            it.data.apiResponse?.buildBundle(),
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
        const val REQUEST_CODE = 12
    }
}

private fun List<File>.pathList(): ArrayList<String> {
    val list = ArrayList<String>()
    this.forEach {
        list.add(it.absolutePath)
    }
    return list
}

private fun SmartSelfieResponse.buildBundle(): Bundle {
    val bundle = Bundle()
    bundle.putString("code", code)
    bundle.putString("created_at", createdAt)
    bundle.putString("job_id", jobId)
    bundle.putString("job_type", jobType.name)
    bundle.putString("message", message)
    bundle.putString("partner_id", partnerId)
    bundle.putBundle(
        "partner_params",
        Bundle().apply {
            partnerParams.forEach {
                putString(it.key, it.value)
            }
        },
    )
    bundle.putString("status", status.name)
    bundle.putString("updated_at", updatedAt)
    bundle.putString("user_id", userId)
    return bundle
}
