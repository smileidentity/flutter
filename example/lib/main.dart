import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smile_id/smile_id_sdk_result.dart';
import 'package:smile_id/smile_id_smart_selfie_enrollment.dart';
import 'package:smile_id/smileid_messages.g.dart';
import 'package:smile_id/smile_id.dart';

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
        smartSelfieEnrollmentButtonEnhanced(context),
        smartSelfieAuthenticationButtonEnhanced(context),
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
                                extras: {
                                  "name": "Dummy Name",
                                  "work": "SmileID",
                                }),
                            timestamp: authResponse!.timestamp,
                            signature: authResponse.signature))
                      },
                  onError: (error) => {print("error: $error")});
        });
  }

  Widget documentVerificationButton(BuildContext context) {
    return ElevatedButton(
      child: const Text("Document Verification"),
      onPressed: () async {
        final result = await SmileID().documentVerification(
          creationParams: DocumentVerificationCreationParams(
              countryCode: "GH",
              documentType: "DRIVERS_LICENSE",
              captureBothSides: true,
              allowNewEnroll: false,
              showAttribution: true,
              allowGalleryUpload: false,
              allowAgentMode: false,
              showInstructions: true,
              skipApiSubmission: false),
        );

        switch (result) {
          case SmileIDSdkResultSuccess<DocumentCaptureResult>(:final data):
            print('verification selfie: ${data.selfieFile}');
            print('verification liveness: ${data.livenessFiles}');
            print('verification backFile: ${data.documentBackFile}');
            print('verification frontFile: ${data.documentFrontFile}');
            print(
                'verification didSubmitVerificationJob: ${data.didSubmitDocumentVerificationJob}');
          case SmileIDSdkResultError<DocumentCaptureResult>(:final error):
            print('error occurred with document verification: $error');
        }
      },
    );
  }

  Widget enhancedDocumentVerificationButton(BuildContext context) {
    return ElevatedButton(
      child: const Text("Enhanced Document Verification"),
      onPressed: () async {
        final result = await SmileID().documentVerificationEnhanced(
          creationParams: DocumentVerificationEnhancedCreationParams(
              countryCode: "GH",
              documentType: "DRIVERS_LICENSE",
              captureBothSides: true,
              allowNewEnroll: false,
              showAttribution: true,
              allowAgentMode: false,
              allowGalleryUpload: false,
              showInstructions: true,
              skipApiSubmission: false),
        );

        switch (result) {
          case SmileIDSdkResultSuccess<DocumentCaptureResult>(:final data):
            print('verification selfie: ${data.selfieFile}');
            print('verification liveness: ${data.livenessFiles}');
            print('verification backFile: ${data.documentBackFile}');
            print('verification frontFile: ${data.documentFrontFile}');
            print('verification didSubmitEnhancedDocVJob: ${data.didSubmitEnhancedDocVJob}');
          case SmileIDSdkResultError<DocumentCaptureResult>(:final error):
            print('error occurred with document verification enhanced: $error');
        }
      },
    );
  }

  Widget smartSelfieEnrollmentButton(BuildContext context) {
    return ElevatedButton(
      child: const Text("SmartSelfie Enrollment"),
      onPressed: () async {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => MyScaffold(
              body: SmileIDSmartSelfieEnrollment(
                onResult: (result) {
                  switch (result) {
                    case SmileIDSdkResultSuccess<SmartSelfieCaptureResult>(:final data):
                      final formattedResult = jsonEncode({
                        'selfie': data.selfieFile,
                        'liveness': data.livenessFiles,
                        'apiResponse': data.apiResponse
                      });
                      final snackBar = SnackBar(content: Text("Success: $formattedResult"));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.of(context).pop();
                    case SmileIDSdkResultError<SmartSelfieCaptureResult>(:final error):
                      final snackBar = SnackBar(content: Text("Error: $error"));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget smartSelfieAuthenticationButton(BuildContext context) {
    return ElevatedButton(
      child: const Text("SmartSelfie Authentication"),
      onPressed: () async {
        final result = await SmileID().smartSelfieAuthentication(
          creationParams: SmartSelfieCreationParams(
              allowNewEnroll: false,
              allowAgentMode: false,
              showAttribution: true,
              showInstructions: true,
              skipApiSubmission: true),
        );

        switch (result) {
          case SmileIDSdkResultSuccess<SmartSelfieCaptureResult>(:final data):
            print('enrollment selfie: ${data.selfieFile}');
            print('enrollment liveness: ${data.livenessFiles}');
            print('enrollment apiResponse: ${data.apiResponse}');
          case SmileIDSdkResultError<SmartSelfieCaptureResult>(:final error):
            print('error occurred with smart selfie authentication: $error');
        }
      },
    );
  }

  Widget smartSelfieEnrollmentButtonEnhanced(BuildContext context) {
    return ElevatedButton(
      child: const Text("SmartSelfie Enrollment (Enhanced)"),
      onPressed: () async {
        final result = await SmileID().smartSelfieEnrollmentEnhanced(
            creationParams: SmartSelfieEnhancedCreationParams(
          allowNewEnroll: false,
          showAttribution: true,
          showInstructions: true,
        ));

        switch (result) {
          case SmileIDSdkResultSuccess<SmartSelfieCaptureResult>(:final data):
            print('enrollment selfie: ${data.selfieFile}');
            print('enrollment liveness: ${data.livenessFiles}');
            print('enrollment apiResponse: ${data.apiResponse}');
          case SmileIDSdkResultError<SmartSelfieCaptureResult>(:final error):
            print('error occurred with smart selfie enrollment enhanced: $error');
        }
      },
    );
  }

  Widget smartSelfieAuthenticationButtonEnhanced(BuildContext context) {
    return ElevatedButton(
      child: const Text("SmartSelfie Authentication (Enhanced)"),
      onPressed: () async {
        final result = await SmileID().smartSelfieAuthenticationEnhanced(
            creationParams: SmartSelfieEnhancedCreationParams(
          allowNewEnroll: false,
          showAttribution: true,
          showInstructions: true,
        ));

        switch (result) {
          case SmileIDSdkResultSuccess<SmartSelfieCaptureResult>(:final data):
            print('enrollment selfie: ${data.selfieFile}');
            print('enrollment liveness: ${data.livenessFiles}');
            print('enrollment apiResponse: ${data.apiResponse}');
          case SmileIDSdkResultError<SmartSelfieCaptureResult>(:final error):
            print('error occurred with smart selfie authentication enhanced: $error');
        }
      },
    );
  }

  Widget biometricKycButton(BuildContext context) {
    return ElevatedButton(
      child: const Text("Biometric KYC"),
      onPressed: () async {
        final result = await SmileID().biometricKYC(
          creationParams: BiometricKYCCreationParams(
              allowNewEnroll: false,
              allowAgentMode: false,
              showAttribution: true,
              showInstructions: true),
        );

        switch (result) {
          case SmileIDSdkResultSuccess<BiometricKYCCaptureResult>(:final data):
            print('biometric kyc selfie: ${data.selfieFile}');
            print('biometric kyc liveness: ${data.livenessFiles}');
            print('biometric kyc didSubmitKycJob: ${data.didSubmitBiometricKycJob}');
          case SmileIDSdkResultError<BiometricKYCCaptureResult>(:final error):
            print('error occurred with biometric kyc: $error');
        }
      },
    );
  }

  Widget selfieCaptureButton(BuildContext context) {
    return ElevatedButton(
      child: const Text("Selfie Capture"),
      onPressed: () async {
        final result = await SmileID().selfieCapture(
          creationParams: SelfieCaptureViewCreationParams(
              showConfirmationDialog: false,
              showInstructions: true,
              showAttribution: false,
              allowAgentMode: false),
        );

        switch (result) {
          case SmileIDSdkResultSuccess<SmartSelfieCaptureResult>(:final data):
            print('capture selfie: ${data.selfieFile}');
            print('capture liveness: ${data.livenessFiles}');
            print('capture apiResponse: ${data.apiResponse}');
          case SmileIDSdkResultError<SmartSelfieCaptureResult>(:final error):
            print('error occurred with selfie capture: $error');
        }
      },
    );
  }

  Widget documentCaptureButton(BuildContext context) {
    return ElevatedButton(
      child: const Text("Document Capture"),
      onPressed: () async {
        final result = await SmileID().documentCapture(
          creationParams: DocumentCaptureCreationParams(
              isDocumentFrontSide: false,
              showInstructions: true,
              showAttribution: false,
              allowGalleryUpload: false,
              showConfirmationDialog: true),
        );

        switch (result) {
          case SmileIDSdkResultSuccess<DocumentCaptureResult>(:final data):
            print('document capture front file: ${data.documentFrontFile}');
            print('document capture back file: ${data.documentBackFile}');
          case SmileIDSdkResultError<DocumentCaptureResult>(:final error):
            print("error occurred with document capture: $error");
        }
      },
    );
  }
}
