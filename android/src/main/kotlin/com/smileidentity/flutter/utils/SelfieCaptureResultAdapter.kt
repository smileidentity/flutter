package com.smileidentity.flutter.utils

import com.smileidentity.flutter.SmartSelfieCaptureResult
import com.squareup.moshi.FromJson
import com.squareup.moshi.JsonAdapter
import com.squareup.moshi.JsonReader
import com.squareup.moshi.JsonWriter
import com.squareup.moshi.Moshi
import com.squareup.moshi.ToJson
import java.io.File
import java.lang.reflect.Type

class SelfieCaptureResultAdapter : JsonAdapter<SmartSelfieCaptureResult>() {
    @FromJson
    override fun fromJson(reader: JsonReader): SmartSelfieCaptureResult {
        reader.beginObject()
        var selfieFile: File? = null
        var livenessFiles: List<File>? = null
        while (reader.hasNext()) {
            when (reader.nextName()) {
                "selfieFile" -> selfieFile = reader.nextString()?.let { File(it) }
                "livenessFiles" -> {
                    reader.beginArray()
                    val files = mutableListOf<File>()
                    while (reader.hasNext()) {
                        reader.nextString()?.let { files.add(File(it)) }
                    }
                    reader.endArray()
                    livenessFiles = files
                }
                else -> reader.skipValue()
            }
        }
        reader.endObject()
        return SmartSelfieCaptureResult(selfieFile, livenessFiles)
    }

    @ToJson
    override fun toJson(
        writer: JsonWriter,
        value: SmartSelfieCaptureResult?,
    ) {
        if (value == null) {
            writer.nullValue()
            return
        }
        writer.beginObject()
        writer.name("selfieFile").value(value.selfieFile?.absolutePath)
        writer.name("livenessFiles")
        writer.beginArray()
        value.livenessFiles?.forEach { file ->
            writer.value(file.absolutePath)
        }
        writer.endArray()
        writer.endObject()
    }

    companion object {
        val FACTORY =
            object : Factory {
                override fun create(
                    type: Type,
                    annotations: Set<Annotation>,
                    moshi: Moshi,
                ): JsonAdapter<*>? =
                    if (type ==
                        SmartSelfieCaptureResult::class.java
                    ) {
                        SelfieCaptureResultAdapter()
                    } else {
                        null
                    }
            }
    }
}
