import Flutter
import UIKit
import SmileID
import SwiftUI

class SmileIDDocumentVerification : NSObject, FlutterPlatformView, DocumentCaptureResultDelegate {
    private var _view: UIView
    private var _channel: FlutterMethodChannel
    private var _childViewController: UIViewController?

    static let VIEW_TYPE_ID = "SmileIDDocumentVerification"

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: [String: Any?],
        binaryMessenger messenger: FlutterBinaryMessenger
    ) {
        _view = UIView()
        _channel = FlutterMethodChannel(name: "\(SmileIDDocumentVerification.VIEW_TYPE_ID)_\(viewId)", binaryMessenger: messenger)
        _childViewController = nil
        super.init()
        let selfie = (args["bypassSelfieCaptureWithFile"] as? String)
                    .map { URL(string: $0) }?
                    .flatMap { try? Data(contentsOf: $0) }
        let screen = SmileID.documentVerificationScreen(
            userId: args["userId"] as? String ?? "user-\(UUID().uuidString)",
            jobId: args["jobId"] as? String ?? "job-\(UUID().uuidString)",
            countryCode: args["countryCode"] as! String,
            documentType: args["documentType"] as? String,
            idAspectRatio: args["idAspectRatio"] as? Double,
            selfie: selfie,
            captureBothSides: args["captureBothSides"] as? Bool ?? true,
            allowGalleryUpload: args["allowGalleryUpload"] as? Bool ?? false,
            showInstructions: args["showInstructions"] as? Bool ?? true,
            showAttribution: args["showAttribution"] as? Bool ?? true,
            delegate: self
        )
        let childViewController = UIHostingController(rootView: screen)
        
        childViewController.view.frame = frame
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        _view.addSubview(childViewController.view)
        let rootViewController = UIApplication.shared.windows.first?.rootViewController
        rootViewController?.addChild(childViewController)
        _childViewController = childViewController
    }

    func view() -> UIView {
        return _view
    }
    
    func didSucceed(selfie: URL, documentFrontImage: URL, documentBackImage: URL?, jobStatusResponse: JobStatusResponse) {
        _childViewController?.removeFromParent()
        let encoder = JSONEncoder()
        let documentBackFileJson = documentBackImage.map{ "\"\($0.absoluteString)\"" } ?? "null"
        _channel.invokeMethod("onSuccess", arguments: """
        "selfieFile": "\(selfie.absoluteString)",
        "documentFrontFile": "\(documentFrontImage.absoluteString)",
        "documentBackFile": \(documentBackFileJson),
        "jobStatusResponse": \(try! encoder.encode(jobStatusResponse))
        """)
    }

    func didError(error: Error) {
        print("[Smile ID] An error occurred - \(error.localizedDescription)")
        _channel.invokeMethod("onError", arguments: error.localizedDescription)
    }
    

    class Factory : NSObject, FlutterPlatformViewFactory {
        private var messenger: FlutterBinaryMessenger
        init(messenger: FlutterBinaryMessenger) {
            self.messenger = messenger
            super.init()
        }

        func create(
            withFrame frame: CGRect,
            viewIdentifier viewId: Int64,
            arguments args: Any?
        ) -> FlutterPlatformView {
            return SmileIDDocumentVerification(
                frame: frame,
                viewIdentifier: viewId,
                arguments: args as! [String: Any?],
                binaryMessenger: messenger
            )
        }
        
        public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
              return FlutterStandardMessageCodec.sharedInstance()
        }
    }
}
