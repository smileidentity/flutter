package com.smileidentity.flutter

import android.content.Intent
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import com.smileidentity.SmileID
import com.smileidentity.compose.BiometricKYC
import com.smileidentity.models.IdInfo
import com.smileidentity.results.SmileIDResult
import com.smileidentity.util.randomJobId
import com.smileidentity.util.randomUserId
import kotlinx.collections.immutable.toImmutableMap

class SmileIDBiometricKYCActivity : ComponentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val country = intent.getStringExtra("country") ?: ""
        val idType = intent.getStringExtra("idType")
        val idNumber = intent.getStringExtra("idNumber")
        val firstName = intent.getStringExtra("firstName")
        val middleName = intent.getStringExtra("middleName")
        val lastName = intent.getStringExtra("lastName")
        val dob = intent.getStringExtra("dob")
        val bankCode = intent.getStringExtra("bankCode")
        val entered =
            if (intent.hasExtra("entered")) intent.getBooleanExtra("entered", false) else null
        val userId = intent.getStringExtra("userId") ?: randomUserId()
        val jobId = intent.getStringExtra("jobId") ?: randomJobId()
        val allowNewEnroll = intent.getBooleanExtra("allowNewEnroll", false)
        val allowAgentMode = intent.getBooleanExtra("allowAgentMode", false)
        val showAttribution = intent.getBooleanExtra("showAttribution", true)
        val showInstructions = intent.getBooleanExtra("showInstructions", true)
        val extraPartnerParamsBundle = intent.getBundleExtra("extraPartnerParams")
        val extraPartnerParams =
            extraPartnerParamsBundle?.keySet()?.associateWith {
                extraPartnerParamsBundle.getString(it)
            } as? Map<String, String> ?: emptyMap()

        setContent {
            SmileID.BiometricKYC(
                idInfo = IdInfo(
                    country = country,
                    idType = idType,
                    idNumber = idNumber,
                    firstName = firstName,
                    middleName = middleName,
                    lastName = lastName,
                    dob = dob,
                    bankCode = bankCode,
                    entered = entered,
                ),
                userId = userId,
                jobId = jobId,
                allowNewEnroll = allowNewEnroll,
                allowAgentMode = allowAgentMode,
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
                        intent.putExtra(
                            "didSubmitBiometricKycJob",
                            it.data.didSubmitBiometricKycJob,
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
        const val REQUEST_CODE = 16
    }
}