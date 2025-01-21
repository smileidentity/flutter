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
            let smileIdSelfieEnrollmentViewController = PortraitHostingController(rootView: SmileIDSmartSelfieEnrollmentView(creationParams: creationParams, completion: completion, uiViewController: controller))
            
            controller.pushViewController(smileIdSelfieEnrollmentViewController, animated: true)
            return
        }
        
        completion(.failure(PigeonError(code: "12", message: "Failed to start smart selfie enrollment", details: nil)))
    }
    
    func smartSelfieAuthentication(creationParams: SmartSelfieCreationParams, completion: @escaping (Result<SmartSelfieCaptureResult, any Error>) -> Void) {
        
        if let controller = navigationController {
            let smileIdSelfieAuthenticationController = PortraitHostingController(rootView: SmileIDSmartSelfieAuthenticationView(creationParams: creationParams, completion: completion, uiViewController: controller))
            
            controller.pushViewController(smileIdSelfieAuthenticationController, animated: true)
            return
        }
        
        completion(.failure(PigeonError(code: "13", message: "Failed to start smart selfie authentication", details: nil)))
    }
    
    func smartSelfieEnrollmentEnhanced(creationParams: SmartSelfieEnhancedCreationParams, completion: @escaping (Result<SmartSelfieCaptureResult, any Error>) -> Void) {
        
        if let controller = navigationController {
            let smileIdSelfieEnrollmentEnhancedController = PortraitHostingController(rootView: SmileIDSmartSelfieEnrollmentEnhancedView(creationParams: creationParams, completion: completion, uiViewController: controller))
            
            controller.pushViewController(smileIdSelfieEnrollmentEnhancedController, animated: true)
            return
        }
        
        completion(.failure(PigeonError(code: "14", message: "Failed to start smart selfie enrollment enhanced", details: nil)))
    }
    
    func smartSelfieAuthenticationEnhanced(creationParams: SmartSelfieEnhancedCreationParams, completion: @escaping (Result<SmartSelfieCaptureResult, any Error>) -> Void) {
        
        if let controller = navigationController {
            let smileIDSelfieAuthenticationEnhancedController = PortraitHostingController(
                rootView: SmileIDSmartSelfieAuthenticationEnhancedView(creationParams: creationParams, completion: completion, uiViewController: controller))
            
            controller.pushViewController(smileIDSelfieAuthenticationEnhancedController, animated: true)
            return
        }
        
        completion(.failure(PigeonError(code: "15", message: "Failed to start smart selfie authentication enhance", details: nil)))
    }
}

class PortraitHostingController<Content>: UIHostingController<Content> where Content: View {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
}
