import 'smile_id_sdk_result.dart';

import 'smileid_messages.g.dart';

abstract interface class SmartSelfieCaptureResultClient {
  void onResult(SmileIDSdkResult<SmartSelfieCaptureResult> result);
}

abstract interface class DocumentCaptureResultClient {
  void onResult(SmileIDSdkResult<DocumentCaptureResult> result);
}

abstract interface class BiometricKYCCaptureResultClient {
  void onResult(SmileIDSdkResult<BiometricKYCCaptureResult> result);
}
