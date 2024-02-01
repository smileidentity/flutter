import Flutter
import UIKit
import SmileID
import SwiftUI

class SmileIDSmartSelfieAuthentication : NSObject, FlutterPlatformView, SmartSelfieResultDelegate {
    private var _view: UIView
    private var _channel: FlutterMethodChannel
    private var _childViewController: UIViewController?

    static let VIEW_TYPE_ID = "SmileIDSmartSelfieAuthentication"

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: [String: Any?],
        binaryMessenger messenger: FlutterBinaryMessenger
    ) {
        _view = UIView()
        _channel = FlutterMethodChannel(
            name: "\(SmileIDSmartSelfieAuthentication.VIEW_TYPE_ID)_\(viewId)",
            binaryMessenger: messenger
        )
        _childViewController = nil
        super.init()
        let screen = SmileID.smartSelfieEnrollmentScreen(
            userId: args["userId"] as? String ?? "user-\(UUID().uuidString)",
            jobId: args["jobId"] as? String ?? "job-\(UUID().uuidString)",
            allowNewEnroll: args["allowNewEnroll"] as? Bool ?? false,
            allowAgentMode: args["allowAgentMode"] as? Bool ?? false,
            showAttribution: args["showAttribution"] as? Bool ?? true,
            showInstructions: args["showInstructions"] as? Bool ?? true,
            extraPartnerParams: args["extraPartnerParams"] as? [String: String] ?? [:],
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

    func didSucceed(selfieImage: URL, livenessImages: [URL], jobStatusResponse: SmartSelfieJobStatusResponse?) {
        _childViewController?.removeFromParent()
        let encoder = JSONEncoder()
        let jobStatusResponseJson: String
        if let jobStatusResponse = jobStatusResponse {
            let jsonData = try! encoder.encode(jobStatusResponse)
            jobStatusResponseJson = String(data: jsonData, encoding: .utf8)!
        } else {
            jobStatusResponseJson = "null"
        }
        _channel.invokeMethod("onSuccess", arguments: """
        {"selfieFile": "\(selfieImage.absoluteString)",
        "livenessImages": "\(livenessImages.map { $0.absoluteString })",
        "jobStatusResponse": \(jobStatusResponseJson)}
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
            return SmileIDSmartSelfieAuthentication(
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
