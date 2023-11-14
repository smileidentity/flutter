# Changelog

# 10.0.0-beta06
- [Android] Added `extras` as optional params on all job types
- [Android] Added `idAuthorityBypassPhoto` on Sandbox BiometricKYC jobs
- [Android] Added `allowAgentMode` option on Document Verification and Enhanced Document Verification
- [Flutter] Fixed wrong iOS decoding bug on success

# 10.0.0-beta05
- [Android] Fixed retry document submission on failed document submission
- [Android] Fixed missing entered key in BiometricKYC
- [Android] Added jobId on SmartSelfieEnrollmentFragment and SmartSelfieAuthenticationFragment
- [Android] Added showInstructions on SmartSelfieEnrollmentFragment
- [Android] Fix bug where showAttirubtion was not respected on the Consent Denied screen
- [Android] Increased selfie capture resolution to 640px
- [Android] Fixed a bug where the document preview showed a black box for some older devices
- 
# 10.0.0-beta04
- [Android] Fix bug where Composable state did not get reset 

# 10.0.0-beta03
- Allow setEnvironment({required bool useSandbox}) to enable sandbox or production environment
- Allow setCallbackUrl({required Uri callbackUrl}) to set a callback url for all submitted jobs.
- Bug Fixes and Improvements from iOS v10.0.0-beta10 and Android v10.0.0-beta09

# 10.0.0-beta02
- Support for Document Verification, exposed as a `SmileIDDocumentVerification` Widget
- Support for SmartSelfie Authentication, exposed as a `SmileIDSmartSelfieAuthentication` Widget

# 10.0.0-beta01
- Initial release
- Support for Enhanced KYC (Async)
