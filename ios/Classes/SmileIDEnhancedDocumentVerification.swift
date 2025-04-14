import Flutter
import UIKit
import SmileID
import SwiftUI

class SmileIDEnhancedDocumentVerification : NSObject, FlutterPlatformView, EnhancedDocumentVerificationResultDelegate, SmileIDFileUtilsProtocol {
    private var _api: SmileIDProductsResultApi
    var fileManager: FileManager = Foundation.FileManager.default
    private var _view: UIView
    private var _childViewController: UIViewController?
    
    static let VIEW_TYPE_ID = "SmileIDEnhancedDocumentVerification"
    
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: [String: Any?],
        api: SmileIDProductsResultApi
    ) {
        _api = api
        _view = UIView()
        _childViewController = nil
        super.init()
        let bypassSelfieCaptureWithFile = (args["bypassSelfieCaptureWithFile"] as? String)
            .flatMap { URL(string: $0) }
        let screen = SmileID.enhancedDocumentVerificationScreen(
            userId: args["userId"] as? String ?? "user-\(UUID().uuidString)",
            jobId: args["jobId"] as? String ?? "job-\(UUID().uuidString)",
            allowNewEnroll: args["allowNewEnroll"] as? Bool ?? false,
            countryCode: args["countryCode"] as! String,
            documentType: args["documentType"] as? String,
            idAspectRatio: args["idAspectRatio"] as? Double,
            bypassSelfieCaptureWithFile: bypassSelfieCaptureWithFile,
            captureBothSides: args["captureBothSides"] as? Bool ?? true,
            allowAgentMode: args["allowAgentMode"] as? Bool ?? false,
            allowGalleryUpload: args["allowGalleryUpload"] as? Bool ?? false,
            showInstructions: args["showInstructions"] as? Bool ?? true,
            skipApiSubmission: args["skipApiSubmission"] as? Bool ?? false,
            showAttribution: args["showAttribution"] as? Bool ?? true,
            useStrictMode: args["useStrictMode"] as? Bool ?? false,
            extraPartnerParams: args["extraPartnerParams"] as? [String: String] ?? [:],
            consentInformation: ConsentInformation(
                consentGrantedDate: args["consentGrantedDate"] as? String ?? getCurrentIsoTimestamp(),
                personalDetailsConsentGranted: args["personalDetailsConsentGranted"] as? Bool ?? false,
                contactInformationConsentGranted: args["contactInfoConsentGranted"] as? Bool ?? false,
                documentInformationConsentGranted: args["documentInfoConsentGranted"] as? Bool ?? false
            ),
            delegate: self
        )
        let navView = NavigationView{screen}
        _childViewController = embedView(navView, in: _view, frame: frame)
    }
    
    func view() -> UIView {
        return _view
    }
    
    func didSucceed(selfie: URL, documentFrontImage: URL, documentBackImage: URL?, didSubmitEnhancedDocVJob: Bool) {
        _childViewController?.removeFromParent()
        let result = DocumentCaptureResult(selfieFile: getFilePath(fileName: selfie.absoluteString), documentFrontFile: getFilePath(fileName: documentFrontImage.absoluteString), didSubmitEnhancedDocVJob: didSubmitEnhancedDocVJob)
        _api.onDocumentVerificationEnhancedResult(successResult: result, errorResult: nil) {_ in}
    }
    
    func didError(error: Error) {
        print("[Smile ID] An error occurred - \(error.localizedDescription)")
        _api.onDocumentVerificationEnhancedResult(successResult: nil, errorResult: error.localizedDescription) {_ in}
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
            return SmileIDEnhancedDocumentVerification(
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
