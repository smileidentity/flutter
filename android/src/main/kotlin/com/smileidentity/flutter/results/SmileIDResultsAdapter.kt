package com.smileidentity.flutter.results

import com.smileidentity.SmileID
import com.smileidentity.models.v2.SmartSelfieResponse
import com.squareup.moshi.FromJson
import com.squareup.moshi.JsonAdapter
import com.squareup.moshi.JsonReader
import com.squareup.moshi.JsonWriter
import com.squareup.moshi.ToJson
import java.io.File

open class SmileIDResultsAdapter<T : Any>(
    // selfie, front of doc, back of doc
    private val singleCapture: Map<String, (T) -> File?>,
    // liveness images
    private val livenessImages: Map<String, (T) -> List<File>?>,
    // docV, enhanced DocV, biometric kyc
    private val didSubmit: Map<String, (T) -> Boolean?>,
    // smart selfie response
    private val apiResponse: Map<String, (T) -> SmartSelfieResponse?>,
    private val createResult: (
        Map<String, File?>,
        Map<String, List<File>?>,
        Map<String, Boolean?>,
        Map<String, SmartSelfieResponse?>,
    ) -> T,
) : JsonAdapter<T>() {
    @FromJson
    override fun fromJson(reader: JsonReader): T {
        reader.beginObject()
        val fileValues = mutableMapOf<String, File?>()
        val fileListValues = mutableMapOf<String, List<File>?>()
        val booleanValues = mutableMapOf<String, Boolean?>()
        val apiResponseValues = mutableMapOf<String, SmartSelfieResponse?>()

        while (reader.hasNext()) {
            val name = reader.nextName()
            when {
                singleCapture.containsKey(name) -> {
                    fileValues[name] = reader.nextString()?.let { File(it) }
                }

                livenessImages.containsKey(name) -> {
                    val fileList = mutableListOf<File>()
                    reader.beginArray()
                    while (reader.hasNext()) {
                        reader.nextString()?.let { fileList.add(File(it)) }
                    }
                    reader.endArray()
                    fileListValues[name] = fileList
                }

                didSubmit.containsKey(name) -> {
                    booleanValues[name] = reader.nextBoolean()
                }

                apiResponse.containsKey(name) -> {
                    apiResponseValues[name] =
                        SmileID.moshi.adapter(SmartSelfieResponse::class.java).fromJson(reader)
                }

                else -> reader.skipValue()
            }
        }
        reader.endObject()

        return createResult(fileValues, fileListValues, booleanValues, apiResponseValues)
    }

    @ToJson
    override fun toJson(
        writer: JsonWriter,
        value: T?,
    ) {
        if (value == null) {
            writer.nullValue()
            return
        }

        writer.beginObject()

        singleCapture.forEach { (name, getter) ->
            writer.name(name).value(getter(value)?.absolutePath)
        }

        livenessImages.forEach { (name, getter) ->
            writer.name(name)
            val files = getter(value)
            if (files == null) {
                writer.nullValue()
            } else {
                writer.beginArray()
                for (file in files) {
                    writer.value(file.absolutePath)
                }
                writer.endArray()
            }
        }

        didSubmit.forEach { (name, getter) ->
            writer.name(name).value(getter(value))
        }

        apiResponse.forEach { (name, getter) ->
            writer.name(name)
            val apiResponse = getter(value)
            if (apiResponse == null) {
                writer.nullValue()
            } else {
                SmileID.moshi.adapter(SmartSelfieResponse::class.java).toJson(writer, apiResponse)
            }
        }

        writer.endObject()
    }

    companion object {
        inline fun <reified T : Any> create(
            singleCapture: Map<String, (T) -> File?> = emptyMap(),
            livenessImages: Map<String, (T) -> List<File>?> = emptyMap(),
            didSubmit: Map<String, (T) -> Boolean?> = emptyMap(),
            apiResponse: Map<String, (T) -> SmartSelfieResponse?> = emptyMap(),
            noinline createResult: (
                Map<String, File?>,
                Map<String, List<File>?>,
                Map<String, Boolean?>,
                Map<String, SmartSelfieResponse?>,
            ) -> T,
        ): SmileIDResultsAdapter<T> =
            SmileIDResultsAdapter(
                singleCapture,
                livenessImages,
                didSubmit,
                apiResponse,
                createResult,
            )

        fun createFactory(): Factory =
            Factory { type, _, _ ->
                when (type) {
                    SmileIDCaptureResult.SmartSelfieCapture::class.java -> SmileIDCaptureResultAdapterRegistry.selfieAdapter
                    SmileIDCaptureResult.SmartSelfieCaptureResponse::class.java -> SmileIDCaptureResultAdapterRegistry.smartSelfieAdapter
                    SmileIDCaptureResult.DocumentCaptureResult.DocumentCapture::class.java -> SmileIDCaptureResultAdapterRegistry.documentCaptureAdapter
                    SmileIDCaptureResult.DocumentCaptureResult.DocumentVerification::class.java -> SmileIDCaptureResultAdapterRegistry.documentVerificationAdapter
                    SmileIDCaptureResult.DocumentCaptureResult.EnhancedDocumentVerification::class.java -> SmileIDCaptureResultAdapterRegistry.enhancedDocumentAdapter
                    SmileIDCaptureResult.BiometricKYC::class.java -> SmileIDCaptureResultAdapterRegistry.biometricKycAdapter
                    else -> null
                }
            }
    }
}
