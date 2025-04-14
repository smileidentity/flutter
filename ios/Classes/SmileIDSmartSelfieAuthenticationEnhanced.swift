import Flutter
import UIKit
import SmileID
import SwiftUI

class SmileIDSmartSelfieAuthenticationEnhanced : NSObject, FlutterPlatformView, SmartSelfieResultDelegate,SmileIDFileUtilsProtocol {
    private var _api: SmileIDProductsResultApi
    var fileManager: FileManager = Foundation.FileManager.default
    private var _view: UIView
    private var _childViewController: UIViewController?

    static let VIEW_TYPE_ID = "SmileIDSmartSelfieAuthenticationEnhanced"

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: [String: Any?],
        api: SmileIDProductsResultApi
    ) {
        _view = UIView()
        _api = api
        _childViewController = nil
        super.init()
        let screen = EnhancedSelfieAuthenticationRootView(
            userId: args["userId"] as? String ?? "user-\(UUID().uuidString)",
            allowNewEnroll: args["allowNewEnroll"] as? Bool ?? false,
            showAttribution: args["showAttribution"] as? Bool ?? true,
            showInstructions: args["showInstructions"] as? Bool ?? true,
            skipApiSubmission: args["skipApiSubmission"] as? Bool ?? false,
            extraPartnerParams: args["extraPartnerParams"] as? [String: String] ?? [:],
            delegate: self
        )
        _childViewController = embedView(screen, in: _view, frame: frame)
    }

    func view() -> UIView {
        return _view
    }

    func didSucceed(selfieImage: URL, livenessImages: [URL], apiResponse: SmartSelfieResponse?) {
        _childViewController?.removeFromParent()
        let result = SmartSelfieCaptureResult(selfieFile: getFilePath(fileName: selfieImage.absoluteString), livenessFiles: livenessImages.map {
            getFilePath(fileName: $0.absoluteString)
        },
        apiResponse: apiResponse?.buildResponse(),)
        _api.onSmartSelfieAuthenticationEnhancedResult(successResult: result, errorResult: nil) {_ in}
    }

    func didError(error: Error) {
        print("[Smile ID] An error occurred - \(error.localizedDescription)")
        _api.onSmartSelfieAuthenticationEnhancedResult(successResult: nil, errorResult: error.localizedDescription){_ in}
    
    }

    class Factory : NSObject, FlutterPlatformViewFactory {
        private var api: SmileIDProductsResultApi
        init(api: SmileIDProductsResultApi) {
            self.api = api
            super.init()
        }

        func create(
            withFrame frame: CGRect,
            viewIdentifier viewId: Int64,
            arguments args: Any?
        ) -> FlutterPlatformView {
            return SmileIDSmartSelfieAuthenticationEnhanced(
                frame: frame,
                viewIdentifier: viewId,
                arguments: args as! [String: Any?],
               api: api
            )
        }

        public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
              return FlutterStandardMessageCodec.sharedInstance()
        }
    }
}

struct EnhancedSelfieAuthenticationRootView: View {
    let userId: String
    let allowNewEnroll: Bool
    let showAttribution: Bool
    let showInstructions: Bool
    let skipApiSubmission: Bool
    let extraPartnerParams: [String: String]
    let delegate: SmartSelfieResultDelegate

    var body: some View {
        NavigationView {
            SmileID.smartSelfieAuthenticationScreenEnhanced(
                userId: userId,
                allowNewEnroll: allowNewEnroll,
                showAttribution: showAttribution,
                showInstructions: showInstructions,
                skipApiSubmission: skipApiSubmission,
                extraPartnerParams: extraPartnerParams,
                delegate: delegate
            )
        }
    }
}
