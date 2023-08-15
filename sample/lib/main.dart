import 'dart:async';

import 'package:flutter/material.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Smile ID'),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                child: Text("Enhanced KYC (Async)"),
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
              )
            ],
          )
        ),
      ),
    );
  }
}
