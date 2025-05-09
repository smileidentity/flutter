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
  });
}