import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:smile_id/smile_id_sdk_result.dart';

import 'smileid_messages.g.dart';
import 'smile_id_service.dart';

class SmileID {
  @visibleForTesting
  static SmileIDApi platformInterface = SmileIDApi();
  @visibleForTesting
  static SmileIDProductsApi productsInterface = SmileIDProductsApi();
  static SmileIDService api = SmileIDService(platformInterface);

  static void initializeWithApiKey({
    required String apiKey,
    required FlutterConfig config,
    required bool useSandbox,
    required bool enableCrashReporting,
  }) {
    platformInterface.initializeWithApiKey(apiKey, config, useSandbox, enableCrashReporting);
  }

  static void initializeWithConfig({
    required FlutterConfig config,
    required bool useSandbox,
    required bool enableCrashReporting,
  }) {
    platformInterface.initializeWithConfig(config, useSandbox, enableCrashReporting);
  }

  static void initialize({
    required bool useSandbox,
  }) {
    platformInterface.initialize(useSandbox);
  }

  static void setCallbackUrl({
    required Uri callbackUrl,
  }) {
    platformInterface.setCallbackUrl(callbackUrl.toString());
  }

  static void setAllowOfflineMode({
    required bool allowOfflineMode,
  }) {
    platformInterface.setAllowOfflineMode(allowOfflineMode);
  }

  Future<List<String?>> getSubmittedJobs() {
    return platformInterface.getSubmittedJobs();
  }

  Future<List<String?>> getUnsubmittedJobs() {
    return platformInterface.getUnsubmittedJobs();
  }

  Future<SmileIDSdkResult<SmartSelfieCaptureResult>> smartSelfieEnrollment({
    required SmartSelfieCreationParams creationParams,
  }) async {
    try {
      final result = await productsInterface.smartSelfieEnrollment(creationParams);
      return SmileIDSdkResultSuccess(result);
    } on PlatformException catch (e) {
      return SmileIDSdkResultError(e.message ?? "An error occurred communicating with the sdk");
    }
  }

  Future<SmileIDSdkResult<SmartSelfieCaptureResult>> smartSelfieAuthentication({
    required SmartSelfieCreationParams creationParams,
  }) async {
    try {
      final result = await productsInterface.smartSelfieAuthentication(creationParams);
      return SmileIDSdkResultSuccess(result);
    } on PlatformException catch (e) {
      return SmileIDSdkResultError(e.message ?? "An error occurred communicating with the sdk");
    }
  }

  Future<SmileIDSdkResult<SmartSelfieCaptureResult>> smartSelfieEnrollmentEnhanced({
    required SmartSelfieEnhancedCreationParams creationParams,
  }) async {
    try {
      final result = await productsInterface.smartSelfieEnrollmentEnhanced(creationParams);
      return SmileIDSdkResultSuccess(result);
    } on PlatformException catch (e) {
      return SmileIDSdkResultError(e.message ?? "An error occurred communicating with the sdk");
    }
  }

  Future<SmileIDSdkResult<SmartSelfieCaptureResult>> smartSelfieAuthenticationEnhanced({
    required SmartSelfieEnhancedCreationParams creationParams,
  }) async {
    try {
      final result = await productsInterface.smartSelfieAuthenticationEnhanced(creationParams);
      return SmileIDSdkResultSuccess(result);
    } on PlatformException catch (e) {
      return SmileIDSdkResultError(e.message ?? "An error occurred communicating with the sdk");
    }
  }

  Future<SmileIDSdkResult<DocumentCaptureResult>> documentVerification({
    required DocumentVerificationCreationParams creationParams,
  }) async {
    try {
      final result = await productsInterface.documentVerification(creationParams);
      return SmileIDSdkResultSuccess(result);
    } on PlatformException catch (e) {
      return SmileIDSdkResultError(e.message ?? "An error occurred communicating with the sdk");
    }
  }

  Future<SmileIDSdkResult<DocumentCaptureResult>> documentVerificationEnhanced({
    required DocumentVerificationEnhancedCreationParams creationParams,
  }) async {
    try {
      final result = await productsInterface.documentVerificationEnhanced(creationParams);
      return SmileIDSdkResultSuccess(result);
    } on PlatformException catch (e) {
      return SmileIDSdkResultError(e.message ?? "An error occurred communicating with the sdk");
    }
  }

  Future<SmileIDSdkResult<BiometricKYCCaptureResult>> biometricKYC({
    required BiometricKYCCreationParams creationParams,
  }) async {
    try {
      final result = await productsInterface.biometricKYC(creationParams);
      return SmileIDSdkResultSuccess(result);
    } on PlatformException catch (e) {
      return SmileIDSdkResultError(e.message ?? "An error occurred communicating with the sdk");
    }
  }

  static void cleanup(String jobId) {
    platformInterface.cleanup(jobId);
  }

  static void cleanupJobs(List<String> jobIds) {
    platformInterface.cleanupJobs(jobIds);
  }

  static void submitJob(String jobId, bool deleteFilesOnSuccess) {
    platformInterface.submitJob(jobId, deleteFilesOnSuccess);
  }
}
