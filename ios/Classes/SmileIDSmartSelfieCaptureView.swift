import Flutter
import SwiftUI
import Combine
import SmileID

class SmileIDSmartSelfieCaptureView: NSObject, FlutterPlatformView {
    private let _childViewController: UIHostingController<AnyView>
    private let _viewModel: SelfieViewModel
    private let _channel: FlutterMethodChannel
    
    static let VIEW_TYPE_ID = "SmileIDSmartSelfieCaptureView"
    
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: [String: Any?],
        binaryMessenger messenger: FlutterBinaryMessenger
    ) {
        let showConfirmationDialog = args["showConfirmationDialog"] as? Bool ?? true
        let allowAgentMode = args["allowAgentMode"] as? Bool ?? true
        
        self._viewModel = SelfieViewModel(
            isEnroll: false,
            userId: generateUserId(),
            jobId: generateJobId(),
            allowNewEnroll: false,
            skipApiSubmission: true,
            extraPartnerParams: [:],
            localMetadata: LocalMetadata()
        )
        
        self._channel = FlutterMethodChannel(
            name: "\(SmileIDSmartSelfieCaptureView.VIEW_TYPE_ID)_\(viewId)",
            binaryMessenger: messenger
        )
        
        let rootView = SmileIDRootView(
            viewModel: _viewModel,
            showConfirmationDialog: showConfirmationDialog,
            allowAgentMode: allowAgentMode,
            channel: _channel
        )
        self._childViewController = UIHostingController(rootView: AnyView(rootView))
        
        super.init()
        
        setupHostingController(frame: frame)
    }
    
    private func setupHostingController(frame: CGRect) {
        _childViewController.view.frame = frame
        _childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func view() -> UIView {
        return _childViewController.view
    }
}

struct SmileIDRootView: View {
    @ObservedObject var viewModel: SelfieViewModel
    let showConfirmationDialog: Bool
    let allowAgentMode: Bool
    let channel: FlutterMethodChannel
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.processingState != nil {
                    Color.clear.onAppear {
                        self.viewModel.onFinished(callback: self)
                    }
                } else if let selfieToConfirm = viewModel.selfieToConfirm, showConfirmationDialog {
                    ImageCaptureConfirmationDialog(
                        title: SmileIDResourcesHelper.localizedString(for: "Confirmation.GoodSelfie"),
                        subtitle: SmileIDResourcesHelper.localizedString(for: "Confirmation.FaceClear"),
                        image: UIImage(data: selfieToConfirm)!,
                        confirmationButtonText: SmileIDResourcesHelper.localizedString(for: "Confirmation.YesUse"),
                        onConfirm: viewModel.submitJob,
                        retakeButtonText: SmileIDResourcesHelper.localizedString(for: "Confirmation.Retake"),
                        onRetake: viewModel.onSelfieRejected,
                        scaleFactor: 1.25
                    ).preferredColorScheme(.light)
                } else {
                    SelfieCaptureScreen(
                        allowAgentMode: allowAgentMode,
                        viewModel: viewModel
                    ).preferredColorScheme(.light)
                }
            }
        }
    }

    
    private func encodeToJSONString<T: Encodable>(_ value: T) -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let jsonData = try? encoder.encode(value) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
    
    private func sendSuccessMessage(with arguments: [String: Any]) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: arguments, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                channel.invokeMethod("onSuccess", arguments: jsonString)
            }
        } catch {
            channel.invokeMethod("onError", arguments: error.localizedDescription)
        }
    }
}

extension SmileIDRootView: SmartSelfieResultDelegate {
    func didSucceed(selfieImage: URL, livenessImages: [URL], apiResponse: SmartSelfieResponse?) {
//        self.childViewController.removeFromParent()
        var arguments: [String: Any] = [
            "selfieFile": selfieImage.absoluteString,
            "livenessFiles": livenessImages.map { $0.absoluteString }
        ]
        if let apiResponse = apiResponse {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            if let jsonData = try? encoder.encode(apiResponse),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                arguments["apiResponse"] = jsonString
            }
        }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: arguments, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                channel.invokeMethod("onSuccess", arguments: jsonString)
            }
        } catch {
            didError(error: error)
        }
    }
    
    func didError(error: Error) {
        channel.invokeMethod("onError", arguments: error.localizedDescription)
    }
}

// MARK: - Factory
extension SmileIDSmartSelfieCaptureView {
    class Factory: NSObject, FlutterPlatformViewFactory {
        private let messenger: FlutterBinaryMessenger
        
        init(messenger: FlutterBinaryMessenger) {
            self.messenger = messenger
            super.init()
        }
        
        func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
            return SmileIDSmartSelfieCaptureView(
                frame: frame,
                viewIdentifier: viewId,
                arguments: args as? [String: Any?] ?? [:],
                binaryMessenger: messenger
            )
        }
        
        func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
            return FlutterStandardMessageCodec.sharedInstance()
        }
    }
}
