import Flutter
import UIKit
import SmileID
import SwiftUI

class SmileIDBiometricKYC : NSObject, FlutterPlatformView, BiometricKycResultDelegate, SmileIDFileUtilsProtocol {
    var fileManager: FileManager = Foundation.FileManager.default
    private var _view: UIView
    private var _api: SmileIDProductsResultApi
    private var _childViewController: UIViewController?

    static let VIEW_TYPE_ID = "SmileIDBiometricKYC"

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
        let screen = SmileID.biometricKycScreen(
            idInfo: IdInfo(
                country:  args["country"] as? String ?? "",
                idType:  args["idType"] as? String,
                idNumber:  args["idNumber"] as? String,
                firstName:  args["firstName"] as? String,
                middleName:  args["middleName"] as? String,
                lastName:  args["lastName"] as? String,
                dob:  args["dob"] as? String,
                bankCode:  args["bankCode"] as? String,
                entered:  args["entered"] as? Bool
            ),
            userId: args["userId"] as? String ?? generateUserId(),
            jobId: args["jobId"] as? String ?? generateJobId(),
            allowNewEnroll: args["allowNewEnroll"] as? Bool ?? false,
            allowAgentMode: args["allowAgentMode"] as? Bool ?? false,
            showAttribution: args["showAttribution"] as? Bool ?? true,
            showInstructions: args["showInstructions"] as? Bool ?? true,
            useStrictMode: args["useStrictMode"] as? Bool ?? false,
            extraPartnerParams: args["extraPartnerParams"] as? [String: String] ?? [:],
            consentInformation: ConsentInformation( consented: ConsentedInformation(
                consentGrantedDate: args["consentGrantedDate"] as? String ?? getCurrentIsoTimestamp(),
                personalDetails: args["personalDetailsConsentGranted"] as? Bool ?? false,
                contactInformation: args["contactInfoConsentGranted"] as? Bool ?? false,
                documentInformation: args["documentInfoConsentGranted"] as? Bool ?? false
            )
            ),
            delegate: self
        )
        let navView = NavigationView{screen}
        _childViewController = embedView(navView, in: _view, frame: frame)
    }

    func view() -> UIView {
        return _view
    }

    func didSucceed(selfieImage: URL, livenessImages: [URL], didSubmitBiometricJob: Bool) {
        _childViewController?.removeFromParent()
        let result = BiometricKYCCaptureResult(selfieFile: getFilePath(fileName: selfieImage.absoluteString), livenessFiles: livenessImages.map{
            getFilePath(fileName: $0.absoluteString)
        }, didSubmitBiometricKycJob: didSubmitBiometricJob)
        _api.onBiometricKYCResult(successResult: result, errorResult: nil) {_ in }
    }

    func didError(error: Error) {
        print("[Smile ID] An error occurred - \(error.localizedDescription)")
        _api.onBiometricKYCResult(successResult: nil, errorResult: error.localizedDescription) {_ in }
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
            return SmileIDBiometricKYC(
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
