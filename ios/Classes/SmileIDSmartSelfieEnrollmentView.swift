import SwiftUI
import SmileID
import Foundation
import Flutter

struct SmileIDSmartSelfieEnrollmentView: View, SmartSelfieResultDelegate, SmileIDFileUtilsProtocol {
    var fileManager: FileManager = Foundation.FileManager.default
    
    
    let creationParams: SmartSelfieEnrollmentCreationParams
    var completion: ((Result<SmartSelfieCaptureResult, any Error>) -> Void)?
    weak var uiViewController: UINavigationController?
    
    var body: some View {
        SmileID.smartSelfieEnrollmentScreen(
            userId: creationParams.userId ?? "user-\(UUID().uuidString)",
            allowNewEnroll: creationParams.allowNewEnroll,
            allowAgentMode: creationParams.allowAgentMode,
            showAttribution: creationParams.showAttribution,
            showInstructions: creationParams.showInstructions,
            skipApiSubmission: creationParams.skipApiSubmission,
            extraPartnerParams: creationParams.extraPartnerParams as? [String: String] ?? [:],
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
        completion?(.failure(PigeonError(code: "12", message: error.localizedDescription, details: nil)))
        uiViewController?.popViewController(animated: true)
    }
}

fileprivate extension SmartSelfieResponse {
    func buildResponse() -> Dictionary<String, Any> {
        return [
            "created_at": self.createdAt,
            "job_id": self.jobId,
            "job_type": self.jobType.rawValue,
            "message": self.message,
            "partner_id": self.partnerId,
            "partner_params": self.partnerParams,
            "status": self.status.rawValue,
            "updated_at": self.updatedAt,
            "user_id": self.userId,
        ];
    }
}
