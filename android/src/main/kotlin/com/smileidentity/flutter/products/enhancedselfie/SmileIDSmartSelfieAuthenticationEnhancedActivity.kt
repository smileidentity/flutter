package com.smileidentity.flutter.products.enhancedselfie

import android.content.Intent
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import com.smileidentity.SmileID
import com.smileidentity.compose.SmartSelfieAuthenticationEnhanced
import com.smileidentity.flutter.mapper.buildBundle
import com.smileidentity.flutter.mapper.pathList
import com.smileidentity.results.SmileIDResult
import com.smileidentity.util.randomUserId
import kotlinx.collections.immutable.toImmutableMap

class SmileIDSmartSelfieAuthenticationEnhancedActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val userId = intent.getStringExtra("userId") ?: randomUserId()
        val allowNewEnroll = intent.getBooleanExtra("allowNewEnroll", false)
        val showAttribution = intent.getBooleanExtra("showAttribution", true)
        val showInstructions = intent.getBooleanExtra("showInstructions", true)
        val extraPartnerParamsBundle = intent.getBundleExtra("extraPartnerParams")
        val extraPartnerParams =
            extraPartnerParamsBundle?.keySet()?.associateWith {
                extraPartnerParamsBundle.getString(it)
            } as? Map<String, String> ?: emptyMap()

        setContent {
            SmileID.SmartSelfieAuthenticationEnhanced(
                userId = userId,
                allowNewEnroll = allowNewEnroll,
                showAttribution = showAttribution,
                showInstructions = showInstructions,
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
                        intent.putExtra("apiResponse", it.data.apiResponse?.buildBundle())

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
        const val REQUEST_CODE = 15
    }
}
