import Flutter
import UIKit
import SmileID
import SwiftUI

class SmileIDSmartSelfieEnrollmentV2 : NSObject, FlutterPlatformView, SmartSelfieResultDelegate,SmileIDFileUtilsProtocol {
    var fileManager: FileManager = Foundation.FileManager.default
    private var _view: UIView
    private var _channel: FlutterMethodChannel
    private var _childViewController: UIViewController?

    static let VIEW_TYPE_ID = "SmileIDSmartSelfieEnrollmentV2"

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: [String: Any?],
        binaryMessenger messenger: FlutterBinaryMessenger
    ) {
        _view = UIView()
        _channel = FlutterMethodChannel(
            name: "\(SmileIDSmartSelfieEnrollmentV2.VIEW_TYPE_ID)_\(viewId)",
            binaryMessenger: messenger
        )
        _childViewController = nil
        super.init()
        let screen = SmileID.smartSelfieEnrollmentScreenV2(
            userId: args["userId"] as? String ?? "user-\(UUID().uuidString)",
            allowNewEnroll: args["allowNewEnroll"] as? Bool ?? false,
            showAttribution: args["showAttribution"] as? Bool ?? true,
            showInstructions: args["showInstructions"] as? Bool ?? true,
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
        // todo
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
            return SmileIDSmartSelfieEnrollmentV2(
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
