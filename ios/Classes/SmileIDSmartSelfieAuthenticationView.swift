import SwiftUI
import SmileID

struct SmileIDSmartSelfieAuthenticationView: View, SmartSelfieResultDelegate, SmileIDFileUtilsProtocol {
    var fileManager: FileManager = Foundation.FileManager.default
    
    let creationParams: SmartSelfieCreationParams
    var completion: ((Result<SmartSelfieCaptureResult, any Error>) -> Void)?
    weak var uiViewController: UINavigationController?
    
    var body: some View {
        SmileID.smartSelfieAuthenticationScreen(
            userId: creationParams.userId ?? "user-\(UUID().uuidString)",
            allowNewEnroll: creationParams.allowNewEnroll,
            allowAgentMode: creationParams.allowAgentMode,
            showAttribution: creationParams.showAttribution,
            showInstructions: creationParams.showInstructions,
            extraPartnerParams: creationParams.extraPartnerParams ?? [:],
            delegate: self
        )
    }
    
    func didSucceed(selfieImage: URL, livenessImages: [URL], apiResponse: SmartSelfieResponse?) {
        let result = SmartSelfieCaptureResult(
            selfieFile: getFilePath(fileName: selfieImage.absoluteString),
            livenessFiles: livenessImages.map {
                getFilePath(fileName: $0.absoluteString)
            },
            apiResponse: apiResponse?.buildResponse()
        )
        completion?(.success(result))
        uiViewController?.popViewController(animated: true)
    }
    
    func didError(error: any Error) {
        completion?(.failure(PigeonError(code: "13", message: error.localizedDescription, details: nil)))
        uiViewController?.popViewController(animated: true)
    }
}
