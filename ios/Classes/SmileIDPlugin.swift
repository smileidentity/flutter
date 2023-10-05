import Flutter
import UIKit
import SmileID
import Combine

public class SmileIDPlugin: NSObject, FlutterPlugin, SmileIDApi {
    private var subscribers = Set<AnyCancellable>()
    public static func register(with registrar: FlutterPluginRegistrar) {
        let messenger: FlutterBinaryMessenger = registrar.messenger()
        let api: SmileIDApi & NSObjectProtocol = SmileIDPlugin()
        SmileIDApiSetup.setUp(binaryMessenger: messenger, api: api)

        let documentVerificationFactory = SmileIDDocumentVerification.Factory(
            messenger: registrar.messenger()
        )
        registrar.register(
            documentVerificationFactory,
            withId: SmileIDDocumentVerification.VIEW_TYPE_ID
        )

        let smartSelfieEnrollmentFactory = SmileIDSmartSelfieEnrollment.Factory(
            messenger: registrar.messenger()
        )
        registrar.register(
            smartSelfieEnrollmentFactory,
            withId: SmileIDSmartSelfieEnrollment.VIEW_TYPE_ID
        )

        let smartSelfieAuthenticationFactory = SmileIDSmartSelfieAuthentication.Factory(
            messenger: registrar.messenger()
        )
        registrar.register(
            smartSelfieAuthenticationFactory,
            withId: SmileIDSmartSelfieAuthentication.VIEW_TYPE_ID
        )
    }

    func initialize() {
        SmileID.initialize()
    }

    func authenticate(
        request: FlutterAuthenticationRequest,
        completion: @escaping (Result<FlutterAuthenticationResponse, Error>
    ) -> Void) {
        SmileID.api.authenticate(request: request.toRequest())
            .sink(receiveCompletion: { status in
                switch status {
                case .failure(let error):
                    completion(.failure(error))
                default:
                    break
                }
            }, receiveValue: { response in
                completion(.success(response.toResponse()))
            }).store(in: &subscribers)
    }

    func doEnhancedKycAsync(
        request: FlutterEnhancedKycRequest,
        completion: @escaping (Result<FlutterEnhancedKycAsyncResponse, Error>
    ) -> Void) {
        SmileID.api.doEnhancedKycAsync(request: request.toRequest())
            .sink(receiveCompletion: { status in
                switch status {
                case .failure(let error):
                    completion(.failure(error))
                default:
                    break
                }
          }, receiveValue: { response in
              completion(.success(response.toFlutterResponse()))
          }).store(in: &subscribers)
    }
}
