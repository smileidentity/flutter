package com.smileidentity.flutter.utils

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
