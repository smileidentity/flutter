import SwiftUI
import SmileID

struct SmileIDDocumentVerificationView: View, DocumentVerificationResultDelegate, SmileIDFileUtilsProtocol {
    var fileManager: FileManager = Foundation.FileManager.default
    
    let creationParams: DocumentVerificationCreationParams
    var completion: ((Result<DocumentCaptureResult, any Error>) -> Void)?
    weak var uiViewController: UINavigationController?
    
    var body: some View {
        VStack(alignment: .leading) {
            Button("Back") {
                completion?(.failure(PigeonError(code: "17", message: "User cancelled operation", details: nil)))
                uiViewController?.popViewController(animated: true)
            }.padding(.leading, 20)
            
            SmileID.documentVerificationScreen(
                userId: creationParams.userId ?? "user-\(UUID().uuidString)",
                jobId: creationParams.jobId ?? "job-\(UUID().uuidString)",
                allowNewEnroll: creationParams.allowNewEnroll,
                countryCode: creationParams.countryCode,
                documentType: creationParams.documentType,
                idAspectRatio: creationParams.idAspectRatio,
                bypassSelfieCaptureWithFile: creationParams.bypassSelfieCaptureWithFile.flatMap{ URL(string: $0) },
                captureBothSides: creationParams.captureBothSides,
                allowAgentMode: creationParams.allowAgentMode,
                allowGalleryUpload: creationParams.allowGalleryUpload,
                showInstructions: creationParams.showInstructions,
                showAttribution: creationParams.showAttribution,
                skipApiSubmission: creationParams.skipApiSubmission,
                extraPartnerParams: creationParams.extraPartnerParams ?? [:],
                delegate: self
            ).preferredColorScheme(.light)
        }
    }
    
    func didSucceed(selfie: URL, documentFrontImage: URL, documentBackImage: URL?, didSubmitDocumentVerificationJob: Bool) {
        let result = DocumentCaptureResult(
            selfieFile: getFilePath(fileName: selfie.absoluteString),
            documentFrontFile: getFilePath(fileName: documentFrontImage.absoluteString),
            didSubmitDocumentVerificationJob: didSubmitDocumentVerificationJob
        )
        
        completion?(.success(result))
        uiViewController?.popViewController(animated: true)
    }
    
    func didError(error: any Error) {
        completion?(.failure(PigeonError(code: "17", message: error.localizedDescription, details: nil)))
        uiViewController?.popViewController(animated: true)
    }
}

