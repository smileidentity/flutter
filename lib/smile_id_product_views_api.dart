import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:smile_id/smileid_messages.g.dart';

class SmileIDProductViewsResultApi implements SmileIDProductsResultApi {
  const SmileIDProductViewsResultApi();

  static const _infoLevel = 800;
  static const _warningLevel = 900;

  @protected
  @mustCallSuper
  @override
  void onSmartSelfieEnrollmentResult(
    SmartSelfieCaptureResult? successResult,
    String? errorResult,
  ) async {
    if (successResult != null) {
      log('''
SmartSelfieEnrollment Result: \t${successResult.prettyPrint}''',
          level: _infoLevel);
    } else if (errorResult != null) {
      log('SmartSelfieEnrollment Error: $errorResult', level: _warningLevel);
    }
  }

  @protected
  @mustCallSuper
  @override
  void onBiometricKYCResult(
      BiometricKYCCaptureResult? successResult, String? errorResult) {
    if (successResult != null) {
      log('''
BiometricKYC Result: \tBiometricKYCCaptureResult(
  selfieFile: ${successResult.selfieFile},
  livenessFiles: ${successResult.livenessFiles},
  didSubmitBiometricKycJob: ${successResult.didSubmitBiometricKycJob}
)''', level: _infoLevel);
    } else if (errorResult != null) {
      log('BiometricKYC Error: $errorResult', level: _warningLevel);
    }
  }

  @protected
  @mustCallSuper
  @override
  void onDocumentCaptureResult(
      DocumentCaptureResult? successResult, String? errorResult) {
    if (successResult != null) {
      log('''
DocumentCapture Result: \t${successResult.prettyPrint}''', level: _infoLevel);
    } else if (errorResult != null) {
      log('DocumentCapture Error: $errorResult', level: _warningLevel);
    }
  }

  @protected
  @mustCallSuper
  @override
  void onDocumentVerificationEnhancedResult(
      DocumentCaptureResult? successResult, String? errorResult) {
    if (successResult != null) {
      log('''
DocumentVerificationEnhanced Result: \t${successResult.prettyPrint}''',
          level: _infoLevel);
    } else if (errorResult != null) {
      log('DocumentVerificationEnhanced Error: $errorResult',
          level: _warningLevel);
    }
  }

  @protected
  @mustCallSuper
  @override
  void onDocumentVerificationResult(
      DocumentCaptureResult? successResult, String? errorResult) {
    if (successResult != null) {
      log('''
DocumentVerification Result: \t${successResult.prettyPrint}''',
          level: _infoLevel);
    } else if (errorResult != null) {
      log('DocumentVerification Error: $errorResult', level: _warningLevel);
    }
  }

  @protected
  @mustCallSuper
  @override
  void onSelfieCaptureResult(
      SmartSelfieCaptureResult? successResult, String? errorResult) {
    if (successResult != null) {
      log('''
SelfieCapture Result: \t${successResult.prettyPrint}''', level: _infoLevel);
    } else if (errorResult != null) {
      log('SelfieCapture Error: $errorResult', level: _warningLevel);
    }
  }

  @protected
  @mustCallSuper
  @override
  void onSmartSelfieAuthenticationEnhancedResult(
      SmartSelfieCaptureResult? successResult, String? errorResult) {
    if (successResult != null) {
      log('''
SmartSelfieAuthenticationEnhanced Result: \t${successResult.prettyPrint}''',
          level: _infoLevel);
    } else if (errorResult != null) {
      log('SmartSelfieAuthenticationEnhanced Error: $errorResult',
          level: _warningLevel);
    }
  }

  @protected
  @mustCallSuper
  @override
  void onSmartSelfieAuthenticationResult(
      SmartSelfieCaptureResult? successResult, String? errorResult) {
    if (successResult != null) {
      log('''
SmartSelfieAuthentication Result: \t${successResult.prettyPrint}''',
          level: _infoLevel);
    } else if (errorResult != null) {
      log('SmartSelfieAuthentication Error: $errorResult',
          level: _warningLevel);
    }
  }

  @protected
  @mustCallSuper
  @override
  void onSmartSelfieEnrollmentEnhancedResult(
      SmartSelfieCaptureResult? successResult, String? errorResult) {
    if (successResult != null) {
      log('''
SmartSelfieEnrollmentEnhanced Result: \t${successResult.prettyPrint}''',
          level: _infoLevel);
    } else if (errorResult != null) {
      log('SmartSelfieEnrollmentEnhanced Error: $errorResult',
          level: _warningLevel);
    }
  }

  void dispose() {
    SmileIDProductsResultApi.setUp(null);
  }
}

extension DocumentCaptureResultPrintExtension on DocumentCaptureResult {
  String get prettyPrint => '''
  DocumentCaptureResult(
    selfie: $selfieFile,
    liveness: $livenessFiles,
    frontFile: $documentFrontFile,
    backFile: $documentBackFile,
    didSubmitVerificationJob: $didSubmitDocumentVerificationJob,
    didSubmitEnhancedDocVJob: $didSubmitEnhancedDocVJob,
  )''';
}

extension SelfieCaptureResultPrintExtension on SmartSelfieCaptureResult {
  String get prettyPrint => '''
  SmartSelfieCaptureResult(
    selfie: $selfieFile,
    liveness: $livenessFiles,
    apiResponse: $apiResponse,
  )''';
}
