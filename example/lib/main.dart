import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smile_id/messages.g.dart';
import 'package:smile_id/smile_id.dart';

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
    SmileID.initialize();
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
              EnhancedKycAsyncButton(),
              DocumentVerificationButton(context),
            ],
          )
      )
    );
  }

  Widget EnhancedKycAsyncButton() {
    return ElevatedButton(
        child: const Text("Enhanced KYC (Async)"),
        onPressed: () {
          SmileID.initialize();
          var userId = "<your user's user ID>";
          SmileID.authenticate(FlutterAuthenticationRequest(
            jobType: FlutterJobType.enhancedKyc,
            userId: userId,
          )).then((authResponse) => {
            SmileID.doEnhancedKycAsync(FlutterEnhancedKycRequest(
                country: "GH",
                idType: "DRIVERS_LICENSE",
                idNumber: "B0000000",
                callbackUrl: "https://webhook.site/a3d19f24-769a-46f2-997c-d186c3ae70ea",
                partnerParams: FlutterPartnerParams(
                  jobType: FlutterJobType.enhancedKyc,
                  jobId: userId,
                  userId: userId,
                ),
                timestamp: authResponse!.timestamp,
                signature: authResponse.signature
            ))
          }, onError: (error) => {print("error: $error")});
        }
    );
  }

  Widget DocumentVerificationButton(BuildContext context) {
    return ElevatedButton(
      child: const Text("Document Verification"),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => MyScaffold(
              body: SmileIDDocumentVerification(
                countryCode: "GH",
                documentType: "DRIVERS_LICENSE",
                userId: "1234567890",
                jobId: "1234567890",
                idAspectRatio: 1.5,
                onResult: (String result) {
                  final snackBar = SnackBar(content: Text(result));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  Navigator.of(context).pop();
                },
              )
            ),
          ),
        );
      },
    );
  }
}
