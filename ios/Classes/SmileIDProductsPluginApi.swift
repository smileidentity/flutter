import Foundation
import SwiftUI
import Flutter

public class SmileIDProductsPluginApi: SmileIDProductsApi {
    
    public static func setUp(binaryMessenger: FlutterBinaryMessenger) {
        let api = SmileIDProductsPluginApi()
        SmileIDProductsApiSetup.setUp(binaryMessenger: binaryMessenger, api: api)
    }
    
    func smartSelfieEnrollment(creationParams: SmartSelfieCreationParams, completion: @escaping (Result<SmartSelfieCaptureResult, any Error>) -> Void) {
        
        let window = UIApplication.shared.delegate?.window
        if let controller = window??.rootViewController as? UINavigationController {
            let smileIdSelfieEnrollmentViewController = UIHostingController(rootView: SmileIDSmartSelfieEnrollmentView(creationParams: creationParams, completion: completion, uiViewController: controller))
            
            controller.pushViewController(smileIdSelfieEnrollmentViewController, animated: true)
            return
        }
        
        completion(.failure(PigeonError(code: "12", message: "Failed to start smart selfie enrollment", details: nil)))
    }
    
    func smartSelfieAuthentication(creationParams: SmartSelfieCreationParams, completion: @escaping (Result<SmartSelfieCaptureResult, any Error>) -> Void) {
        let window = UIApplication.shared.delegate?.window
        if let controller = window??.rootViewController as? UINavigationController {
            let smileIdSelfieAuthenticationController = UIHostingController(rootView: SmileIDSmartSelfieAuthenticationView(creationParams: creationParams, completion: completion, uiViewController: controller))
            
            controller.pushViewController(smileIdSelfieAuthenticationController, animated: true)
            return
        }
        
        completion(.failure(PigeonError(code: "13", message: "Failed to start smart selfie authentication", details: nil)))
    }
    
    func smartSelfieEnrollmentEnhanced(creationParams: SmartSelfieEnhancedCreationParams, completion: @escaping (Result<SmartSelfieCaptureResult, any Error>) -> Void) {
        let window = UIApplication.shared.delegate?.window
        if let controller = window??.rootViewController as? UINavigationController {
            let smileIdSelfieEnrollmentEnhancedController = UIHostingController(rootView: SmileIDSmartSelfieEnrollmentEnhancedView(creationParams: creationParams, completion: completion, uiViewController: controller))
            
            controller.pushViewController(smileIdSelfieEnrollmentEnhancedController, animated: true)
            return
        }
        
        completion(.failure(PigeonError(code: "14", message: "Failed to start smart selfie enrollment enhanced", details: nil)))
    }
    
    func smartSelfieAuthenticationEnhanced(creationParams: SmartSelfieEnhancedCreationParams, completion: @escaping (Result<SmartSelfieCaptureResult, any Error>) -> Void) {
        let window = UIApplication.shared.delegate?.window
        if let controller = window??.rootViewController as? UINavigationController {
            let smileIDSelfieAuthenticationEnhancedController = UIHostingController(
                rootView: SmileIDSmartSelfieAuthenticationEnhancedView(creationParams: creationParams, completion: completion, uiViewController: controller))
            
            controller.pushViewController(smileIDSelfieAuthenticationEnhancedController, animated: true)
            return
        }
        
        completion(.failure(PigeonError(code: "15", message: "Failed to start smart selfie authentication enhance", details: nil)))
    }
}
