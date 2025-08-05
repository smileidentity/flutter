package com.smileidentity.flutter.utils

import com.smileidentity.models.ConsentInformation
import com.smileidentity.models.ConsentedInformation
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import java.util.TimeZone

/**
 * Converts current time to ISO8601 string with milliseconds in UTC
 * Format: yyyy-MM-dd'T'HH:mm:ss.SSS'Z'
 */
internal fun getCurrentIsoTimestamp(): String {
    val pattern = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    val sdf = SimpleDateFormat(pattern, Locale.US)
    sdf.timeZone = TimeZone.getTimeZone("UTC")
    return sdf.format(Date())
}

/**
 * Builds a [ConsentInformation] object if all required parameters are provided.
 * Returns null if any of the parameters are missing.
 *
 * @param consentGrantedDate The date when consent was granted, in ISO8601 format.
 * @param personalDetails Indicates if consent for personal details is granted.
 * @param contactInformation Indicates if consent for contact information is granted.
 * @param documentInformation Indicates if consent for document information is granted.
 * @return A [ConsentInformation] object or null if any parameter is missing.
 */
fun buildConsentInformation(
    consentGrantedDate: String?,
    personalDetails: Boolean?,
    contactInformation: Boolean?,
    documentInformation: Boolean?,
): ConsentInformation? {
    return if (
        consentGrantedDate != null &&
        personalDetails != null &&
        contactInformation != null &&
        documentInformation != null
    ) {
        ConsentInformation(
            consented = ConsentedInformation(
                consentGrantedDate = consentGrantedDate,
                personalDetails = personalDetails,
                contactInformation = contactInformation,
                documentInformation = documentInformation,
            ),
        )
    } else {
        null
    }
}
