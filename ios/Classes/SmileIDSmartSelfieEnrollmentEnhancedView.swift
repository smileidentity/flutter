import SwiftUI
import SmileID

struct SmileIDSmartSelfieEnrollmentEnhancedView: View, SmartSelfieResultDelegate, SmileIDFileUtilsProtocol {
    var fileManager: FileManager = Foundation.FileManager.default
    
    let creationParams: SmartSelfieEnhancedCreationParams
    var completion: ((Result<SmartSelfieCaptureResult, any Error>) -> Void)?
    weak var uiViewController: UINavigationController?
    
    var body: some View {
        EnhancedSelfieEnrollmentRootView(
            userId: creationParams.userId ?? "user-\(UUID().uuidString)",
            allowNewEnroll: creationParams.allowNewEnroll,
            showAttribution: creationParams.showAttribution,
            showInstructions: creationParams.showInstructions,
            extraPartnerParams: creationParams.extraPartnerParams ?? [:],
            delegate: self
        ).preferredColorScheme(.light)
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
        completion?(.failure(PigeonError(code: "14", message: error.localizedDescription, details: nil)))
        uiViewController?.popViewController(animated: true)
    }
}

