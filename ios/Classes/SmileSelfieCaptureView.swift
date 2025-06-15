import SwiftUI
import SmileID

struct SmileSelfieCaptureView: View, SmileIDFileUtilsProtocol, SmartSelfieResultDelegate {
    
    
    var fileManager: FileManager = Foundation.FileManager.default
    @State private var acknowledgedInstructions = false
    
    let creationParams: SelfieCaptureViewCreationParams
    let completion: ((Result<SmartSelfieCaptureResult, any Error>) -> Void)?
    weak var uiViewController: UINavigationController?
    
    @ObservedObject private var _viewModel: SelfieViewModel = SelfieViewModel(
        isEnroll: false,
        userId: generateUserId(),
        jobId: generateJobId(),
        allowNewEnroll: false,
        skipApiSubmission: true,
        extraPartnerParams: [:],
    )
    
    var body: some View {
        VStack(alignment: .leading) {
            Button("Back") {
                completion?(.failure(PigeonError(code: "19", message: "User cancelled operation", details: nil)))
                uiViewController?.popViewController(animated: true)
            }.padding(.leading, 20)
            
            NavigationView {
                Group {
                    if creationParams.showInstructions, !acknowledgedInstructions {
                        SmartSelfieInstructionsScreen(showAttribution: creationParams.showAttribution) {
                            acknowledgedInstructions = true
                        }
                        .padding()
                    } else if _viewModel.processingState != nil {
                        Color.clear.onAppear {
                            self._viewModel.onFinished(callback: self)
                        }
                    } else if let selfieToConfirm = _viewModel.selfieToConfirm {
                        if (creationParams.showConfirmationDialog) {
                            ImageCaptureConfirmationDialog(
                                title: SmileIDResourcesHelper.localizedString(for: "Confirmation.GoodSelfie"),
                                subtitle: SmileIDResourcesHelper.localizedString(for: "Confirmation.FaceClear"),
                                image: UIImage(data: selfieToConfirm)!,
                                confirmationButtonText: SmileIDResourcesHelper.localizedString(for: "Confirmation.YesUse"),
                                onConfirm: _viewModel.submitJob,
                                retakeButtonText: SmileIDResourcesHelper.localizedString(for: "Confirmation.Retake"),
                                onRetake: _viewModel.onSelfieRejected,
                                scaleFactor: 1.25
                            ).preferredColorScheme(.light)
                        } else {
                            Color.clear.onAppear {
                                self._viewModel.submitJob()
                            }
                        }
                    } else {
                        SelfieCaptureScreen(
                            viewModel: _viewModel,
                            allowAgentMode: creationParams.allowAgentMode
                        ).preferredColorScheme(.light)
                    }
                }
            }
            .frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        }
    }
    
    func didSucceed(selfieImage: URL, livenessImages: [URL], apiResponse: SmartSelfieResponse?) {
        let result = SmartSelfieCaptureResult(
            selfieFile: getFilePath(fileName: selfieImage.absoluteString),
            livenessFiles: livenessImages.map{
                getFilePath(fileName: $0.absoluteString)
            }, apiResponse: apiResponse?.buildResponse()
        )
        
        completion?(.success(result))
        uiViewController?.popViewController(animated: true)
    }
    
    func didError(error: any Error) {
        completion?(.failure(PigeonError(code: "19", message: error.localizedDescription, details: nil)))
        uiViewController?.popViewController(animated: true)
    }
}
