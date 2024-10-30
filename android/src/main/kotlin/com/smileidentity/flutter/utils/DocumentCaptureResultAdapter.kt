package com.smileidentity.flutter.utils
import com.smileidentity.react.results.DocumentCaptureResult
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
        var selfieFile: File? = null
        var frontFile: File? = null
        var backFile: File? = null
        var livenessFiles: MutableList<File>? = null
        var didSubmitDocumentVerificationJob: Boolean? = null
        var didSubmitEnhancedDocVJob: Boolean? = null

        while (reader.hasNext()) {
            when (reader.nextName()) {
                "selfieFile" -> selfieFile = reader.nextString()?.let { File(it) }
                "documentFrontFile" -> frontFile = reader.nextString()?.let { File(it) }
                "documentBackFile" -> backFile = reader.nextString()?.let { File(it) }
                "livenessFiles" -> {
                    livenessFiles = mutableListOf()
                    reader.beginArray()
                    while (reader.hasNext()) {
                        reader.nextString()?.let { livenessFiles.add(File(it)) }
                    }
                    reader.endArray()
                }

                "didSubmitDocumentVerificationJob" -> didSubmitDocumentVerificationJob =
                    reader.nextBoolean()

                "didSubmitEnhancedDocVJob" -> didSubmitEnhancedDocVJob = reader.nextBoolean()
                else -> reader.skipValue()
            }
        }
        reader.endObject()

        return DocumentCaptureResult(
            selfieFile = selfieFile,
            documentFrontFile = frontFile,
            documentBackFile = backFile,
            livenessFiles = livenessFiles,
            didSubmitDocumentVerificationJob = didSubmitDocumentVerificationJob,
            didSubmitEnhancedDocVJob = didSubmitEnhancedDocVJob
        )
    }

    @ToJson
    override fun toJson(writer: JsonWriter, value: DocumentCaptureResult?) {
        if (value == null) {
            writer.nullValue()
            return
        }

        writer.beginObject()
        writer.name("selfieFile").value(value.selfieFile?.absolutePath)
        writer.name("documentFrontFile").value(value.documentFrontFile?.absolutePath)
        writer.name("documentBackFile").value(value.documentBackFile?.absolutePath)

        writer.name("livenessFiles")
        if (value.livenessFiles == null) {
            writer.nullValue()
        } else {
            writer.beginArray()
            for (file in value.livenessFiles) {
                writer.value(file.absolutePath)
            }
            writer.endArray()
        }

        writer.name("didSubmitDocumentVerificationJob").value(value.didSubmitDocumentVerificationJob)
        writer.name("didSubmitEnhancedDocVJob").value(value.didSubmitEnhancedDocVJob)

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
