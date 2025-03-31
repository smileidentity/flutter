import 'package:flutter/foundation.dart';
import 'package:smile_id/smile_id_sdk_result.dart';
import 'package:smile_id/smileid_messages.g.dart';

class SmileIDResultsService implements SmileIDProductsResultApi {
  SmileIDResultsService._() {
    SmileIDProductsResultApi.setUp(this);
  }

  static SmileIDResultsService? _instance;

  static SmileIDResultsService get instance {
    return _instance ??= SmileIDResultsService._();
  }

  void Function(SmileIDSdkResult<SmartSelfieCaptureResult> result)
      smartSelfieEnrollmentResultCallback = (event) {};

  @protected
  @override
  Future<void> onSmartSelfieEnrollmentResult(
      SmartSelfieCaptureResult? successResult, String? errorResult) async {
    if (successResult != null) {
      return smartSelfieEnrollmentResultCallback(SmileIDSdkResultSuccess(successResult));
    }

    if (errorResult != null) {
      return smartSelfieEnrollmentResultCallback(SmileIDSdkResultError(errorResult));
    }
  }
}
