import 'package:flutter/widgets.dart';

import '../../views/smile_view.dart';

class SmileIDSmartSelfieCaptureView extends StatelessWidget {
  static const String viewType = "SmileIDSmartSelfieCaptureView";
  final Map<String, dynamic> creationParams;

  /// Called when the user successfully completes the selfie capture flow. The result is a
  /// JSON string.
  final Function(String) onSuccess;
  final Function(String) onError;

  const SmileIDSmartSelfieCaptureView._({
    required this.creationParams,
    required this.onSuccess,
    required this.onError,
  });

  factory SmileIDSmartSelfieCaptureView({
    Key? key,
    bool showConfirmationDialog = true,
    bool showInstructions = true,
    bool showAttribution = true,
    bool allowAgentMode = true,
    bool useStrictMode = false,
    required Function(String resultJson) onSuccess,
    required Function(String errorMessage) onError,
  }) {
    return SmileIDSmartSelfieCaptureView._(
      onSuccess: onSuccess,
      onError: onError,
      creationParams: {
        "showConfirmationDialog": showConfirmationDialog,
        "showInstructions": showInstructions,
        "showAttribution": showAttribution,
        "allowAgentMode": allowAgentMode,
        "useStrictMode": useStrictMode,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildSmileIDPlatformView(
      context: context,
      viewType: viewType,
      creationParams: creationParams,
      onSuccess: onSuccess,
      onError: onError,
    );
  }
}
