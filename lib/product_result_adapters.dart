import 'result_clients_interfaces.dart';
import 'smile_id_product_views_api.dart';
import 'smile_id_sdk_result.dart';
import 'smileid_messages.g.dart';

class DocumentVerificationProductToDocumentCaptureResultAdapter extends SmileIDProductViewsResultApi {
  final DocumentCaptureResultClient client;

  DocumentVerificationProductToDocumentCaptureResultAdapter(this.client) {
    SmileIDProductsResultApi.setUp(this);
  }

  @override
  void onDocumentVerificationResult(DocumentCaptureResult? successResult, String? errorResult) {
    super.onDocumentVerificationResult(successResult, errorResult);
    if (successResult != null) {
      client.onResult(SmileIDSdkResultSuccess(successResult));
    } else if (errorResult != null) {
      client.onResult(SmileIDSdkResultError(errorResult));
    }
  }
}

class EnhancedDocumentVerificationProductToDocumentCaptureResultAdapter extends SmileIDProductViewsResultApi {
  final DocumentCaptureResultClient client;

  EnhancedDocumentVerificationProductToDocumentCaptureResultAdapter(this.client) {
    SmileIDProductsResultApi.setUp(this);
  }

  @override
  void onDocumentVerificationEnhancedResult(DocumentCaptureResult? successResult, String? errorResult) {
    super.onDocumentVerificationEnhancedResult(successResult, errorResult);
    if (successResult != null) {
      client.onResult(SmileIDSdkResultSuccess(successResult));
    } else if (errorResult != null) {
      client.onResult(SmileIDSdkResultError(errorResult));
    }
  }
}

class SmartSelfieEnrollmentProductToSelfieCaptureResultAdapter extends SmileIDProductViewsResultApi {
  final SmartSelfieCaptureResultClient client;

  SmartSelfieEnrollmentProductToSelfieCaptureResultAdapter(this.client) {
    SmileIDProductsResultApi.setUp(this);
  }

  @override
  void onSmartSelfieEnrollmentResult(SmartSelfieCaptureResult? successResult, String? errorResult) {
    super.onSmartSelfieEnrollmentResult(successResult, errorResult);
    if (successResult != null) {
      client.onResult(SmileIDSdkResultSuccess(successResult));
    } else if (errorResult != null) {
      client.onResult(SmileIDSdkResultError(errorResult));
    }
  }
}

class SmartSelfieAuthenticationProductToSelfieCaptureResultAdapter extends SmileIDProductViewsResultApi {
  final SmartSelfieCaptureResultClient client;

  SmartSelfieAuthenticationProductToSelfieCaptureResultAdapter(this.client) {
    SmileIDProductsResultApi.setUp(this);
  }

  @override
  void onSmartSelfieAuthenticationResult(SmartSelfieCaptureResult? successResult, String? errorResult) {
    super.onSmartSelfieAuthenticationResult(successResult, errorResult);
    if (successResult != null) {
      client.onResult(SmileIDSdkResultSuccess(successResult));
    } else if (errorResult != null) {
      client.onResult(SmileIDSdkResultError(errorResult));
    }
  }
}

class SmartSelfieEnrollmentEnhancedProductToSelfieCaptureResultAdapter extends SmileIDProductViewsResultApi {
  final SmartSelfieCaptureResultClient client;

  SmartSelfieEnrollmentEnhancedProductToSelfieCaptureResultAdapter(this.client) {
    SmileIDProductsResultApi.setUp(this);
  }

  @override
  void onSmartSelfieEnrollmentEnhancedResult(SmartSelfieCaptureResult? successResult, String? errorResult) {
    super.onSmartSelfieEnrollmentEnhancedResult(successResult, errorResult);
    if (successResult != null) {
      client.onResult(SmileIDSdkResultSuccess(successResult));
    } else if (errorResult != null) {
      client.onResult(SmileIDSdkResultError(errorResult));
    }
  }
}

class SmartSelfieAuthenticationEnhancedProductToSelfieCaptureResultAdapter extends SmileIDProductViewsResultApi {
  final SmartSelfieCaptureResultClient client;

  SmartSelfieAuthenticationEnhancedProductToSelfieCaptureResultAdapter(this.client) {
    SmileIDProductsResultApi.setUp(this);
  }

  @override
  void onSmartSelfieAuthenticationEnhancedResult(SmartSelfieCaptureResult? successResult, String? errorResult) {
    super.onSmartSelfieAuthenticationEnhancedResult(successResult, errorResult);
    if (successResult != null) {
      client.onResult(SmileIDSdkResultSuccess(successResult));
    } else if (errorResult != null) {
      client.onResult(SmileIDSdkResultError(errorResult));
    }
  }
}

class BiometricKycProductToBiometricKYCCaptureResultAdapter extends SmileIDProductViewsResultApi {
  final BiometricKYCCaptureResultClient client;

  BiometricKycProductToBiometricKYCCaptureResultAdapter(this.client) {
    SmileIDProductsResultApi.setUp(this);
  }

  @override
  void onBiometricKYCResult(BiometricKYCCaptureResult? successResult, String? errorResult) {
    super.onBiometricKYCResult(successResult, errorResult);
    if (successResult != null) {
      client.onResult(SmileIDSdkResultSuccess(successResult));
    } else if (errorResult != null) {
      client.onResult(SmileIDSdkResultError(errorResult));
    }
  }
}

class SmartSelfieCaptureProductToSelfieCaptureResultAdapter extends SmileIDProductViewsResultApi {
  final SmartSelfieCaptureResultClient client;

  SmartSelfieCaptureProductToSelfieCaptureResultAdapter(this.client) {
    SmileIDProductsResultApi.setUp(this);
  }

  @override
  void onSelfieCaptureResult(SmartSelfieCaptureResult? successResult, String? errorResult) {
    super.onSelfieCaptureResult(successResult, errorResult);
    if (successResult != null) {
      client.onResult(SmileIDSdkResultSuccess(successResult));
    } else if (errorResult != null) {
      client.onResult(SmileIDSdkResultError(errorResult));
    }
  }
}

class DocumentCaptureProductToDocumentCaptureResultAdapter extends SmileIDProductViewsResultApi {
  final DocumentCaptureResultClient client;

  DocumentCaptureProductToDocumentCaptureResultAdapter(this.client) {
    SmileIDProductsResultApi.setUp(this);
  }

  @override
  void onDocumentCaptureResult(DocumentCaptureResult? successResult, String? errorResult) {
    super.onDocumentCaptureResult(successResult, errorResult);
    if (successResult != null) {
      client.onResult(SmileIDSdkResultSuccess(successResult));
    } else if (errorResult != null) {
      client.onResult(SmileIDSdkResultError(errorResult));
    }
  }
}
