import 'package:flutter/widgets.dart';

import '../../views/smile_view.dart';

class SmileIDDocumentCaptureView extends StatelessWidget {
  static const String viewType = "SmileIDDocumentCaptureView";
  final Map<String, dynamic> creationParams;

  /// Called when the user successfully completes the smart selfie enrollment flow. The result is a
  /// JSON string.
  final Function(String) onSuccess;
  final Function(String) onError;

  const SmileIDDocumentCaptureView._({
    required this.creationParams,
    required this.onSuccess,
    required this.onError,
  });

  factory SmileIDDocumentCaptureView({
    Key? key,
    bool enableAutoCapture = true,
    bool isDocumentFrontSide = true,
    bool showInstructions = true,
    bool showAttribution = true,
    bool allowGalleryUpload = true,
    bool showConfirmationDialog = true,
    double? idAspectRatio,
    required Function(String resultJson) onSuccess,
    required Function(String errorMessage) onError,
  }) {
    return SmileIDDocumentCaptureView._(
      onSuccess: onSuccess,
      onError: onError,
      creationParams: {
        "enableAutoCapture": enableAutoCapture,
        "isDocumentFrontSide": isDocumentFrontSide,
        "showInstructions": showInstructions,
        "showAttribution": showAttribution,
        "allowGalleryUpload": allowGalleryUpload,
        "showConfirmationDialog": showConfirmationDialog,
        "idAspectRatio": idAspectRatio,
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
