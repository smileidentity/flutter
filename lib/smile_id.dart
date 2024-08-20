import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'smileid_messages.g.dart';
import 'smile_id_service.dart';

class SmileID {
  @visibleForTesting
  static SmileIDApi platformInterface = SmileIDApi();
  static SmileIDService api = SmileIDService(platformInterface);

  static void initializeWithApiKey({
    required String apiKey,
    required FlutterConfig config,
    required bool useSandbox,
    required bool enableCrashReporting
  }){
    platformInterface.initializeWithApiKey(apiKey, config, useSandbox, enableCrashReporting);
  }

  static void initialize({
    required FlutterConfig config,
    required bool useSandbox,
    required bool enableCrashReporting
  }) {
    platformInterface.initialize(config, useSandbox, enableCrashReporting);
  }

  static void setCallbackUrl({required Uri callbackUrl}) {
    platformInterface.setCallbackUrl(callbackUrl.toString());
  }

  static void setAllowOfflineMode({required bool allowOfflineMode}) {
    platformInterface.setAllowOfflineMode(allowOfflineMode);
  }

  Future<List<String?>> getSubmittedJobs() {
    return platformInterface.getSubmittedJobs();
  }

  Future<List<String?>> getUnsubmittedJobs() {
    return platformInterface.getUnsubmittedJobs();
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
