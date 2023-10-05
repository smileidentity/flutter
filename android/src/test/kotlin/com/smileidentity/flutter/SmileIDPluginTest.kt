package com.smileidentity.flutter

import FlutterAuthenticationRequest
import FlutterAuthenticationResponse
import FlutterEnhancedKycAsyncResponse
import FlutterEnhancedKycRequest
import SmileIDApi
import io.mockk.coEvery
import io.mockk.coVerify
import io.mockk.confirmVerified
import io.mockk.mockk
import kotlin.test.Test

/*
 * This demonstrates a simple unit test of the Kotlin portion of this plugin's implementation.
 *
 * Once you have built the plugin's example app, you can run these tests from the command
 * line by running `./gradlew testDebugUnitTest` in the `example/android/` directory, or
 * you can run them directly from IDEs that support JUnit such as Android Studio.
 */
internal class SmileIDPluginTest {

    @Test
    fun `when we call authenticate and pass a request object, we get a successful callback`() {
        val request = mockk<FlutterAuthenticationRequest>()
        val callback = mockk<(Result<FlutterAuthenticationResponse>) -> Unit>()
        val api = mockk<SmileIDApi>()

        coEvery {
            api.authenticate(
                request = request,
                callback = callback,
            )
        } returns Unit

        api.authenticate(
            request = request,
            callback = callback,
        )

        coVerify {
            api.authenticate(
                request = request,
                callback = callback,
            )
        }

        confirmVerified(api)
    }

    // ktlint-disable max-line-length
    @Test
    fun `when we call doEnhancedKycAsync and pass a request object, we get a successful callback`() {
        val request = mockk<FlutterEnhancedKycRequest>()
        val callback = mockk<(Result<FlutterEnhancedKycAsyncResponse>) -> Unit>()
        val api = mockk<SmileIDApi>()

        coEvery {
            api.doEnhancedKycAsync(
                request = request,
                callback = callback,
            )
        } returns Unit

        api.doEnhancedKycAsync(
            request = request,
            callback = callback,
        )

        coVerify {
            api.doEnhancedKycAsync(
                request = request,
                callback = callback,
            )
        }

        confirmVerified(api)
    }
}
