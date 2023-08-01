import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smile_id_flutter/messages.g.dart';
import 'package:smile_id_flutter/smile_id.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _smileidPlugin = SmileID();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    _smileidPlugin.initialize();

    _smileidPlugin.doEnhancedKycAsync(FlutterEnhancedKycRequest(
        country: "country",
        idType: "idType",
        idNumber: "idNumber",
        firstName: "firstName",
        middleName: "middleName",
        lastName: "lastName",
        dob: "dob",
        phoneNumber: "phoneNumber",
        bankCode: "bankCode",
        callbackUrl: "callbackUrl",
        partnerParams: FlutterPartnerParams(
            jobId: "jobId",
            userId: "userId",
            extras: {},
            jobType: FlutterJobType.biometric_kyc),
        partnerId: "partnerId",
        sourceSdk: "sourceSdk",
        sourceSdkVersion: "sourceSdkVersion",
        timestamp: "timestamp",
        signature: "signature"));

    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _smileidPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Smile ID'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
