import Foundation
import SwiftUI
import Flutter

public class SmileIDProductsPluginApi: SmileIDProductsApi {
  
    
    
    var navigationController: UINavigationController? = nil
    
    public static func setUp(binaryMessenger: FlutterBinaryMessenger) {
        let api = SmileIDProductsPluginApi()
        SmileIDProductsApiSetup.setUp(binaryMessenger: binaryMessenger, api: api)
        
        let window = UIApplication.shared.delegate?.window
        if  let controller = window??.rootViewController as?
                UIViewController {
            let navigationController = UINavigationController(rootViewController: controller)
            
            navigationController.isNavigationBarHidden = true
            window??.rootViewController = navigationController
            window??.makeKeyAndVisible()
            
            api.navigationController = navigationController
            return
        }
        
        if let controller = window??.rootViewController as? UINavigationController {
            api.navigationController = controller
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
        
        completion(.failure(PigeonError(code: "12", message: "Failed to start smart selfie enrollment", details: nil)))
    }
    
    func smartSelfieAuthentication(creationParams: SmartSelfieCreationParams, completion: @escaping (Result<SmartSelfieCaptureResult, any Error>) -> Void) {
        
        if let controller = navigationController {
            let smileIdSelfieAuthenticationController = UIHostingController(rootView: SmileIDSmartSelfieAuthenticationView(creationParams: creationParams, completion: completion, uiViewController: controller))
            smileIdSelfieAuthenticationController.overrideUserInterfaceStyle = .light
            
            controller.pushViewController(smileIdSelfieAuthenticationController, animated: true)
            return
        }
        
        completion(.failure(PigeonError(code: "13", message: "Failed to start smart selfie authentication", details: nil)))
    }
    
    func smartSelfieEnrollmentEnhanced(creationParams: SmartSelfieEnhancedCreationParams, completion: @escaping (Result<SmartSelfieCaptureResult, any Error>) -> Void) {
        
        if let controller = navigationController {
            let smileIdSelfieEnrollmentEnhancedController = UIHostingController(rootView: SmileIDSmartSelfieEnrollmentEnhancedView(creationParams: creationParams, completion: completion, uiViewController: controller))
            smileIdSelfieEnrollmentEnhancedController.overrideUserInterfaceStyle = .light
            
            controller.pushViewController(smileIdSelfieEnrollmentEnhancedController, animated: true)
            return
        }
        
        completion(.failure(PigeonError(code: "14", message: "Failed to start smart selfie enrollment enhanced", details: nil)))
    }
    
    func smartSelfieAuthenticationEnhanced(creationParams: SmartSelfieEnhancedCreationParams, completion: @escaping (Result<SmartSelfieCaptureResult, any Error>) -> Void) {
        
        if let controller = navigationController {
            let smileIDSelfieAuthenticationEnhancedController = UIHostingController(
                rootView: SmileIDSmartSelfieAuthenticationEnhancedView(creationParams: creationParams, completion: completion, uiViewController: controller))
            smileIDSelfieAuthenticationEnhancedController.overrideUserInterfaceStyle = .light
            
            controller.pushViewController(smileIDSelfieAuthenticationEnhancedController, animated: true)
            return
        }
        
        completion(.failure(PigeonError(code: "15", message: "Failed to start smart selfie authentication enhance", details: nil)))
    }
    
    func biometricKYC(creationParams: BiometricKYCCreationParams, completion: @escaping (Result<BiometricKYCCaptureResult, any Error>) -> Void) {
        if let controller = navigationController {
            let smileIDBiometricKYCController = UIHostingController(
                rootView: SmileIDBiometricKYCView(creationParams: creationParams, completion: completion, uiViewController: controller))
            smileIDBiometricKYCController.overrideUserInterfaceStyle = .light
            
            controller.pushViewController(smileIDBiometricKYCController, animated: true)
            return
        }
        
        completion(.failure(PigeonError(code: "16", message: "Failed to start biometric kyc", details: nil)))
    }
    
    func documentVerification(creationParams: DocumentVerificationCreationParams, completion: @escaping (Result<DocumentCaptureResult, any Error>) -> Void) {
        if let controller = navigationController {
            let smileIDDocumentVerificationController = UIHostingController(
                rootView: SmileIDDocumentVerificationView(creationParams: creationParams, completion: completion, uiViewController: controller))
            smileIDDocumentVerificationController.overrideUserInterfaceStyle = .light
            
            controller.pushViewController(smileIDDocumentVerificationController, animated: true)
            return
        }
        
        completion(.failure(PigeonError(code: "17", message: "Failed to start document verification", details: nil)))
    }
    
    func documentVerificationEnhanced(creationParams: DocumentVerificationEnhancedCreationParams, completion: @escaping (Result<DocumentCaptureResult, any Error>) -> Void) {
        if let controller = navigationController {
            let smileIDEnhancedDocumentVerificationController = UIHostingController(
            rootView: SmileIDEnhancedDocumentVerificationView(creationParams: creationParams, completion: completion, uiViewController: controller))
            smileIDEnhancedDocumentVerificationController.overrideUserInterfaceStyle = .light
            
            controller.pushViewController(smileIDEnhancedDocumentVerificationController, animated: true)
            return
        }
        
        completion(.failure(PigeonError(code: "18", message: "Failed to start enhanced document verification", details: nil)))
    }
    
   
    func selfieCapture(creationParams: SmartSelfieCreationParams, completion: @escaping (Result<SmartSelfieCaptureResult, any Error>) -> Void) {
        
    }
    
    func documentCapture(creationParams: DocumentCaptureCreationParams, completion: @escaping (Result<DocumentCaptureResult, any Error>) -> Void) {
        
    }
}
