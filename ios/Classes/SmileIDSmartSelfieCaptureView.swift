import Combine
import Flutter
import SmileID
import SwiftUI

class SmileIDSmartSelfieCaptureView: NSObject, FlutterPlatformView, SmileIDFileUtilsProtocol {
    var fileManager: FileManager = Foundation.FileManager.default
    private let _childViewController: UIHostingController<AnyView>
    private let _viewModel: SelfieViewModel
    private var _api: SmileIDProductsResultApi

    static let VIEW_TYPE_ID = "SmileIDSmartSelfieCaptureView"

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: [String: Any?],
        api: SmileIDProductsResultApi
    ) {
        let showConfirmationDialog = args["showConfirmationDialog"] as? Bool ?? true
        let showInstructions = args["showInstructions"] as? Bool ?? true
        let showAttribution = args["showAttribution"] as? Bool ?? true
        let allowAgentMode = args["allowAgentMode"] as? Bool ?? true
        let useStrictMode = args["useStrictMode"] as? Bool ?? false

        _viewModel = SelfieViewModel(
            isEnroll: false,
            userId: generateUserId(),
            jobId: generateJobId(),
            allowNewEnroll: false,
            skipApiSubmission: true,
            extraPartnerParams: [:]
        )

        _api = api

        let rootView = SmileIDRootView(
            viewModel: _viewModel,
            showConfirmationDialog: showConfirmationDialog,
            showInstructions: showInstructions,
            allowAgentMode: allowAgentMode,
            showAttribution: showAttribution,
            useStrictMode: useStrictMode,
            api: _api
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
    let api: SmileIDProductsResultApi
    static let shared = FileManager()
    private let fileManager = Foundation.FileManager.default

    var body: some View {
        NavigationView {
            selfieCaptureScreen
                .preferredColorScheme(.light)
        }
    }

    private var selfieCaptureScreen: some View {
        ZStack {
            if useStrictMode {
                SmileID.smartSelfieEnrollmentScreenEnhanced(
                    userId: generateUserId(),
                    showAttribution: showAttribution,
                    showInstructions: showInstructions,
                    skipApiSubmission: true,
                    delegate: self
                )
            } else {
                legacySelfieCaptureScreen
            }
        }
    }

    private var legacySelfieCaptureScreen: some View {
        ZStack {
            if showInstructions, !acknowledgedInstructions {
                SmartSelfieInstructionsScreen(showAttribution: showAttribution) {
                    acknowledgedInstructions = true
                }
                .padding()
            } else if viewModel.processingState != nil {
                Color.clear.onAppear {
                    self.viewModel.onFinished(callback: self)
                }
            } else if let selfieToConfirm = viewModel.selfieToConfirm {
                if showConfirmationDialog {
                    ImageCaptureConfirmationDialog(
                        title: SmileIDResourcesHelper.localizedString(for: "Confirmation.GoodSelfie"),
                        subtitle: SmileIDResourcesHelper.localizedString(for: "Confirmation.FaceClear"),
                        image: UIImage(data: selfieToConfirm)!,
                        confirmationButtonText: SmileIDResourcesHelper.localizedString(for: "Confirmation.YesUse"),
                        onConfirm: viewModel.submitJob,
                        retakeButtonText: SmileIDResourcesHelper.localizedString(for: "Confirmation.Retake"),
                        onRetake: viewModel.onSelfieRejected,
                        scaleFactor: 1.25
                    )
                    .preferredColorScheme(.light)
                } else {
                    Color.clear.onAppear {
                        self.viewModel.submitJob()
                    }
                }
            } else {
                SelfieCaptureScreen(
                    viewModel: viewModel, allowAgentMode: allowAgentMode
                ).preferredColorScheme(.light)
            }
        }
    }

    private func encodeToJSONString<T: Encodable>(_ value: T) -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let jsonData = try? encoder.encode(value) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
}

extension SmileIDRootView: SmartSelfieResultDelegate {
    func didSucceed(selfieImage: URL, livenessImages: [URL], apiResponse: SmartSelfieResponse?) {
        //        self.childViewController.removeFromParent()
        let result = SmartSelfieCaptureResult(
            selfieFile: getFilePath(fileName: selfieImage.absoluteString),
            livenessFiles: livenessImages.map { getFilePath(fileName: $0.absoluteString) ?? "" },
            apiResponse: apiResponse?.buildResponse()
        )
        api.onSelfieCaptureResult(successResult: result, errorResult: nil) {_ in}
    }

    func didError(error: Error) {
        api.onSelfieCaptureResult(successResult: nil, errorResult: error.localizedDescription){_ in}
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
        private let api: SmileIDProductsResultApi

        init(api: SmileIDProductsResultApi) {
            self.api = api
            super.init()
        }

        func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
            return SmileIDSmartSelfieCaptureView(
                frame: frame,
                viewIdentifier: viewId,
                arguments: args as? [String: Any?] ?? [:],
                api: api
            )
        }

        func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
            return FlutterStandardMessageCodec.sharedInstance()
        }
    }
}
