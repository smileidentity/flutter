import Flutter
import SwiftUI
import Combine
import SmileID

class SmileIDDocumentCaptureView: NSObject, FlutterPlatformView, SmileIDFileUtilsProtocol {
    var fileManager: FileManager = Foundation.FileManager.default
    private let _childViewController: UIHostingController<AnyView>
    private var _api: SmileIDProductsResultApi
    
    static let VIEW_TYPE_ID = "SmileIDDocumentCaptureView"
    
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: [String: Any?],
        api: SmileIDProductsResultApi
    ) {
        let jobId = generateJobId()
        let isDocumentFrontSide = args["isDocumentFrontSide"] as? Bool ?? true
        let showInstructions = args["showInstructions"] as? Bool ?? true
        let showAttribution = args["showAttribution"] as? Bool ?? true
        let allowGalleryUpload = args["allowGalleryUpload"] as? Bool ?? false
        let idAspectRatio = args["idAspectRatio"] as? Double
        let showConfirmationDialog = args["showConfirmationDialog"] as? Bool ?? true

        self._api = api
        
        let rootView = SmileIDDocumentRootView(
            showConfirmationDialog:showConfirmationDialog,
            isDocumentFrontSide: isDocumentFrontSide,
            showInstructions: showInstructions,
            showAttribution: showAttribution,
            jobId: jobId,
            idAspectRatio: idAspectRatio,
            allowGalleryUpload: allowGalleryUpload,
            api: _api
        )
        self._childViewController = UIHostingController(rootView: AnyView(rootView))
        
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

struct SmileIDDocumentRootView: View {
    let showConfirmationDialog: Bool
    let isDocumentFrontSide: Bool
    let showInstructions: Bool
    let showAttribution: Bool
    let jobId: String
    let idAspectRatio: Double?
    let allowGalleryUpload: Bool
    let api: SmileIDProductsResultApi
    @State private var localMetadata = LocalMetadata()
    
    var body: some View {
        NavigationView {
            DocumentCaptureScreen(
                side: isDocumentFrontSide ? .front : .back,
                showInstructions: showInstructions,
                showAttribution: showAttribution,
                allowGallerySelection: allowGalleryUpload,
                showSkipButton: false,
                instructionsHeroImage: isDocumentFrontSide ? SmileIDResourcesHelper.DocVFrontHero : SmileIDResourcesHelper.DocVBackHero,
                instructionsTitleText: SmileIDResourcesHelper.localizedString(
                    for: isDocumentFrontSide ? "Instructions.Document.Front.Header": "Instructions.Document.Back.Header"
                ),
                instructionsSubtitleText: SmileIDResourcesHelper.localizedString(
                    for: isDocumentFrontSide ? "Instructions.Document.Front.Callout": "Instructions.Document.Back.Callout"
                ),
                captureTitleText: SmileIDResourcesHelper.localizedString(for: "Action.TakePhoto"),
                knownIdAspectRatio: idAspectRatio,
                showConfirmation:showConfirmationDialog,
                onConfirm: onConfirmed,
                onError: didError,
                onSkip: onSkip
            ).preferredColorScheme(.light)
        }.environmentObject(localMetadata).padding()
    }
    
    func onConfirmed(data: Data) {
        do {
            // Attempt to create the document file
            let url = try LocalStorage.createDocumentFile(
                jobId:jobId,
                fileType: isDocumentFrontSide ? FileType.documentFront : FileType.documentBack,
                document: data
            )
            
            let documentKey = isDocumentFrontSide ? "documentFrontImage" : "documentBackImage"
            let result = DocumentCaptureResult(
                documentFrontFile: isDocumentFrontSide ? url.absoluteString : nil,
                documentBackFile: isDocumentFrontSide ? nil : url.absoluteString
            )
            
            api.onDocumentCaptureResult(successResult: result, errorResult: nil){_ in }
        } catch {
            didError(error: error)
        }
    }
    
    func onSkip() {
        
    }
    
    func didError(error: Error) {
        api.onDocumentCaptureResult(successResult: nil, errorResult: error.localizedDescription){_ in}
    }
    
    
    private func encodeToJSONString<T: Encodable>(_ value: T) -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let jsonData = try? encoder.encode(value) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
}

// MARK: - Factory
extension SmileIDDocumentCaptureView {
    class Factory: NSObject, FlutterPlatformViewFactory {
        private var api: SmileIDProductsResultApi
        
        init(api: SmileIDProductsResultApi) {
            self.api = api
            super.init()
        }
        
        func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
            return SmileIDDocumentCaptureView(
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
