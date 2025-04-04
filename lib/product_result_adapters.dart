import 'result_clients_interfaces.dart';
import 'smile_id_product_views_api.dart';
import 'smile_id_sdk_result.dart';
import 'smileid_messages.g.dart';

class SelfieEnrollmentProductToSelfieCaptureResultAdapter
    extends SmileIDProductViewsResultApi {
  final SmartSelfieCaptureResultClient client;

  SelfieEnrollmentProductToSelfieCaptureResultAdapter(this.client) {
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
