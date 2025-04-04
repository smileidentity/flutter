import SwiftUI
import SmileID

struct SmileDocumentCaptureView: View , SmileIDFileUtilsProtocol {
    var fileManager: FileManager = Foundation.FileManager.default
    private let jobId = generateJobId()
    
    @State private var localMetadata = LocalMetadata()
    
    let creationParams: DocumentCaptureCreationParams
    let completion: ((Result<DocumentCaptureResult, any Error>) -> Void)?
    weak var uiViewController: UINavigationController?
    
    var body: some View {
        VStack(alignment: .leading) {
            Button("Back") {
                completion?(.failure(PigeonError(code: "20", message: "User cancelled operation", details: nil)))
                uiViewController?.popViewController(animated: true)
            }.padding(.leading, 20)
            
            NavigationView {
                DocumentCaptureScreen(
                    side: creationParams.isDocumentFrontSide ? .front: .back,
                    showInstructions: creationParams.showInstructions,
                    showAttribution: creationParams.showAttribution,
                    allowGallerySelection: creationParams.allowGalleryUpload,
                    showSkipButton: false,
                    instructionsHeroImage: creationParams.isDocumentFrontSide ? SmileIDResourcesHelper.DocVFrontHero: SmileIDResourcesHelper.DocVBackHero,
                    instructionsTitleText: SmileIDResourcesHelper.localizedString(
                        for: creationParams.isDocumentFrontSide ? "Instructions.Document.Front.Header": "Instructions.Document.Back.Header"
                    ),
                    instructionsSubtitleText: SmileIDResourcesHelper.localizedString(
                        for: creationParams.isDocumentFrontSide ? "Instructions.Document.Front.Callout": "Instructions.Document.Back.Callout"
                    ),
                    captureTitleText: SmileIDResourcesHelper.localizedString(for: "Action.TakePhoto"),
                    knownIdAspectRatio: creationParams.idAspectRatio,
                    showConfirmation: creationParams.showConfirmationDialog,
                    onConfirm: onConfirmed,
                    onError: didError,
                    onSkip: onSkip
                ).preferredColorScheme(.light)
            }
            .frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .environmentObject(localMetadata).padding()
        }
    }
    
    func onConfirmed(data: Data) {
        do {
            // Attempt to create the document file
            let url = try LocalStorage.createDocumentFile(
                jobId:jobId,
                fileType: creationParams.isDocumentFrontSide ? FileType.documentFront : FileType.documentBack,
                document: data
            )
            
            let result = DocumentCaptureResult(
                documentFrontFile: creationParams.isDocumentFrontSide ? url.absoluteString : nil,
                documentBackFile: creationParams.isDocumentFrontSide ? nil : url.absoluteString
            )
            
            completion?(.success(result))
            uiViewController?.popViewController(animated: true)
            
        } catch {
            didError(error: error)
        }
    }
    
    func onSkip() {
        completion?(.failure(PigeonError(code: "20", message: "User skipped document capture", details: nil)))
        uiViewController?.popViewController(animated: true)
    }
    
    func didError(error: Error) {
        completion?(.failure(PigeonError(code: "20", message: error.localizedDescription, details: nil)))
        uiViewController?.popViewController(animated: true)
    }
}
