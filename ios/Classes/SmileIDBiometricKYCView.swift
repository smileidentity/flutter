import SwiftUI
import SmileID

struct SmileIDBiometricKYCView: View, BiometricKycResultDelegate, SmileIDFileUtilsProtocol {
    var fileManager: FileManager = Foundation.FileManager.default
    
    let creationParams: BiometricKYCCreationParams
    var completion: ((Result<BiometricKYCCaptureResult, any Error>) -> Void)?
    
    weak var uiViewController: UINavigationController?
    
    var body: some View {
        VStack(alignment: .leading) {
            Button("Back") {
                completion?(.failure(PigeonError(code: "16", message: "User cancelled operation", details: nil)))
                uiViewController?.popViewController(animated: true)
            }.padding(.leading, 20)
            
            SmileID.biometricKycScreen(
                idInfo: IdInfo(
                    country: creationParams.country ?? "",
                    idType: creationParams.idType,
                    idNumber: creationParams.idNumber,
                    firstName: creationParams.firstName,
                    middleName: creationParams.middleName,
                    lastName: creationParams.lastName,
                    dob: creationParams.dob,
                    bankCode: creationParams.bankCode,
                    entered: creationParams.entered
                ),
                userId: creationParams.userId ?? generateUserId(),
                jobId: creationParams.jobId ?? generateJobId(),
                allowNewEnroll: creationParams.allowNewEnroll,
                allowAgentMode: creationParams.allowAgentMode,
                showAttribution: creationParams.showAttribution,
                showInstructions: creationParams.showInstructions,
                extraPartnerParams: creationParams.extraPartnerParams ?? [:],
                delegate: self
            )
            .frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .preferredColorScheme(.light)
        }
    }
    
    
    func didSucceed(selfieImage: URL, livenessImages: [URL], didSubmitBiometricJob: Bool) {
        let result = BiometricKYCCaptureResult(
            selfieFile: getFilePath(fileName: selfieImage.absoluteString),
            livenessFiles: livenessImages.map {
                getFilePath(fileName: $0.absoluteString)
            },
            didSubmitBiometricKycJob: didSubmitBiometricJob
        )
        
        completion?(.success(result))
        uiViewController?.popViewController(animated: true)
    }
    
    func didError(error: any Error) {
        completion?(.failure(PigeonError(code: "16", message: error.localizedDescription, details: nil)))
        uiViewController?.popViewController(animated: true)
    }
}

