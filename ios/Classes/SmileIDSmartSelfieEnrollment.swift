import Flutter
import UIKit
import SmileID
import SwiftUI

class SmileIDSmartSelfieEnrollment : NSObject, FlutterPlatformView, SmartSelfieResultDelegate, SmileIDFileUtilsProtocol {
    private var _api: SmileIDProductsResultApi
    var fileManager: FileManager = Foundation.FileManager.default
    private var _view: UIView
    private var _childViewController: UIViewController?

    static let VIEW_TYPE_ID = "SmileIDSmartSelfieEnrollment"

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: [String: Any?],
        api: SmileIDProductsResultApi
    ) {
        _api = api
        _view = UIView()
        super.init()
        let screen = SmileID.smartSelfieEnrollmentScreen(
            userId: args["userId"] as? String ?? "user-\(UUID().uuidString)",
            allowNewEnroll: args["allowNewEnroll"] as? Bool ?? false,
            allowAgentMode: args["allowAgentMode"] as? Bool ?? false,
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
        let result = SmartSelfieCaptureResult(
            selfieFile: getFilePath(fileName: selfieImage.absoluteString),
            livenessFiles: livenessImages.map {
                getFilePath(fileName: $0.absoluteString)
            },
            apiResponse: apiResponse?.buildResponse()
        )
        
        _api.onSmartSelfieEnrollmentResult(successResult: result, errorResult: nil) {_ in}
    }

    func didError(error: Error) {
        print("[Smile ID] An error occurred - \(error.localizedDescription)")
        _api
            .onSmartSelfieEnrollmentResult(
                successResult: nil,
                errorResult: error.localizedDescription
            ) { _ in }
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
            return SmileIDSmartSelfieEnrollment(
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
