import Flutter
import UIKit
import SmileID
import SwiftUI

class SmileIDDocumentVerification : NSObject, FlutterPlatformView, SmartSelfieResultDelegate {
    private var _view: UIView
    private var _channel: FlutterMethodChannel

    static let VIEW_TYPE_ID = "SmileIDDocumentVerification"

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: [String: Any?],
        binaryMessenger messenger: FlutterBinaryMessenger
    ) {
        _view = UIView()
        _channel = FlutterMethodChannel(name: "\(SmileIDDocumentVerification.VIEW_TYPE_ID)_\(viewId)", binaryMessenger: messenger)
        super.init()
        
        // TODO: Replace with documentVerificationScreen once iOS is updated
        let screen = SmileID.smartSelfieEnrollmentScreen(
            userId: args["userId"] as? String ?? "user-\(UUID().uuidString)",
            jobId: args["jobId"] as? String ?? "job-\(UUID().uuidString)",
            delegate: self
        )
        let controller = UIHostingController(rootView: screen)
        let rootViewController  = UIApplication.shared.windows.first?.rootViewController

        controller.view.frame = frame
        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        _view.addSubview(controller.view)
        rootViewController?.addChild(controller)
    }

    func view() -> UIView {
        return _view
    }
    
    func didSucceed(selfieImage: Data, livenessImages: [Data], jobStatusResponse: JobStatusResponse?) {
        print("Successfully submitted job")
        let encoder = JSONEncoder()
        _channel.invokeMethod("onSuccess", arguments: """
        "selfieFile": "TODO (replace with URL path returned by document delegate)",
        "documentFrontFile": "TODO",
        "documentBackFile": "TODO",
        "jobStatusResponse": \(try! encoder.encode(jobStatusResponse))
        """)
    }

    func didError(error: Error) {
        print("An error occurred - \(error.localizedDescription)")
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
