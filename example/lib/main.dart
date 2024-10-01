import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smile_id/smile_id_document_capture_view.dart';
import 'package:smile_id/smile_id_smart_selfie_capture_view.dart';
import 'package:smile_id/smileid_messages.g.dart';
import 'package:smile_id/smile_id.dart';
import 'package:smile_id/smile_id_biometric_kyc.dart';
import 'package:smile_id/smile_id_document_verification.dart';
import 'package:smile_id/smile_id_enhanced_document_verification.dart';
import 'package:smile_id/smile_id_smart_selfie_authentication.dart';
import 'package:smile_id/smile_id_smart_selfie_enrollment.dart';

// ignore_for_file: avoid_print

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    // replace with your own credentials
    SmileID.initialize(
      useSandbox: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Smile ID",
      // MainContent requires its own BuildContext for Navigator to work, hence it is defined as its
      // own widget
      home: MainContent(),
    );
  }
}

class MyScaffold extends StatelessWidget {
  final Widget body;

  const MyScaffold({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Smile ID"),
      ),
      body: body,
    );
  }
}

class MainContent extends StatelessWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        body: Center(
            child: Column(
      children: [
        enhancedKycAsyncButton(),
        documentVerificationButton(context),
        enhancedDocumentVerificationButton(context),
        smartSelfieEnrollmentButton(context),
        smartSelfieAuthenticationButton(context),
        biometricKycButton(context),
        selfieCaptureButton(context),
        documentCaptureButton(context)
      ],
    )));
  }

  Widget enhancedKycAsyncButton() {
    return ElevatedButton(
        child: const Text("Enhanced KYC (Async)"),
        onPressed: () {
          // replace with your own credentials
          SmileID.initialize(
            useSandbox: false,
          );
          var userId = "<your user's user ID>";
          SmileID.api
              .authenticate(FlutterAuthenticationRequest(
                jobType: FlutterJobType.enhancedKyc,
                userId: userId,
              ))
              .then(
                  (authResponse) => {
                        SmileID.api.doEnhancedKycAsync(FlutterEnhancedKycRequest(
                            country: "GH",
                            idType: "DRIVERS_LICENSE",
                            idNumber: "B0000000",
                            callbackUrl: "https://somedummyurl.com/demo",
                            partnerParams: FlutterPartnerParams(
                              jobType: FlutterJobType.enhancedKyc,
                              jobId: userId,
                              userId: userId,
                            ),
                            timestamp: authResponse!.timestamp,
                            signature: authResponse.signature))
                      },
                  onError: (error) => {print("error: $error")});
        });
  }

  Widget documentVerificationButton(BuildContext context) {
    return ElevatedButton(
      child: const Text("Document Verification"),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => MyScaffold(
                body: SmileIDDocumentVerification(
              countryCode: "GH",
              documentType: "DRIVERS_LICENSE",
              onSuccess: (String? result) {
                // Your success handling logic
                Map<String, dynamic> jsonResult = json.decode(result ?? '{}');
                String formattedResult = jsonEncode(jsonResult);
                final snackBar = SnackBar(content: Text("Success: $formattedResult"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.of(context).pop();
              },
              onError: (String errorMessage) {
                // Your error handling logic
                final snackBar = SnackBar(content: Text("Error: $errorMessage"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.of(context).pop();
              },
            )),
          ),
        );
      },
    );
  }

  Widget enhancedDocumentVerificationButton(BuildContext context) {
    return ElevatedButton(
      child: const Text("Enhanced Document Verification"),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => MyScaffold(
                body: SmileIDEnhancedDocumentVerification(
              countryCode: "GH",
              documentType: "DRIVERS_LICENSE",
              onSuccess: (String? result) {
                // Your success handling logic
                Map<String, dynamic> jsonResult = json.decode(result ?? '{}');
                String formattedResult = jsonEncode(jsonResult);
                final snackBar = SnackBar(content: Text("Success: $formattedResult"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.of(context).pop();
              },
              onError: (String errorMessage) {
                // Your error handling logic
                final snackBar = SnackBar(content: Text("Error: $errorMessage"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.of(context).pop();
              },
            )),
          ),
        );
      },
    );
  }

  Widget smartSelfieEnrollmentButton(BuildContext context) {
    return ElevatedButton(
      child: const Text("SmartSelfie Enrollment"),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => MyScaffold(
                body: SmileIDSmartSelfieEnrollment(
              onSuccess: (String? result) {
                // Your success handling logic
                Map<String, dynamic> jsonResult = json.decode(result ?? '{}');
                String formattedResult = jsonEncode(jsonResult);
                final snackBar = SnackBar(content: Text("Success: $formattedResult"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.of(context).pop();
              },
              onError: (String errorMessage) {
                // Your error handling logic
                final snackBar = SnackBar(content: Text("Error: $errorMessage"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.of(context).pop();
              },
            )),
          ),
        );
      },
    );
  }

  Widget smartSelfieAuthenticationButton(BuildContext context) {
    return ElevatedButton(
      child: const Text("SmartSelfie Authentication"),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => MyScaffold(
                body: SmileIDSmartSelfieAuthentication(
              onSuccess: (String? result) {
                // Your success handling logic
                Map<String, dynamic> jsonResult = json.decode(result ?? '{}');
                String formattedResult = jsonEncode(jsonResult);
                final snackBar = SnackBar(content: Text("Success: $formattedResult"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.of(context).pop();
              },
              onError: (String errorMessage) {
                // Your error handling logic
                final snackBar = SnackBar(content: Text("Error: $errorMessage"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.of(context).pop();
              },
            )),
          ),
        );
      },
    );
  }

  Widget biometricKycButton(BuildContext context) {
    return ElevatedButton(
      child: const Text("Biometric KYC"),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => MyScaffold(
                body: SmileIDBiometricKYC(
              country: "KE",
              idType: "NATIONAL_ID",
              idNumber: "12345678",
              onSuccess: (String? result) {
                // Your success handling logic
                Map<String, dynamic> jsonResult = json.decode(result ?? '{}');
                String formattedResult = jsonEncode(jsonResult);
                final snackBar = SnackBar(content: Text("Success: $formattedResult"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.of(context).pop();
              },
              onError: (String errorMessage) {
                // Your error handling logic
                final snackBar = SnackBar(content: Text("Error: $errorMessage"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.of(context).pop();
              },
            )),
          ),
        );
      },
    );
  }

  Widget selfieCaptureButton(BuildContext context) {
    return ElevatedButton(
      child: const Text("Selfie Capture"),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => MyScaffold(
                body: SmileIDSmartSelfieCaptureView(
              showConfirmationDialog: true,
              allowAgentMode: false,
              showAttribution: true,
              onSuccess: (String? result) {
                // Your success handling logic
                Map<String, dynamic> jsonResult = json.decode(result ?? '{}');
                String formattedResult = jsonEncode(jsonResult);
                final snackBar = SnackBar(content: Text("Success: $formattedResult"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.of(context).pop();
              },
              onError: (String errorMessage) {
                // Your error handling logic
                final snackBar = SnackBar(content: Text("Error: $errorMessage"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.of(context).pop();
              },
            )),
          ),
        );
      },
    );
  }

  Widget documentCaptureButton(BuildContext context) {
    return ElevatedButton(
      child: const Text("Document Capture"),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => MyScaffold(
                body: SmileIDDocumentCaptureView(
                  showInstructions: true,
                  showAttribution: true,
                  allowGalleryUpload: false,
                  onSuccess: (String? result) {
                    // Your success handling logic
                    Map<String, dynamic> jsonResult = json.decode(result ?? '{}');
                    String formattedResult = jsonEncode(jsonResult);
                    final snackBar = SnackBar(content: Text("Success: $formattedResult"));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.of(context).pop();
                  },
                  onError: (String errorMessage) {
                    // Your error handling logic
                    final snackBar = SnackBar(content: Text("Error: $errorMessage"));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.of(context).pop();
                  },
                )),
          ),
        );
      },
    );
  }
}
