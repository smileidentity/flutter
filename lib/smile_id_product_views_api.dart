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
SmartSelfieEnrollment Result: \tSmartSelfieCaptureResult(
  selfieFile: ${successResult.selfieFile},
  livenessFiles: ${successResult.livenessFiles},
  apiResponse: ${successResult.apiResponse}
)''', level: _infoLevel);
    } else if (errorResult != null) {
      log('SmartSelfieEnrollment Error: $errorResult', level: _warningLevel);
    }
  }

  void dispose() {
    SmileIDProductsResultApi.setUp(null);
  }
}
