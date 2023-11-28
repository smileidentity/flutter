import 'messages.g.dart';

class SmileIDService {
  SmileIDApi platformInterface;

  SmileIDService(this.platformInterface);

  /// Returns a signature and timestamp that can be used to authenticate future requests
  Future<FlutterAuthenticationResponse?> authenticate(FlutterAuthenticationRequest request) {
    return platformInterface.authenticate(request);
  }

  /// Used by Job Types that need to upload a file to the server. The response contains the URL
  /// (`FlutterPrepUploadResponse.uploadUrl`) that the file should eventually be uploaded to (via
  /// `upload`)
  Future<FlutterPrepUploadResponse> prepareUpload(FlutterPrepUploadRequest request) {
    return platformInterface.prepUpload(request);
  }

  /// Uploads files to S3. The URL should be the one returned by `prepareUpload`. The files will be
  /// uploaded in the order they are provided in `FlutterUploadRequest.images`, and will be zipped
  /// together by the corresponding Dart/Flutter mechanism.
  Future<void> upload(String url, FlutterUploadRequest request) {
    return platformInterface.upload(url, request);
  }

  /// Queries the Identity Information of an individual using their ID number from a supported ID
  /// Type. Returns the personal information of the individual found in the database of the ID
  /// authority.
  ///
  /// This will be done synchronously, and the result will be returned in the response. If the ID
  /// provider is unavailable, the response will be an error.
  Future<FlutterEnhancedKycResponse> doEnhancedKyc(FlutterEnhancedKycRequest request) {
    return platformInterface.doEnhancedKyc(request);
  }

  /// Same as `doEnhancedKyc`, but the final result is delivered to the URL provided in the (required)
  /// `FlutterEnhancedKycRequest.callbackUrl` field.
  ///
  /// If the ID provider is unavailable, the response will be delivered to the callback URL once
  /// the ID provider is available again.
  Future<FlutterEnhancedKycAsyncResponse> doEnhancedKycAsync(FlutterEnhancedKycRequest request) {
    return platformInterface.doEnhancedKycAsync(request);
  }

  /// Fetches the status of a Job. This can be used to check if a Job is complete, and if so,
  /// whether it was successful. This should be called when the Job is known to be a
  /// SmartSelfie Authentication/Registration.
  Future<FlutterSmartSelfieJobStatusResponse> getSmartSelfieJobStatus(FlutterJobStatusRequest request) {
    return platformInterface.getSmartSelfieJobStatus(request);
  }

  /// Fetches the status of a Job. This can be used to check if a Job is complete, and if so,
  /// whether it was successful. This should be called when the Job is known to be a
  /// Document Verification.
  Future<FlutterDocumentVerificationJobStatusResponse> getDocumentVerificationJobStatus(FlutterJobStatusRequest request) {
    return platformInterface.getDocumentVerificationJobStatus(request);
  }

  /// Fetches the status of a Job. This can be used to check if a Job is complete, and if so,
  /// whether it was successful. This should be called when the Job is known to be a Biometric KYC.
  Future<FlutterBiometricKycJobStatusResponse> getBiometricKycJobStatus(FlutterJobStatusRequest request) {
    return platformInterface.getBiometricKycJobStatus(request);
  }

  /// Fetches the status of a Job. This can be used to check if a Job is complete, and if so,
  /// whether it was successful. This should be called when the Job is known to be Enhanced DocV.
  Future<FlutterEnhancedDocumentVerificationJobStatusResponse> getEnhancedDocumentVerificationJobStatus(FlutterJobStatusRequest request) {
    return platformInterface.getEnhancedDocumentVerificationJobStatus(request);
  }

  /// Returns the ID types that are enabled for authenticated partner and which of those require
  /// consent
  Future<FlutterProductsConfigResponse> getProductsConfig(FlutterProductsConfigRequest request) {
    return platformInterface.getProductsConfig(request);
  }

  /// Returns Global DocV supported products and metadata
  Future<FlutterValidDocumentsResponse> getValidDocuments(FlutterProductsConfigRequest request) {
    return platformInterface.getValidDocuments(request);
  }

  /// Returns supported products and metadata
  Future<FlutterServicesResponse> getServices() {
    return platformInterface.getServices();
  }
}
