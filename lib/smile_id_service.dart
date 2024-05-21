import 'smileid_messages.g.dart';

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
  Future<FlutterSmartSelfieJobStatusResponse> getSmartSelfieJobStatus(
      FlutterJobStatusRequest request) {
    return platformInterface.getSmartSelfieJobStatus(request);
  }

  /// Fetches the status of a Job. This can be used to check if a Job is complete, and if so,
  /// whether it was successful. This should be called when the Job is known to be a
  /// Document Verification.
  Future<FlutterDocumentVerificationJobStatusResponse> getDocumentVerificationJobStatus(
      FlutterJobStatusRequest request) {
    return platformInterface.getDocumentVerificationJobStatus(request);
  }

  /// Fetches the status of a Job. This can be used to check if a Job is complete, and if so,
  /// whether it was successful. This should be called when the Job is known to be a Biometric KYC.
  Future<FlutterBiometricKycJobStatusResponse> getBiometricKycJobStatus(
      FlutterJobStatusRequest request) {
    return platformInterface.getBiometricKycJobStatus(request);
  }

  /// Fetches the status of a Job. This can be used to check if a Job is complete, and if so,
  /// whether it was successful. This should be called when the Job is known to be Enhanced DocV.
  Future<FlutterEnhancedDocumentVerificationJobStatusResponse>
      getEnhancedDocumentVerificationJobStatus(FlutterJobStatusRequest request) {
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

  /// Polls the status of a Smart Selfie job.
  ///
  /// The function returns a [Future] that completes with a
  /// [FlutterSmartSelfieJobStatusResponse], which contains the status of the job.
  ///
  /// Example usage:
  /// ```dart
  /// var request = FlutterJobStatusRequest(/* parameters */);
  /// var response = await pollSmartSelfieJobStatus(request, 1000, 5);
  /// ```
  ///
  /// This example polls the job status every 1000 milliseconds (1 second) up to 5 times.
  ///
  /// The [FlutterJobStatusRequest] should be configured according to the job
  /// requirements and platform interface specifications.
  ///
  /// The [interval] parameter specifies the duration (in milliseconds) between
  /// each polling attempt.
  ///
  /// The [numAttempts] parameter defines the number of times the job status will
  /// be polled before giving up.
  ///
  /// If the job status is successfully retrieved within the specified attempts,
  /// the [Future] completes with the job status. If not, the [Future] may complete
  /// with an error or the last status retrieved, depending on the platform interface
  /// implementation.
  ///
  /// Throws:
  /// - [PlatformException] if there is an error in the platform interface.
  ///
  /// Params:
  /// - [request]: The request object containing the job status request details.
  /// - [interval]: The interval duration (in milliseconds) between each polling attempt.
  /// - [numAttempts]: The number of polling attempts before stopping.
  ///
  /// Returns:
  /// - A [Future<FlutterSmartSelfieJobStatusResponse>] that completes with the job status.
  ///
  /// See also:
  /// - [FlutterJobStatusRequest]
  /// - [FlutterSmartSelfieJobStatusResponse]
  /// ```
  Future<FlutterSmartSelfieJobStatusResponse> pollSmartSelfieJobStatus(
      FlutterJobStatusRequest request, int interval, int numAttempts) {
    return platformInterface.pollSmartSelfieJobStatus(request, interval, numAttempts);
  }

  /// Polls the status of a document verification job
  ///
  /// The function returns a [Future] that completes with a
  /// [FlutterDocumentVerificationJobStatusResponse], which contains the status of the job.
  ///
  /// Example usage:
  /// ```dart
  /// var request = FlutterJobStatusRequest(/* parameters */);
  /// var response = await pollDocumentVerificationJobStatus(request, 1000, 5);
  /// ```
  ///
  /// This example polls the job status every 1000 milliseconds (1 second) up to 5 times.
  ///
  /// The [FlutterJobStatusRequest] should be configured according to the job
  /// requirements and platform interface specifications.
  ///
  /// The [interval] parameter specifies the duration (in milliseconds) between
  /// each polling attempt.
  ///
  /// The [numAttempts] parameter defines the number of times the job status will
  /// be polled before giving up.
  ///
  /// If the job status is successfully retrieved within the specified attempts,
  /// the [Future] completes with the job status. If not, the [Future] may complete
  /// with an error or the last status retrieved, depending on the platform interface
  /// implementation.
  ///
  /// Throws:
  /// - [PlatformException] if there is an error in the platform interface.
  ///
  /// Params:
  /// - [request]: The request object containing the job status request details.
  /// - [interval]: The interval duration (in milliseconds) between each polling attempt.
  /// - [numAttempts]: The number of polling attempts before stopping.
  ///
  /// Returns:
  /// - A [Future<FlutterDocumentVerificationJobStatusResponse>] that completes with the job status.
  ///
  /// See also:
  /// - [FlutterJobStatusRequest]
  /// - [FlutterDocumentVerificationJobStatusResponse]
  /// ```
  Future<FlutterDocumentVerificationJobStatusResponse> pollDocumentVerificationJobStatus(
      FlutterJobStatusRequest request, int interval, int numAttempts) {
    return platformInterface.pollDocumentVerificationJobStatus(request, interval, numAttempts);
  }

  /// Polls the status of a biometric kyc job
  ///
  /// The function returns a [Future] that completes with a
  /// [FlutterBiometricKycJobStatusResponse], which contains the status of the job.
  ///
  /// Example usage:
  /// ```dart
  /// var request = FlutterJobStatusRequest(/* parameters */);
  /// var response = await pollBiometricKycJobStatus(request, 1000, 5);
  /// ```
  ///
  /// This example polls the job status every 1000 milliseconds (1 second) up to 5 times.
  ///
  /// The [FlutterJobStatusRequest] should be configured according to the job
  /// requirements and platform interface specifications.
  ///
  /// The [interval] parameter specifies the duration (in milliseconds) between
  /// each polling attempt.
  ///
  /// The [numAttempts] parameter defines the number of times the job status will
  /// be polled before giving up.
  ///
  /// If the job status is successfully retrieved within the specified attempts,
  /// the [Future] completes with the job status. If not, the [Future] may complete
  /// with an error or the last status retrieved, depending on the platform interface
  /// implementation.
  ///
  /// Throws:
  /// - [PlatformException] if there is an error in the platform interface.
  ///
  /// Params:
  /// - [request]: The request object containing the job status request details.
  /// - [interval]: The interval duration (in milliseconds) between each polling attempt.
  /// - [numAttempts]: The number of polling attempts before stopping.
  ///
  /// Returns:
  /// - A [Future<FlutterBiometricKycJobStatusResponse>] that completes with the job status.
  ///
  /// See also:
  /// - [FlutterJobStatusRequest]
  /// - [FlutterBiometricKycJobStatusResponse]
  /// ```
  Future<FlutterBiometricKycJobStatusResponse> pollBiometricKycJobStatus(
      FlutterJobStatusRequest request, int interval, int numAttempts) {
    return platformInterface.pollBiometricKycJobStatus(request, interval, numAttempts);
  }

  /// Polls the status of a an enhanced document verification job
  ///
  /// The function returns a [Future] that completes with a
  /// [FlutterEnhancedDocumentVerificationJobStatusResponse], which contains the status of the job.
  ///
  /// Example usage:
  /// ```dart
  /// var request = FlutterJobStatusRequest(/* parameters */);
  /// var response = await pollEnhancedDocumentVerificationJobStatus(request, 1000, 5);
  /// ```
  ///
  /// This example polls the job status every 1000 milliseconds (1 second) up to 5 times.
  ///
  /// The [FlutterJobStatusRequest] should be configured according to the job
  /// requirements and platform interface specifications.
  ///
  /// The [interval] parameter specifies the duration (in milliseconds) between
  /// each polling attempt.
  ///
  /// The [numAttempts] parameter defines the number of times the job status will
  /// be polled before giving up.
  ///
  /// If the job status is successfully retrieved within the specified attempts,
  /// the [Future] completes with the job status. If not, the [Future] may complete
  /// with an error or the last status retrieved, depending on the platform interface
  /// implementation.
  ///
  /// Throws:
  /// - [PlatformException] if there is an error in the platform interface.
  ///
  /// Params:
  /// - [request]: The request object containing the job status request details.
  /// - [interval]: The interval duration (in milliseconds) between each polling attempt.
  /// - [numAttempts]: The number of polling attempts before stopping.
  ///
  /// Returns:
  /// - A [Future<FlutterEnhancedDocumentVerificationJobStatusResponse>] that completes with the job status.
  ///
  /// See also:
  /// - [FlutterJobStatusRequest]
  /// - [FlutterEnhancedDocumentVerificationJobStatusResponse]
  /// ```
  Future<FlutterEnhancedDocumentVerificationJobStatusResponse> pollEnhancedDocumentVerificationJobStatus(
      FlutterJobStatusRequest request, int interval, int numAttempts) {
    return platformInterface.pollEnhancedDocumentVerificationJobStatus(request, interval, numAttempts);
  }
}
