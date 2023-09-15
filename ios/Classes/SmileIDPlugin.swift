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

    let factory = SmileIDDocumentVerification.Factory(messenger: registrar.messenger())
    registrar.register(factory, withId: SmileIDDocumentVerification.viewTypeId)
  }

    func authenticate(request: FlutterAuthenticationRequest, completion: @escaping (Result<FlutterAuthenticationResponse, Error>) -> Void) {
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

  func initialize() {
    SmileID.initialize()
  }

  func doEnhancedKycAsync(request: FlutterEnhancedKycRequest,
                          completion: @escaping (Result<FlutterEnhancedKycAsyncResponse, Error>) -> Void) {
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
