import Foundation
import SwiftUI
import Flutter

public class SmileIDProductsPluginApi: SmileIDProductsApi {
    
    var navigationController : UINavigationController? {
        if let controller = UIApplication.shared.delegate?.window??.rootViewController as? SmileIDOrientationNavigationController {
            controller.supportedInterfaceOrientations = .portrait
            return controller
        }
        
        if let controller = UIApplication.shared.delegate?.window??.rootViewController as? UINavigationController {
            return controller
        }
        
        return nil
    }
    
    public static func setUp(binaryMessenger: FlutterBinaryMessenger) {
        let api = SmileIDProductsPluginApi()
        SmileIDProductsApiSetup.setUp(binaryMessenger: binaryMessenger, api: api)
        
        let window = UIApplication.shared.delegate?.window
        
        // early return as we don't need to attach a root controller
        if let controller = window??.rootViewController as? UINavigationController {
            return;
        }
        
        if  let controller = window??.rootViewController as?
                UIViewController {
            let navigationController = SmileIDOrientationNavigationController(rootViewController: controller)
            navigationController.systemOrientation = controller.supportedInterfaceOrientations // set system orientation to system default
            navigationController.supportedInterfaceOrientations = controller.supportedInterfaceOrientations
            
            navigationController.isNavigationBarHidden = true
            window??.rootViewController = navigationController
            window??.makeKeyAndVisible()
            return
        }
    }
    
    func smartSelfieEnrollment(creationParams: SmartSelfieCreationParams, completion: @escaping (Result<SmartSelfieCaptureResult, any Error>) -> Void) {
        
        if let controller = navigationController {
            let smileIdSelfieEnrollmentViewController = UIHostingController(rootView: SmileIDSmartSelfieEnrollmentView(creationParams: creationParams, completion: completion, uiViewController: controller))
            smileIdSelfieEnrollmentViewController.overrideUserInterfaceStyle = .light
            controller.pushViewController(smileIdSelfieEnrollmentViewController, animated: true)
            return
        }
        
        completion(.failure(PigeonError(code: "12", message: errorMessageForNilNavigationController(productName: "smart selfie enrollment"), details: nil)))
    }
    
    func smartSelfieAuthentication(creationParams: SmartSelfieCreationParams, completion: @escaping (Result<SmartSelfieCaptureResult, any Error>) -> Void) {
        
        if let controller = navigationController {
            let smileIdSelfieAuthenticationController = UIHostingController(rootView: SmileIDSmartSelfieAuthenticationView(creationParams: creationParams, completion: completion, uiViewController: controller))
            smileIdSelfieAuthenticationController.overrideUserInterfaceStyle = .light
            
            controller.pushViewController(smileIdSelfieAuthenticationController, animated: true)
            return
        }
        
        completion(.failure(PigeonError(code: "13", message: errorMessageForNilNavigationController(productName: "smart selfie authentication"), details: nil)))
    }
    
    func smartSelfieEnrollmentEnhanced(creationParams: SmartSelfieEnhancedCreationParams, completion: @escaping (Result<SmartSelfieCaptureResult, any Error>) -> Void) {
        
        if let controller = navigationController {
            let smileIdSelfieEnrollmentEnhancedController = UIHostingController(rootView: SmileIDSmartSelfieEnrollmentEnhancedView(creationParams: creationParams, completion: completion, uiViewController: controller))
            smileIdSelfieEnrollmentEnhancedController.overrideUserInterfaceStyle = .light
            
            controller.pushViewController(smileIdSelfieEnrollmentEnhancedController, animated: true)
            return
        }
        
        completion(
            .failure(PigeonError(code: "14", message: errorMessageForNilNavigationController(productName: "smart selfie enrollment enhanced"), details: nil))
        )
    }
    
    func smartSelfieAuthenticationEnhanced(creationParams: SmartSelfieEnhancedCreationParams, completion: @escaping (Result<SmartSelfieCaptureResult, any Error>) -> Void) {
        
        if let controller = navigationController {
            let smileIDSelfieAuthenticationEnhancedController = UIHostingController(
                rootView: SmileIDSmartSelfieAuthenticationEnhancedView(creationParams: creationParams, completion: completion, uiViewController: controller))
            smileIDSelfieAuthenticationEnhancedController.overrideUserInterfaceStyle = .light
            
            controller.pushViewController(smileIDSelfieAuthenticationEnhancedController, animated: true)
            return
        }
        
        completion(
            .failure(PigeonError(code: "15", message: errorMessageForNilNavigationController(productName: "smart selfie authentication enhance"), details: nil))
        )
    }
    
    func biometricKYC(creationParams: BiometricKYCCreationParams, completion: @escaping (Result<BiometricKYCCaptureResult, any Error>) -> Void) {
        if let controller = navigationController {
            let smileIDBiometricKYCController = UIHostingController(
                rootView: SmileIDBiometricKYCView(creationParams: creationParams, completion: completion, uiViewController: controller))
            smileIDBiometricKYCController.overrideUserInterfaceStyle = .light
            
            controller.pushViewController(smileIDBiometricKYCController, animated: true)
            return
        }
        
        completion(.failure(PigeonError(code: "16", message: errorMessageForNilNavigationController(productName: "biometric kyc"), details: nil)))
    }
    
    func documentVerification(creationParams: DocumentVerificationCreationParams, completion: @escaping (Result<DocumentCaptureResult, any Error>) -> Void) {
        if let controller = navigationController {
            let smileIDDocumentVerificationController = UIHostingController(
                rootView: SmileIDDocumentVerificationView(creationParams: creationParams, completion: completion, uiViewController: controller))
            smileIDDocumentVerificationController.overrideUserInterfaceStyle = .light
            
            controller.pushViewController(smileIDDocumentVerificationController, animated: true)
            return
        }
        
        completion(.failure(PigeonError(code: "17", message: errorMessageForNilNavigationController(productName: "document verification"), details: nil)))
    }
    
    func documentVerificationEnhanced(creationParams: DocumentVerificationEnhancedCreationParams, completion: @escaping (Result<DocumentCaptureResult, any Error>) -> Void) {
        if let controller = navigationController {
            let smileIDEnhancedDocumentVerificationController = UIHostingController(
                rootView: SmileIDEnhancedDocumentVerificationView(creationParams: creationParams, completion: completion, uiViewController: controller))
            smileIDEnhancedDocumentVerificationController.overrideUserInterfaceStyle = .light
            
            controller.pushViewController(smileIDEnhancedDocumentVerificationController, animated: true)
            return
        }
        
        completion(.failure(PigeonError(code: "18", message: errorMessageForNilNavigationController(productName: "enhanced document verification"), details: nil)))
    }
    
    
    func selfieCapture(creationParams: SelfieCaptureViewCreationParams, completion: @escaping (Result<SmartSelfieCaptureResult, any Error>) -> Void) {
        if let controller = navigationController {
            let smileSelfieCaptureController = UIHostingController(
                rootView: SmileSelfieCaptureView(creationParams: creationParams, completion: completion, uiViewController: controller))
            smileSelfieCaptureController.overrideUserInterfaceStyle = .light
            
            controller.pushViewController(smileSelfieCaptureController, animated: true)
            return
        }
        
        completion(.failure(PigeonError(code: "19", message: errorMessageForNilNavigationController(productName: "selfie capture"), details: nil)))
    }
    
    func documentCapture(creationParams: DocumentCaptureCreationParams, completion: @escaping (Result<DocumentCaptureResult, any Error>) -> Void) {
        if let controller = navigationController {
            let smileDocumentCaptureController = UIHostingController(
                rootView: SmileDocumentCaptureView(creationParams: creationParams, completion: completion, uiViewController: controller))
            smileDocumentCaptureController.overrideUserInterfaceStyle = .light
            
            controller.pushViewController(smileDocumentCaptureController, animated: true)
            return
        }
        
        completion(.failure(PigeonError(code: "20", message: errorMessageForNilNavigationController(productName: "document capture"), details: nil)))
    }
}

public class SmileIDOrientationNavigationController: UINavigationController {
    var orientations = UIInterfaceOrientationMask.portrait
    public var systemOrientation = UIInterfaceOrientationMask.allButUpsideDown
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get { return self.orientations }
        set { self.orientations = newValue }
    }
    
    public override func popViewController(animated: Bool) -> UIViewController? {
        // revert orientation to system orientation
        supportedInterfaceOrientations = systemOrientation
        return super.popViewController(animated: animated)
    }
}

func errorMessageForNilNavigationController(productName: String) -> String {
    return "Failed to start \(productName), confirm that a UINavigationController is the root controller."
}
