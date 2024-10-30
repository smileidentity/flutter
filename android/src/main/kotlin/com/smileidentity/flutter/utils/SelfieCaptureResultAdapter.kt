package com.smileidentity.flutter.utils

import com.smileidentity.SmileID
import com.smileidentity.models.v2.SmartSelfieResponse
import com.smileidentity.react.results.SmartSelfieCaptureResult
import com.squareup.moshi.FromJson
import com.squareup.moshi.JsonAdapter
import com.squareup.moshi.JsonAdapter.Factory
import com.squareup.moshi.JsonReader
import com.squareup.moshi.JsonWriter
import com.squareup.moshi.ToJson
import java.io.File

class SelfieCaptureResultAdapter : JsonAdapter<SmartSelfieCaptureResult>() {

    @FromJson
    override fun fromJson(reader: JsonReader): SmartSelfieCaptureResult {
        reader.beginObject()
        var selfieFile: File? = null
        var livenessFiles: List<File>? = null
        var apiResponse: SmartSelfieResponse? = null

        while (reader.hasNext()) {
            when (reader.nextName()) {
                "selfieFile" -> selfieFile = reader.nextString()?.let { File(it) }
                "livenessFiles" -> {
                    // Assuming livenessFiles is an array of file paths in the JSON
                    val files = mutableListOf<File>()
                    reader.beginArray()
                    while (reader.hasNext()) {
                        reader.nextString()?.let { files.add(File(it)) }
                    }
                    reader.endArray()
                    livenessFiles = files
                }

                "apiResponse" -> apiResponse =
                    SmileID.moshi.adapter(SmartSelfieResponse::class.java).fromJson(reader)

                else -> reader.skipValue()
            }
        }

        reader.endObject()
        return SmartSelfieCaptureResult(
            selfieFile = selfieFile,
            livenessFiles = livenessFiles,
            apiResponse = apiResponse
        )
    }

    @ToJson
    override fun toJson(writer: JsonWriter, value: SmartSelfieCaptureResult?) {
        if (value == null) {
            writer.nullValue()
            return
        }
        writer.beginObject()
        writer.name("selfieFile").value(value.selfieFile?.absolutePath)

        writer.name("livenessFiles")
        writer.beginArray()
        value.livenessFiles?.forEach { writer.value(it.absolutePath) }
        writer.endArray()

        writer.name("apiResponse")
        if (value.apiResponse != null) {
            SmileID.moshi.adapter(SmartSelfieResponse::class.java).toJson(writer, value.apiResponse)
        } else {
            writer.nullValue()
        }
        writer.endObject()
    }

    companion object {
        val FACTORY = Factory { type, annotations, moshi -> if (type == SmartSelfieCaptureResult::class.java) SelfieCaptureResultAdapter() else null }
    }
}
