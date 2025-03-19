import Combine
import Flutter
import SmileID
import SwiftUI

class SmileIDSmartSelfieCaptureView: NSObject, FlutterPlatformView, SmileIDFileUtilsProtocol {
    var fileManager: FileManager = Foundation.FileManager.default
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
        let showInstructions = args["showInstructions"] as? Bool ?? true
        let showAttribution = args["showAttribution"] as? Bool ?? true
        let allowAgentMode = args["allowAgentMode"] as? Bool ?? true
        let useStrictMode = args["useStrictMode"] as? Bool ?? false
        let allowNewEnroll = args["allowNewEnroll"] as? Bool ?? false

        _viewModel = SelfieViewModel(
            isEnroll: false,
            userId: generateUserId(),
            jobId: generateJobId(),
            allowNewEnroll: allowNewEnroll,
            skipApiSubmission: true,
            extraPartnerParams: [:],
            localMetadata: LocalMetadata()
        )

        _channel = FlutterMethodChannel(
            name: "\(SmileIDSmartSelfieCaptureView.VIEW_TYPE_ID)_\(viewId)",
            binaryMessenger: messenger
        )

        let rootView = SmileIDRootView(
            viewModel: _viewModel,
            showConfirmationDialog: showConfirmationDialog,
            showInstructions: showInstructions,
            allowAgentMode: allowAgentMode,
            showAttribution: showAttribution,
            useStrictMode: useStrictMode,
            allowNewEnroll: allowNewEnroll,
            channel: _channel
        )
        _childViewController = UIHostingController(rootView: AnyView(rootView))

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
    @State private var acknowledgedInstructions = false
    let showConfirmationDialog: Bool
    let showInstructions: Bool
    let allowAgentMode: Bool
    let showAttribution: Bool
    let useStrictMode: Bool
    let allowNewEnroll: Bool
    let channel: FlutterMethodChannel
    static let shared = FileManager()
    private let fileManager = Foundation.FileManager.default

    var body: some View {
        NavigationView {
            selfieCaptureScreen
                .preferredColorScheme(.light)
        }
    }

    private var selfieCaptureScreen: some View {
        Group {
            if useStrictMode {
                AnyView(OrchestratedEnhancedSelfieCaptureScreen(
                    userId: generateUserId(),
                    allowNewEnroll: allowNewEnroll,
                    showAttribution: showAttribution,
                    showInstructions: showInstructions,
                    skipApiSubmission: true,
                    extraPartnerParams: [:],
                    onResult: self
                ))
            } else {
                AnyView(OrchestratedSelfieCaptureScreen(
                    userId: generateUserId(),
                    jobId: generateJobId(),
                    allowNewEnroll: allowNewEnroll,
                    allowAgentMode: allowAgentMode,
                    showAttribution: showAttribution,
                    showInstructions: showInstructions,
                    extraPartnerParams: [:],
                    skipApiSubmission: true,
                    onResult: self
                ))
            }
        }
    }

    private func encodeToJSONString<T: Encodable>(_ value: T) -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let jsonData = try? encoder.encode(value) else {
            return nil
        }
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
            "selfieFile": getFilePath(fileName: selfieImage.absoluteString),
            "livenessFiles": livenessImages.map {
                getFilePath(fileName: $0.absoluteString)
            },
        ]
        if let apiResponse = apiResponse {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            if let jsonData = try? encoder.encode(apiResponse),
               let jsonString = String(data: jsonData, encoding: .utf8)
            {
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

    func getSmileIDDirectory() -> String? {
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Unable to access documents directory")
            return nil
        }

        let smileIDDirectory = documentsDirectory.appendingPathComponent("SmileID")
        return smileIDDirectory.absoluteURL.absoluteString
    }

    func createSmileIDDirectoryIfNeeded() -> Bool {
        guard let smileIDDirectory = getSmileIDDirectory() else {
            return false
        }

        if !fileManager.fileExists(atPath: smileIDDirectory) {
            do {
                try fileManager.createDirectory(atPath: smileIDDirectory, withIntermediateDirectories: true, attributes: nil)
                return true
            } catch {
                print("Error creating SmileID directory: \(error)")
                return false
            }
        }

        return true
    }

    func getFilePath(fileName: String) -> String? {
        guard let smileIDDirectory = getSmileIDDirectory() else {
            return nil
        }

        return (smileIDDirectory as NSString).appendingPathComponent(fileName)
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
