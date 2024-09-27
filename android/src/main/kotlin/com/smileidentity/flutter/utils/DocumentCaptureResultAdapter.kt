package com.smileidentity.flutter.utils
import com.smileidentity.flutter.DocumentCaptureResult
import com.squareup.moshi.FromJson
import com.squareup.moshi.JsonAdapter
import com.squareup.moshi.JsonReader
import com.squareup.moshi.JsonWriter
import com.squareup.moshi.Moshi
import com.squareup.moshi.ToJson
import java.io.File
import java.lang.reflect.Type

class DocumentCaptureResultAdapter : JsonAdapter<DocumentCaptureResult>() {

    @FromJson
    override fun fromJson(reader: JsonReader): DocumentCaptureResult {
        reader.beginObject()
        var frontFile: File? = null
        var backFile: File? = null
        while (reader.hasNext()) {
            when (reader.nextName()) {
                "documentFrontFile" -> frontFile = reader.nextString()?.let { File(it) }
                "documentBackFile" -> backFile = reader.nextString()?.let { File(it) }
                else -> reader.skipValue()
            }
        }
        reader.endObject()
        return DocumentCaptureResult(frontFile, backFile)
    }

    @ToJson
    override fun toJson(writer: JsonWriter, value: DocumentCaptureResult?) {
        if (value == null) {
            writer.nullValue()
            return
        }
        writer.beginObject()
        writer.name("documentFrontFile").value(value.documentFrontFile?.absolutePath)
        writer.name("documentBackFile").value(value.documentBackFile?.absolutePath)
        writer.endObject()
    }

    companion object {
        val FACTORY = object : Factory {
            override fun create(
                type: Type,
                annotations: Set<Annotation>,
                moshi: Moshi
            ): JsonAdapter<*>? {
                return if (type == DocumentCaptureResult::class.java) DocumentCaptureResultAdapter() else null
            }
        }
    }
}