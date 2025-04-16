import 'result_clients_interfaces.dart';
import 'smile_id_product_views_api.dart';
import 'smile_id_sdk_result.dart';
import 'smileid_messages.g.dart';

class DocumentVerificationAdapter extends SmileIDProductViewsResultApi {
  final DocumentCaptureResultClient client;

  DocumentVerificationAdapter(this.client) {
    SmileIDProductsResultApi.setUp(this);
  }

  @override
  void onDocumentVerificationResult(
      DocumentCaptureResult? successResult, String? errorResult) {
    super.onDocumentVerificationResult(successResult, errorResult);
    if (successResult != null) {
      client.onResult(SmileIDSdkResultSuccess(successResult));
    } else if (errorResult != null) {
      client.onResult(SmileIDSdkResultError(errorResult));
    }
  }
}

class EnhancedDocumentVerificationAdapter extends SmileIDProductViewsResultApi {
  final DocumentCaptureResultClient client;

  EnhancedDocumentVerificationAdapter(this.client) {
    SmileIDProductsResultApi.setUp(this);
  }

  @override
  void onDocumentVerificationEnhancedResult(
      DocumentCaptureResult? successResult, String? errorResult) {
    super.onDocumentVerificationEnhancedResult(successResult, errorResult);
    if (successResult != null) {
      client.onResult(SmileIDSdkResultSuccess(successResult));
    } else if (errorResult != null) {
      client.onResult(SmileIDSdkResultError(errorResult));
    }
  }
}

class SmartSelfieEnrollmentAdapter extends SmileIDProductViewsResultApi {
  final SmartSelfieCaptureResultClient client;

  SmartSelfieEnrollmentAdapter(this.client) {
    SmileIDProductsResultApi.setUp(this);
  }

  @override
  void onSmartSelfieEnrollmentResult(
      SmartSelfieCaptureResult? successResult, String? errorResult) {
    super.onSmartSelfieEnrollmentResult(successResult, errorResult);
    if (successResult != null) {
      client.onResult(SmileIDSdkResultSuccess(successResult));
    } else if (errorResult != null) {
      client.onResult(SmileIDSdkResultError(errorResult));
    }
  }
}

class SmartSelfieAuthenticationAdapter extends SmileIDProductViewsResultApi {
  final SmartSelfieCaptureResultClient client;

  SmartSelfieAuthenticationAdapter(this.client) {
    SmileIDProductsResultApi.setUp(this);
  }

  @override
  void onSmartSelfieAuthenticationResult(
      SmartSelfieCaptureResult? successResult, String? errorResult) {
    super.onSmartSelfieAuthenticationResult(successResult, errorResult);
    if (successResult != null) {
      client.onResult(SmileIDSdkResultSuccess(successResult));
    } else if (errorResult != null) {
      client.onResult(SmileIDSdkResultError(errorResult));
    }
  }
}

class SmartSelfieEnrollmentEnhancedAdapter
    extends SmileIDProductViewsResultApi {
  final SmartSelfieCaptureResultClient client;

  SmartSelfieEnrollmentEnhancedAdapter(this.client) {
    SmileIDProductsResultApi.setUp(this);
  }

  @override
  void onSmartSelfieEnrollmentEnhancedResult(
      SmartSelfieCaptureResult? successResult, String? errorResult) {
    super.onSmartSelfieEnrollmentEnhancedResult(successResult, errorResult);
    if (successResult != null) {
      client.onResult(SmileIDSdkResultSuccess(successResult));
    } else if (errorResult != null) {
      client.onResult(SmileIDSdkResultError(errorResult));
    }
  }
}

class SmartSelfieAuthenticationEnhancedAdapter
    extends SmileIDProductViewsResultApi {
  final SmartSelfieCaptureResultClient client;

  SmartSelfieAuthenticationEnhancedAdapter(this.client) {
    SmileIDProductsResultApi.setUp(this);
  }

  @override
  void onSmartSelfieAuthenticationEnhancedResult(
      SmartSelfieCaptureResult? successResult, String? errorResult) {
    super.onSmartSelfieAuthenticationEnhancedResult(successResult, errorResult);
    if (successResult != null) {
      client.onResult(SmileIDSdkResultSuccess(successResult));
    } else if (errorResult != null) {
      client.onResult(SmileIDSdkResultError(errorResult));
    }
  }
}

class BiometricKycAdapter extends SmileIDProductViewsResultApi {
  final BiometricKYCCaptureResultClient client;

  BiometricKycAdapter(this.client) {
    SmileIDProductsResultApi.setUp(this);
  }

  @override
  void onBiometricKYCResult(
      BiometricKYCCaptureResult? successResult, String? errorResult) {
    super.onBiometricKYCResult(successResult, errorResult);
    if (successResult != null) {
      client.onResult(SmileIDSdkResultSuccess(successResult));
    } else if (errorResult != null) {
      client.onResult(SmileIDSdkResultError(errorResult));
    }
  }
}

class SmartSelfieCaptureAdapter extends SmileIDProductViewsResultApi {
  final SmartSelfieCaptureResultClient client;

  SmartSelfieCaptureAdapter(this.client) {
    SmileIDProductsResultApi.setUp(this);
  }

  @override
  void onSelfieCaptureResult(
      SmartSelfieCaptureResult? successResult, String? errorResult) {
    super.onSelfieCaptureResult(successResult, errorResult);
    if (successResult != null) {
      client.onResult(SmileIDSdkResultSuccess(successResult));
    } else if (errorResult != null) {
      client.onResult(SmileIDSdkResultError(errorResult));
    }
  }
}

class DocumentCaptureAdapter extends SmileIDProductViewsResultApi {
  final DocumentCaptureResultClient client;

  DocumentCaptureAdapter(this.client) {
    SmileIDProductsResultApi.setUp(this);
  }

  @override
  void onDocumentCaptureResult(
      DocumentCaptureResult? successResult, String? errorResult) {
    super.onDocumentCaptureResult(successResult, errorResult);
    if (successResult != null) {
      client.onResult(SmileIDSdkResultSuccess(successResult));
    } else if (errorResult != null) {
      client.onResult(SmileIDSdkResultError(errorResult));
    }
  }
}
