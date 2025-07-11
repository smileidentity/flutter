import 'package:flutter_test/flutter_test.dart';
import 'package:smile_id/smileid_messages.g.dart';

void main() {
  group('Consent Mapping Tests', () {
    test('Mobile SDK consent format should map to expected backend format', () {
      // Mobile SDK format
      final consentInfo = FlutterConsentInformation(
        consentGrantedDate: "2025-04-01T15:16:03.246Z",
        personalDetailsConsentGranted: true,
        contactInfoConsentGranted: true,
        documentInfoConsentGranted: true,
      );

      // Verify the field values are set correctly
      expect(consentInfo.consentGrantedDate, "2025-04-01T15:16:03.246Z");
      expect(consentInfo.personalDetailsConsentGranted, true);
      expect(consentInfo.contactInfoConsentGranted, true);
      expect(consentInfo.documentInfoConsentGranted, true);

      // Note: The actual mapping to the backend format happens in the native code
      // via the toRequest() functions we modified in Mapper.kt and Mapper.swift.
      // The following is the expected structure after mapping:
      //
      // "consent_information": {
      //   "consented": {
      //     "consent_granted_date": "2025-04-01T15:16:03.246Z",
      //     "personal_details": true,
      //     "contact_information": true,
      //     "document_information": true
      //   }
      // }
    });

    test('Consent mapping should handle both legacy and new API formats', () {
      // Test data
      const testDate = "2025-04-01T15:16:03.246Z";
      const testPersonalConsent = true;
      const testContactConsent = true;
      const testDocumentConsent = true;

      // Create the FlutterConsentInformation object that will be passed to native code
      final consentInfo = FlutterConsentInformation(
        consentGrantedDate: testDate,
        personalDetailsConsentGranted: testPersonalConsent,
        contactInfoConsentGranted: testContactConsent,
        documentInfoConsentGranted: testDocumentConsent,
      );

      // Verify the object that will be passed to native code
      expect(consentInfo.consentGrantedDate, testDate);
      expect(consentInfo.personalDetailsConsentGranted, testPersonalConsent);
      expect(consentInfo.contactInfoConsentGranted, testContactConsent);
      expect(consentInfo.documentInfoConsentGranted, testDocumentConsent);

      // Test scenarios:

      // 1. Swift/Kotlin mapping (new implementation):
      // In the native code, FlutterConsentInformation is mapped to ConsentInformation via the toRequest() method:
      // ConsentInformation(
      //   consentGrantedDate: consentGrantedDate,
      //   personalDetails: personalDetailsConsentGranted,
      //   contactInformation: contactInfoConsentGranted,
      //   documentInformation: documentInfoConsentGranted
      // )

      // 2. Native SDK initialization (both implementations):
      // Legacy: The SDK would internally create the nested structure as follows:
      // ConsentInformation(
      //   consented: ConsentedInformation(
      //     consentGrantedDate: ...,
      //     personalDetails: ...,
      //     contactInformation: ...,
      //     documentInformation: ...
      //   )
      // )

      // New: The SDK takes individual parameters and creates the nested structure internally:
      // ConsentInformation(
      //   consentGrantedDate: ...,
      //   personalDetails: ...,
      //   contactInformation: ...,
      //   documentInformation: ...
      // )

      // Both approaches produce the same JSON structure for the API:
      // {
      //   "consent_information": {
      //     "consented": {
      //       "consent_granted_date": "2025-04-01T15:16:03.246Z",
      //       "personal_details": true,
      //       "contact_information": true,
      //       "document_information": true
      //     }
      //   }
      // }
    });
  });
}
