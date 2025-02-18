import SwiftUI
import SmileID
import Foundation
import Flutter

struct SmileIDSmartSelfieEnrollmentView: View, SmartSelfieResultDelegate, SmileIDFileUtilsProtocol {
    var fileManager: FileManager = Foundation.FileManager.default
    
    
    let creationParams: SmartSelfieCreationParams
    var completion: ((Result<SmartSelfieCaptureResult, any Error>) -> Void)?
    weak var uiViewController: UINavigationController?
    
    var body: some View {
        VStack(alignment: .leading) {
            Button("Back") {
                completion?(.failure(PigeonError(code: "12", message: "User cancelled operation", details: nil)))
                uiViewController?.popViewController(animated: true)
            }.padding(.leading, 20)
            
            SmileID.smartSelfieEnrollmentScreen(
                userId: creationParams.userId ?? "user-\(UUID().uuidString)",
                allowNewEnroll: creationParams.allowNewEnroll,
                allowAgentMode: creationParams.allowAgentMode,
                showAttribution: creationParams.showAttribution,
                showInstructions: creationParams.showInstructions,
                skipApiSubmission: creationParams.skipApiSubmission,
                extraPartnerParams: creationParams.extraPartnerParams ?? [:],
                delegate: self
            ).preferredColorScheme(.light)
        }
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
        completion?(.failure(PigeonError(code: "12", message: error.localizedDescription, details: nil)))
        uiViewController?.popViewController(animated: true)
    }
}
